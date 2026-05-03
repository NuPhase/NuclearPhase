#define GEN_MODE_OFF   0
#define GEN_MODE_RUNUP 1
#define GEN_MODE_SYNC  2

#define GEN_POWER_LIMIT 10000000
#define GEN_HEAT_CAPACITY 20000000
#define GEN_SYNC_RPM 1800

#define GEN_MAX_SAFE_TEMP 390
#define GEN_MAX_WORK_TEMP 490

/obj/machinery/multitile/backup_generator
	name = "backup generator"
	icon = 'icons/obj/machines/diesel_generator.dmi'
	icon_state = "large"

	map_port_volume = 500
	spawn_power_terminal = TRUE
	interact_offline = TRUE

	width = 1
	height = 2
	bound_width = 64
	bound_height = 96

	map_ports = list(
		list(0, 1, WEST, "Oil"),
		list(0, 2, WEST, "Startup Air"),
		list(1, 0, EAST, "Fuel"),
		list(1, 1, EAST, "Oxidizer"),
		list(1, 2, NORTH, "Exhaust")
	)

	var/last_load = 0
	var/mode = GEN_MODE_OFF
	var/unburnt_fuel_ratio = 0.01
	var/gen_temp = 30 CELSIUS
	var/rpm = 0
	var/cur_fuel_consumption = 0
	var/lerp_fuel_consumption = 0

	var/datum/sound_token/sound_token
	var/sound_id

/obj/machinery/multitile/backup_generator/on/Initialize()
	. = ..()
	switch_mode(GEN_MODE_SYNC)

/obj/machinery/multitile/backup_generator/proc/start()
	if(mode != GEN_MODE_OFF && check_trip())
		return
	switch_mode(GEN_MODE_RUNUP)
	playsound(src, 'sound/machines/gas_turbine/start.mp3', 100, 0)

/obj/machinery/multitile/backup_generator/proc/stop()
	if(mode != GEN_MODE_SYNC)
		return
	switch_mode(GEN_MODE_OFF)
	playsound(src, 'sound/machines/gas_turbine/stop.mp3', 100, 0)

/obj/machinery/multitile/backup_generator/Initialize()
	. = ..()
	sound_id = "[type]_[sequential_id(/obj/machinery/multitile/backup_generator)]"

/obj/machinery/multitile/backup_generator/Process()
	last_load = 0
	lerp_fuel_consumption = Interpolate(lerp_fuel_consumption, cur_fuel_consumption, 0.1)
	cur_fuel_consumption = 0
	handle_cooling()
	check_trip()
	switch(mode)
		if(GEN_MODE_OFF)
			if(rpm > 0)
				rpm = max(0, rpm - rand(90, 270))
		if(GEN_MODE_RUNUP)
			var/datum/gas_mixture/start_air = port_gases["Startup Air"]
			start_air.remove(35)
			rpm += rand(30, 90)
			if(rpm > GEN_SYNC_RPM)
				switch_mode(GEN_MODE_SYNC)
		if(GEN_MODE_SYNC)
			on_power_drain(50000)

/obj/machinery/multitile/backup_generator/proc/trip(reason)
	if(mode != GEN_MODE_OFF)
		switch_mode(GEN_MODE_OFF)
		playsound(src, 'sound/effects/alarms/buzzer.mp3', 100)
		visible_message(SPAN_WARNING("[src] trips! Reason: [reason]."))
	return

/obj/machinery/multitile/backup_generator/proc/check_trip()
	var/datum/gas_mixture/fuel = port_gases["Fuel"]
	var/datum/gas_mixture/oxidizer = port_gases["Oxidizer"]
	var/datum/gas_mixture/exhaust = port_gases["Exhaust"]
	var/datum/gas_mixture/start_air = port_gases["Startup Air"]
	if(fuel.pressure < ONE_ATMOSPHERE)
		trip("Low fuel pressure")
		return FALSE
	if(oxidizer.pressure < ONE_ATMOSPHERE)
		trip("Low oxidizer pressure")
		return FALSE
	if(exhaust.pressure > 100 * ONE_ATMOSPHERE)
		trip("High exhaust pressure")
		return FALSE
	if(start_air.pressure < ONE_ATMOSPHERE && mode != GEN_MODE_SYNC)
		trip("Low start air pressure")
		return FALSE
	if(gen_temp > GEN_MAX_WORK_TEMP)
		trip("Temperature too high")
		return FALSE
	return TRUE

