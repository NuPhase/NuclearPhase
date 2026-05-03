/obj/machinery/multitile/research_reactor
	name = "research reactor"
	desc = "A reactor made to conduct research on fuel and neutron dynamics."
	icon = 'icons/obj/machines/research_reactor.dmi'
	icon_state = "normal"
	layer = STRUCTURE_LAYER

	map_port_volume = 1000
	interact_offline = TRUE

	width = 2
	height = 2
	bound_width = 96
	bound_height = 96

	map_ports = list(
		list(0, 0, SOUTH, "Coolant In"),
		list(2, 0, SOUTH, "Coolant Out")
	)

	var/obj/machinery/portable_atmospherics/canister/reactor_vessel/loaded_core

	var/list/exclude_list = list()

	var/rod_position = 1 // capture probability
	var/target_rod_position = 1
	var/fast_neutrons = 0
	var/slow_neutrons = 0
	var/total_neutrons = 0
	var/last_neutrons = 0
	var/last_temperature = 0
	var/thermal_power = 0

/obj/machinery/multitile/research_reactor/Initialize()
	. = ..()
	loaded_core = new /obj/machinery/portable_atmospherics/canister/reactor_vessel/uranium

/obj/machinery/multitile/research_reactor/Destroy()
	var/turf/T = get_turf(src)
	loaded_core.forceMove(T)
	loaded_core = null
	. = ..()

/obj/machinery/multitile/research_reactor/Process()
	if(!loaded_core)
		return
	rod_position = Interpolate(rod_position, target_rod_position, 0.1)
	process_fission()
	process_cooling()

/obj/machinery/multitile/research_reactor/proc/process_cooling()
	var/datum/gas_mixture/coolant_in = port_gases["Coolant In"]
	var/datum/gas_mixture/coolant_out = port_gases["Coolant Out"]
	var/pressure_delta = coolant_in.pressure - coolant_out.pressure
	if(pressure_delta < 0)
		return
	var/target_mole_flow = calculate_pressure_flow(pressure_delta, coolant_out.volume)
	var/mole_flow_diff = target_mole_flow - coolant_in.total_moles
	if(mole_flow_diff > 0)
		coolant_in.suction_moles = mole_flow_diff
	else
		coolant_in.suction_moles = 0
	var/datum/gas_mixture/coolant_portion = coolant_in.remove(target_mole_flow)
	var/t_diff = loaded_core.air_contents.temperature - coolant_in.temperature
	var/heat_transfer = min(t_diff * 12000, t_diff * coolant_portion.heat_capacity)
	coolant_portion.add_thermal_energy(heat_transfer)
	coolant_out.merge(coolant_portion)
	loaded_core.air_contents.add_thermal_energy(heat_transfer * -1)

/obj/machinery/multitile/research_reactor/proc/process_fission()
	if(total_neutrons < 0.000001)
		fast_neutrons += 0.000001
	last_neutrons = total_neutrons
	last_temperature = loaded_core.air_contents.temperature
	var/rod_power = 1 + (1500 * (rod_position**2)) + max((last_temperature - T100C) * 0.03, 0) // doppler effect
	var/list/return_list = loaded_core.air_contents.handle_nuclear_reactions(slow_neutrons, fast_neutrons, TRUE, rod_power)
	if(!return_list)
		return
	slow_neutrons = return_list["slow_neutrons_changed"]
	fast_neutrons = return_list["fast_neutrons_changed"]
	total_neutrons = slow_neutrons + fast_neutrons
	thermal_power = (loaded_core.air_contents.temperature - last_temperature) * loaded_core.air_contents.heat_capacity

/obj/machinery/multitile/research_reactor/return_air()
	if(!loaded_core)
		return
	return loaded_core.air_contents

/obj/machinery/multitile/research_reactor/interface_interact(mob/user)
	tgui_interact(user)
	return TRUE

/obj/machinery/multitile/research_reactor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ResearchReactor", "Reactor Control")
		ui.open()
		ui.set_autoupdate(1)

/obj/machinery/multitile/research_reactor/tgui_data(mob/user)
	return list(
		"actualRodPosition" = rod_position,
		"targetRodPosition" = target_rod_position,
		"srm" = Clamp(round(total_neutrons * 300000000), 0, 3000), // yep
		"neutronK" = round(total_neutrons/last_neutrons, 0.001),
		"fastFraction" = round(fast_neutrons / total_neutrons, 0.01),
		"fuelTemperature" = round(loaded_core.air_contents.temperature - 273.15, 0.1),
		"fuelPressure" = loaded_core.air_contents.pressure,
		"fuelComp" = assemble_tgui_gas_list(),
		"fuelTotal" = assemble_tgui_mole_total(),
		"thermalPower" = thermal_power
	)

