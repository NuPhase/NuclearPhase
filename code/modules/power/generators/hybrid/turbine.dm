#define TURBINE_MOMENT_OF_INERTIA 1327000
#define TURBINE_PERFECT_RPM 3550
#define TURBINE_ABNORMAL_RPM 4000
#define TURBINE_MAX_RPM 10000

#define PORT_STEAM_IN "Steam In"
#define PORT_STEAM_OUT "Steam Out"

/obj/machinery/multitile/steam_turbine
	name = "steam turbine"
	desc = "A gas turbine. Converting pressure into energy since 1884."
	icon = 'icons/obj/engine/turbine_stage.dmi'
	icon_state = "off"
	layer = ABOVE_OBJ_LAYER
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	dir = 8

	map_ports = list(
		list(13, 1, EAST, PORT_STEAM_OUT),
		list(12, 1, SOUTH, PORT_STEAM_IN)
	)
	map_port_volume = 40000
	width = 13
	height = 3

	use_power = POWER_USE_IDLE
	idle_power_usage = 2000 //we have to keep it warm
	active_power_usage = 40000 //balancing systems, hydraulics, computing, etc

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/noninteractive

	var/feeder_valve_openage = 0
	var/efficiency = 0.93
	var/kin_energy = 0
	var/kin_total = 0 //last kin energy generation
	var/expansion_ratio = 0.244755
	var/volume_ratio = 0.2
	var/steam_velocity = 0
	var/pressure_difference = 0
	var/total_mass_flow = 0
	var/rpm = 0
	var/braking = FALSE //emergency brakes
	var/vibration = 0 //0-25 is minor, 25-50 is major, anything above is critical

	//for logging and interfaces
	var/inlet_temperature = T20C
	var/exhaust_temperature = T20C
	var/inlet_pressure = 0
	var/exhaust_pressure = 0
	var/real_expansion = 1 //inlet_pressure / exhaust_pressure
	var/kinetic_energy_delta = 0 // (kin_total - generator.last_load) * 3600

	var/water_level = 0 //0-1. Condensation inside turbine increases water level
	var/water_grates_open = FALSE

	var/rotor_integrity = 100
	var/shaft_integrity = 100

	var/obj/machinery/power/generator/turbine_generator/generator = null

	var/valve_id = ""

	failure_chance = 10

	var/datum/sound_token/sound_token
	var/sound_id

/obj/machinery/multitile/steam_turbine/proc/get_vibration_flavor()
	switch(vibration)
		if(0 to 25)
			return "low"
		if(26 to 50)
			return "medium"
		if(51 to INFINITY)
			return "high"

/obj/machinery/multitile/steam_turbine/Initialize()
	. = ..()
	sound_id = "[/obj/machinery/multitile/steam_turbine]_[sequential_id(/obj/machinery/multitile/steam_turbine)]"
	reactor_components[uid] = src

/obj/machinery/multitile/steam_turbine/fail_roundstart()
	. = ..()
	rotor_integrity = 100 - (SSticker.mode.difficulty / rand(1,3))
	shaft_integrity = 100 - (SSticker.mode.difficulty / 2)

/obj/machinery/multitile/steam_turbine/proc/get_specific_enthalpy(npres, ntemp)
	if(ntemp > 450)
		return 4127119 //Hooked to steam table API
	return 40000

/obj/machinery/multitile/steam_turbine/proc/get_density(npres, ntemp)
	return 2.16 //Hooked to steam table API

/obj/machinery/multitile/steam_turbine/Process()
	var/datum/gas_mixture/air1 = port_gases[PORT_STEAM_IN]

	if(air1.total_moles)
		process_steam()
	else
		total_mass_flow = 0
		steam_velocity = 0
		kin_total = 0

	kinetic_energy_delta = kin_total - generator.last_load

	rpm = sqrt(2 * kin_energy / TURBINE_MOMENT_OF_INERTIA) * 60 / 6.2831

	if(braking)
		var/datum/gas_mixture/environment = loc.return_air()
		kin_energy = max(0, kin_energy * 0.95 - 10000)
		if(kin_energy)
			environment.add_thermal_energy(kin_energy * 0.005 + 10000)

	apply_vibration_effects()
	calculate_efficiency()

	if(rpm > 200)
		use_power = POWER_USE_ACTIVE
		if(!sound_token)
			spool_up()
		on_rpm_change(rpm)
	else
		spool_down()
		use_power = POWER_USE_IDLE