/obj/machinery/multitile/backup_generator/proc/switch_mode(nmode)
	if(mode == nmode)
		return
	mode = nmode
	if(nmode == GEN_MODE_SYNC)
		rpm = GEN_SYNC_RPM
		if(!sound_token)
			sound_token = play_looping_sound(src, sound_id, 'sound/machines/gas_turbine/run.mp3', 50, 10)
	if(nmode == GEN_MODE_OFF)
		QDEL_NULL(sound_token)

/obj/machinery/multitile/backup_generator/proc/get_efficiency()
	if(last_load > 1000000)
		return 0.37
	return 0.443

/obj/machinery/multitile/backup_generator/available_power()
	if(mode == GEN_MODE_SYNC)
		return GEN_POWER_LIMIT
	return 0

/obj/machinery/multitile/backup_generator/get_voltage()
	return 4400

/obj/machinery/multitile/backup_generator/on_power_drain(w)
	var/datum/gas_mixture/fuel = port_gases["Fuel"]
	var/datum/gas_mixture/oxidizer = port_gases["Oxidizer"]
	var/datum/gas_mixture/exhaust = port_gases["Exhaust"]

	var/combustion_value_sum = 0
	var/oxidizer_ratio_sum = 0
	var/largest_fuel_type
	var/largest_fuel_amount = 0
	var/alist/all_fuel = fuel.get_fluid()
	for(var/mat_type, mat_amt in all_fuel)
		var/decl/material/mat = GET_DECL(mat_type)
		if(!mat.combustion_energy)
			continue
		if(mat_amt > largest_fuel_amount)
			largest_fuel_type = mat_type
		combustion_value_sum += mat.combustion_energy * mat_amt
		oxidizer_ratio_sum += mat.oxidizer_to_fuel_ratio * mat_amt
	var/combustion_energy = combustion_value_sum / fuel.total_moles
	var/ox_to_fuel_ratio = oxidizer_ratio_sum / fuel.total_moles

	var/oxidizer_moles = 0
	var/alist/all_oxidizer = oxidizer.get_fluid()
	for(var/mat_type, mat_amt in all_oxidizer)
		var/decl/material/mat = GET_DECL(mat_type)
		if(!mat.oxidizer_power)
			continue
		oxidizer_moles += mat_amt
	var/oxidizer_ratio = oxidizer_moles / oxidizer.total_moles

	var/our_efficiency = get_efficiency()
	var/required_energy = w / our_efficiency
	var/required_fuel = required_energy / combustion_energy
	var/required_oxidizer = (required_fuel * ox_to_fuel_ratio) / oxidizer_ratio

	last_load += w
	cur_fuel_consumption += required_fuel * fuel.specific_mass()

	var/decl/material/fuel_mat = GET_DECL(largest_fuel_type)
	fuel.remove(required_fuel)
	oxidizer.remove(required_oxidizer)
	exhaust.adjust_gas(fuel_mat.burn_product, required_fuel, FALSE, FALSE)
	var/waste_heat_2 = (required_energy - w) * 0.5
	exhaust.add_thermal_energy(waste_heat_2)
	exhaust.merge(fuel.remove(required_fuel * unburnt_fuel_ratio))
	gen_temp += waste_heat_2 / GEN_HEAT_CAPACITY

/obj/machinery/multitile/backup_generator/proc/handle_cooling()
	var/datum/gas_mixture/coolant = port_gases["Oil"]
	var/t_diff = gen_temp - 334
	if(abs(t_diff) < 10)
		return
	var/heat_transfer = min(t_diff * (GEN_POWER_LIMIT / 70), coolant.heat_capacity*100)
	coolant.add_thermal_energy(heat_transfer)
	gen_temp -= heat_transfer / GEN_HEAT_CAPACITY

/obj/machinery/multitile/backup_generator/interface_interact(mob/user)
	tgui_interact(user)
	return TRUE

/obj/machinery/multitile/backup_generator/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BackupGenerator", "Generator Panel")
		ui.open()
		ui.set_autoupdate(1)

/obj/machinery/multitile/backup_generator/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(action == "stop")
		stop()
		return
	if(action == "start")
		start()
		return

/obj/machinery/multitile/backup_generator/tgui_data(mob/user)
	return list(
		"rpm" = rpm,
		"load" = last_load,
		"temperature" = gen_temp - 273.15,
		"fuelFlow" = lerp_fuel_consumption * 3600,
		"efficiency" = get_efficiency() * 100
	)

#undef GEN_MODE_OFF
#undef GEN_MODE_RUNUP
#undef GEN_MODE_SYNC
#undef GEN_POWER_LIMIT
#undef GEN_HEAT_CAPACITY
#undef GEN_SYNC_RPM
#undef GEN_MAX_SAFE_TEMP
#undef GEN_MAX_WORK_TEMP