/obj/machinery/multitile/research_reactor/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("scram")
			target_rod_position = 0
			return TRUE
		if("change_target_rod")
			target_rod_position = Clamp(params["target_rod"], 0, 1)
			return TRUE

/obj/machinery/multitile/research_reactor/proc/assemble_tgui_gas_list()
	var/gas_list = list()
	var/alist/all_fluid = loaded_core.air_contents.get_fluid()
	for(var/g in all_fluid)
		var/decl/material/mat = GET_DECL(g)
		if(g in exclude_list)
			continue
		gas_list += list(list("name" = mat.name, "color" = mat.color, "amount" = all_fluid[g], "mass" = all_fluid[g] * mat.molar_mass))
	return gas_list

/obj/machinery/multitile/research_reactor/proc/assemble_tgui_mole_total()
	var/moles_total = 0
	var/alist/all_fluid = loaded_core.air_contents.get_fluid()
	for(var/g in all_fluid)
		if(g in exclude_list)
			continue
		moles_total += all_fluid[g]
	return moles_total

/obj/machinery/multitile/research_reactor/verb/remove_core()
	set name = "Remove Core"
	set src in view(1)
	if(!loaded_core)
		to_chat(usr, SPAN_WARNING("There is no core in the reactor."))
		return
	if(loaded_core.air_contents.temperature > 80 CELSIUS)
		to_chat(usr, SPAN_WARNING("The reactor is too hot to safely disassemble"))
		return
	var/turf/T = get_turf(src)
	loaded_core.forceMove(T)
	loaded_core = null
	icon_state = "empty"
	playsound(src, 'sound/machines/podopen.ogg', 50)

/obj/machinery/multitile/research_reactor/receive_mouse_drop(atom/dropping, mob/living/user)
	. = ..()
	if(!Adjacent(dropping))
		return
	if(loaded_core)
		return
	if(dropping)
		if(!istype(dropping, /obj/machinery/portable_atmospherics))
			return
		if(!do_after(user, 30, dropping))
			return
		if(loaded_core)
			return
		loaded_core = dropping
		loaded_core.forceMove(src)
		icon_state = initial(icon_state)
		playsound(src, 'sound/machines/podclose.ogg', 50)
	update_icon()

/obj/machinery/portable_atmospherics/canister/reactor_vessel
	name = "reactor vessel (empty)"
	desc = "A radiation shielded reactor vessel."
	icon = 'icons/obj/atmospherics/canister_core.dmi'
	icon_state = "stand"
	canister_color = "stand"
	can_label = 0
	volume = 1000
	weight = 500
	volume = 100
	pull_coefficient = 0.01
	can_explode = FALSE

/obj/machinery/portable_atmospherics/canister/reactor_vessel/uranium
	name = "reactor vessel (LEU)"
	initial_gas = alist(
		/decl/material/gas/krypton = 0.01,
		/decl/material/solid/metal/uranium = 0.03,
		/decl/material/solid/metal/depleted_uranium = 0.97
	)

/obj/machinery/portable_atmospherics/canister/reactor_vessel/heu
	name = "reactor vessel (HEU)"
	initial_gas = alist(
		/decl/material/gas/krypton = 0.01,
		/decl/material/solid/metal/uranium = 0.2,
		/decl/material/solid/metal/depleted_uranium = 0.8
	)

/obj/machinery/portable_atmospherics/canister/reactor_vessel/mox
	name = "reactor vessel (MOX)"
	initial_gas = alist(
		/decl/material/gas/krypton = 0.01,
		/decl/material/solid/metal/plutonium = 0.03,
		/decl/material/solid/metal/depleted_uranium = 0.97
	)

/obj/machinery/portable_atmospherics/canister/reactor_vessel/srec_breeder
	name = "reactor vessel (MOX-SREC BREEDER)"
	initial_gas = alist(
		/decl/material/gas/krypton = 0.01,
		/decl/material/solid/static_crystal = 0.01,
		/decl/material/solid/metal/plutonium = 0.03,
		/decl/material/solid/metal/depleted_uranium = 0.96
	)