/obj/machinery/multitile/steam_turbine/proc/process_steam()
	var/datum/gas_mixture/air1 = port_gases[PORT_STEAM_IN]
	var/datum/gas_mixture/air2 = port_gases[PORT_STEAM_OUT]

	var/air1_density = get_density(air1.return_pressure() * 0.001, air1.temperature - 273.15)

	//calculate flow velocity
	// sqrt((2 * (P1 - P2) / rho) + (2 * g * (h1 - h2)))
	if(feeder_valve_openage)
		pressure_difference = max(air1.return_pressure() - air2.return_pressure(), 0)
		steam_velocity = sqrt((2 * pressure_difference / air1_density) + (2 * GRAVITY_CONSTANT))
	else
		steam_velocity = 0

	//calculate flow mass
	//Steam enters at 1.5m diameter, expands to 5.5m. 5.5m diameter > area = 95.03
	total_mass_flow = feeder_valve_openage*95.03*expansion_ratio*0.598*sqrt(steam_velocity * 4.2 * (1-(air2.return_pressure()/air1.return_pressure())**0.23))
	var/mass_difference = total_mass_flow - air1.get_mass()
	if(mass_difference > 0)
		air1.suction_moles = mass_difference / air1.specific_mass()
	else
		air1.suction_moles = 0
	total_mass_flow = min(total_mass_flow, air1.get_mass())

	//create the internal gas mixture and transfer inlet steam to it
	var/datum/gas_mixture/air_all = new(air1.volume * (feeder_valve_openage + 0.05))
	pump_passive(air1, air_all, total_mass_flow)

	//logging
	inlet_temperature = air_all.temperature
	inlet_pressure = air1.return_pressure()

	//get the kinetic energy received from steam and cool it down
	var/end_temperature = max(inlet_temperature * expansion_ratio, 390)
	var/temp_delta = inlet_temperature - end_temperature
	kin_total = (air_all.heat_capacity() * temp_delta) * efficiency
	air_all.temperature = end_temperature

	//logging
	exhaust_temperature = air_all.temperature
	exhaust_pressure = air_all.return_pressure()

	//let water accumulate inside the turbine if the exhaust steam is too cold
	if(air_all.temperature < 340)
		if(water_grates_open)
			water_level += 0.01
		else
			water_level += 0.06
	else if(water_grates_open)
		water_level -= 0.05
	water_level = CLAMP01(water_level)

	var/windage_coef = rpm/3600
	kin_total -= (20 - (60 * windage_coef) + (60 * windage_coef * windage_coef)) * 300000

	kin_energy += kin_total * (rotor_integrity * 0.01)
	calculate_vibration(air_all)
	air2.merge(air_all)

	var/air2_pressure = air2.return_pressure()
	if(air2_pressure)
		real_expansion = air1.return_pressure() / air2_pressure
	else
		real_expansion = air1.return_pressure() / 0.001
	real_expansion = min(real_expansion, expansion_ratio)

/obj/machinery/multitile/steam_turbine/proc/calculate_efficiency()
	efficiency = 0.23
	if(water_grates_open)
		efficiency -= 0.15
	efficiency -= vibration * 0.005
	efficiency += rpm * 0.00025
	efficiency = Clamp(efficiency, 0.23, initial(efficiency))

/obj/machinery/multitile/steam_turbine/proc/calculate_vibration(var/datum/gas_mixture/turbine_internals)
	var/tvibration = 0
	//if(turbine_internals.liquids[/decl/material/liquid/water] > 100) //condensing inside of the turbine is incredibly dangerous
	//	tvibration += total_mass_flow * 0.004 * turbine_internals.liquids[/decl/material/liquid/water]
	if(total_mass_flow > 100 && rpm < 50) //that implies sudden increase in load on the generator and subsequent turbine stall
		tvibration += total_mass_flow * 0.06
	if(braking && total_mass_flow > 100) //hellish braking means hellish vibrations
		tvibration += 35
	if(rpm > TURBINE_ABNORMAL_RPM) //я твоя турбина вал шатал
		tvibration += (rpm - TURBINE_ABNORMAL_RPM)*0.12
	tvibration += water_level * 0.7
	tvibration += total_mass_flow * 0.005
	tvibration += (1 - (rotor_integrity/100)) * rpm * 0.005
	vibration = Interpolate(vibration, tvibration, 0.1)

