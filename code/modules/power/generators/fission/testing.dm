/obj/structure/core_display_test
	icon = 'icons/obj/machines/ai_server.dmi'
	icon_state = "frame"

/obj/structure/core_display_test/attack_hand(mob/user)
	tgui_interact(user)

/obj/structure/core_display_test/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FissionCoreDisplay", "Core Map")
		ui.open()
		ui.set_autoupdate(1)

/obj/structure/core_display_test/tgui_data(mob/user)
	var/obj/machinery/multitile/fission_reactor_vessel/rcore = fission_reactor_components["core"]
	var/list/data = list(
		"rods" = assemble_rod_list(rcore.core_matrix.assemblies, rcore.core_matrix.fuel.temperature),
		"tempAverage" = get_rod_temp_average(rcore.core_matrix.assemblies),
		"tempHighest" = get_rod_temp_highest(rcore.core_matrix.assemblies),
		"coreFlux" = rcore.core_matrix.total_neutrons,
		"targetFlux" = rcore.core_matrix.target_flux,
		"autoEnabled" = rcore.core_matrix.rod_autocontrol,
		"reactorPeriod" = rcore.core_matrix.reactor_period,
		"targetPeriod" = rcore.core_matrix.target_period,
		"equivRod" = rcore.core_matrix.equiv_rod_position,
		"thermalPower" = rcore.core_matrix.thermal_power,
		"dopplerFactor" = rcore.core_matrix.temp_factor,
		"recircFlow" = rcore.core_matrix.recirc_flow,
		"vesselTemperature" = rcore.core_matrix.vessel.temperature,
		"vesselPressure" = rcore.core_matrix.vessel.pressure,
		"vesselLevel" = round((1 - (rcore.core_matrix.vessel.available_volume / rcore.core_matrix.vessel.volume)) * 100),
		"fuelTemperature" = rcore.core_matrix.fuel.temperature,
		"fuelPressure" = rcore.core_matrix.fuel.pressure,
		"recircSpeed" = rcore.circ_pump_speed,
		"recircSetpoint" = rcore.circ_pump_setpoint,
		"inletTemperature" = rcore.inlet_temperature,
		"inletFlow" = rcore.inlet_flow
	)
	return data

/obj/structure/core_display_test/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/obj/machinery/multitile/fission_reactor_vessel/rcore = fission_reactor_components["core"]
	switch(action)
		if("switch_auto")
			rcore.core_matrix.rod_autocontrol = !rcore.core_matrix.rod_autocontrol
			return TRUE
		if("big_notch_up")
			rcore.core_matrix.adjust_rod(-0.01)
			return TRUE
		if("notch_up")
			rcore.core_matrix.adjust_rod(-0.001)
			return TRUE
		if("notch_down")
			rcore.core_matrix.adjust_rod(0.001)
			return TRUE
		if("big_notch_down")
			rcore.core_matrix.adjust_rod(0.01)
			return TRUE
		if("change_target_flux")
			rcore.core_matrix.target_flux = Clamp(params["target_flux"], 0, 0.01)
			return TRUE
		if("change_target_circ")
			rcore.circ_pump_setpoint = Clamp(params["target_circ"], 0, 100)
			return TRUE

/obj/structure/core_display_test/proc/assemble_rod_list(list/assemblies, core_temp)
	var/list/to_return = list()
	for(var/datum/fission_assembly/A in assemblies)
		to_return += list(list("x" = A.x, "y" = A.y, "temperature" = A.temperature, "insertion" = A.rod_position))
	return to_return

/obj/structure/core_display_test/proc/get_rod_temp_average(list/assemblies)
	var/temp_sum = 0
	for(var/datum/fission_assembly/A in assemblies)
		temp_sum += A.temperature
	return temp_sum / length(assemblies)

/obj/structure/core_display_test/proc/get_rod_temp_highest(list/assemblies)
	var/highest_temp = 0
	for(var/datum/fission_assembly/A in assemblies)
		if(A.temperature > highest_temp)
			highest_temp = A.temperature
	return highest_temp