/obj/machinery/multitile/steam_turbine/proc/apply_vibration_effects()
	switch(vibration)
		if(26 to 51)
			for(var/mob/living/carbon/human/H in range(world.view, loc))
				to_chat(H, SPAN_WARNING("All your surroundings vibrate like in an earthquake..."))
				shake_camera(H, 25, 0.8)
				if(prob(5))
					H.playsound_local(get_turf(src), 'sound/machines/vibrations.wav', 100, 0, extrarange = 30)
			rotor_integrity = max(0, rotor_integrity - 0.1)
		if(51 to INFINITY)
			for(var/mob/living/carbon/human/H in human_mob_list)
				if(get_dist(H.loc, loc) < 10)
					to_chat(H, SPAN_DANGER("Everything around you shakes and rattles like in a powerful earthquake!"))
					shake_camera(H, 25, 1.3)
				else if(get_dist(H.loc, loc) < 50)
					to_chat(H, SPAN_WARNING("Everything around you vibrates and resonates throughout your body, almost like something is tearing itself apart!"))
					shake_camera(H, 25, 0.2)
				if(prob(5))
					H.playsound_local(get_turf(H), 'sound/machines/vibrations_heavy.wav', 100, 0)
			rotor_integrity = max(0, rotor_integrity - 0.5)
			shaft_integrity = max(0, shaft_integrity - 0.1)
			if(prob(3))
				var/datum/effect/effect/system/smoke_spread/bad/smoke = new /datum/effect/effect/system/smoke_spread/bad()
				smoke.attach(src)
				smoke.set_up(10, 0, loc)
				smoke.start()

/obj/machinery/multitile/steam_turbine/proc/on_rpm_change(new_rpm)
	if(sound_token)
		sound_token.SetVolume((new_rpm / TURBINE_ABNORMAL_RPM) * 300)
		sound_token.sound.frequency = max(new_rpm / TURBINE_PERFECT_RPM, 0.1)

/obj/machinery/multitile/steam_turbine/proc/spool_up()
	sound_token = play_looping_sound(src, sound_id, 'sound/machines/turbine_mid.ogg', 30, 15, 7)

/obj/machinery/multitile/steam_turbine/proc/spool_down()
	QDEL_NULL(sound_token)

/obj/machinery/power/generator/turbine_generator
	name = "motor"
	desc = "Electrogenerator. Converts rotation into power."
	icon = 'icons/obj/atmospherics/components/unary/pipeturbine.dmi'
	icon_state = "motor"
	anchored = 1
	density = 1
	dir = 4

	var/obj/machinery/multitile/steam_turbine/turbine

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/noninteractive
	var/connected = FALSE
	var/last_load = 0
	var/voltage = 35200 //4400x8

/obj/machinery/power/generator/turbine_generator/Initialize()
	. = ..()
	updateConnection()
	connect_to_network()
	reactor_components[uid] = src

/obj/machinery/power/generator/turbine_generator/proc/updateConnection()
	turbine = null
	if(src.loc && anchored)
		turbine = locate(/obj/machinery/multitile/steam_turbine) in get_step(src,dir)
		if (turbine.stat & (BROKEN) || !turbine.anchored || turn(turbine.dir,180) != dir)
			turbine = null
		turbine.generator = src

/obj/machinery/power/generator/turbine_generator/Process()
	if(!turbine)
		updateConnection()

/obj/machinery/power/generator/turbine_generator/available_power()
	if(turbine && connected)
		return turbine.kin_energy * (turbine.shaft_integrity * 0.01)
	else
		return 0

/obj/machinery/power/generator/turbine_generator/get_voltage()
	return voltage

/obj/machinery/power/generator/turbine_generator/on_power_drain(w)
	if(turbine)
		turbine.kin_energy -= w //i trust the power controller to not draw more than what's available
		last_load = w

#undef PORT_STEAM_IN
#undef PORT_STEAM_OUT
