/datum/reactor_control_system/proc/initialize()
	turbine1 = reactor_components["turbine1"]
	turbine2 = reactor_components["turbine2"]
	generator1 = reactor_components["generator1"]
	generator2 = reactor_components["generator2"]
	if(!turbine1 || !turbine2)
		spawn(50)
			make_log("START OF LOG.", 1)
			initialize()

/datum/reactor_control_system/proc/control()
	make_reports()
	do_alarms()
	switch(mode)
		if(REACTOR_CONTROL_MODE_SEMIAUTO)
			semi_auto_control()
		if(REACTOR_CONTROL_MODE_AUTO)
			semi_auto_control()
			auto_control()
	last_message_clearing += 1
	if(last_message_clearing == 5)
		for(var/cleared_message in cleared_messages)
			if(cleared_message in all_messages)
				all_messages.Remove(cleared_message)
		cleared_messages.Cut()
		last_message_clearing = 0
	if(scram_control)
		check_autoscram()

/datum/reactor_control_system/proc/semi_auto_control()
	moderate_reactor_loop()
	moderate_turbine_loop()

/datum/reactor_control_system/proc/check_autoscram()
	return

/datum/reactor_control_system/proc/do_alarms()
	if(!should_alarm)
		return

	if(pressure_temperature_should_alarm)
		for(var/obj/machinery/rotating_alarm/reactor/control_room/SL in rcontrol.control_spinning_lights)
			if(!SL.oo_alarm)
				SL.oo_alarm = new(list(SL), TRUE)
	else
		for(var/obj/machinery/rotating_alarm/reactor/control_room/SL in rcontrol.control_spinning_lights)
			QDEL_NULL(SL.oo_alarm)

	var/obj/machinery/rlaser/las = reactor_components["laser_charlie"]
	if(las.armed && las.omode == "IGNITION")
		for(var/obj/machinery/rotating_alarm/reactor/control_room/SL in rcontrol.control_spinning_lights)
			if(!SL.arm_alarm)
				SL.arm_alarm = new(list(SL), TRUE)
	else
		for(var/obj/machinery/rotating_alarm/reactor/control_room/SL in rcontrol.control_spinning_lights)
			QDEL_NULL(SL.arm_alarm)

/datum/reactor_control_system/proc/make_reports()
	pressure_temperature_should_alarm = FALSE
	var/obj/machinery/reactor_button/rswitch/current_switch
	current_switch = reactor_buttons["TURB V-BYPASS"]

	if(current_switch && current_switch.state)
		register_alarm("BYPASS VALVE OPENED", "BYPASS VALVE OPEN")
	else
		clear_alarm("BYPASS VALVE OPEN")

	var/obj/machinery/power/hybrid_reactor/R = reactor_components["core"]
	if(!R.containment)
		register_alarm("CONTAINMENT FIELD DISABLED", "CONTAINMENT FIELD OFFLINE")
	else
		clear_alarm("CONTAINMENT FIELD OFFLINE")

	if(generator1.connected && generator1.last_load < 50000)
		register_alarm("GENERATOR #1 FULL LOAD REJECTION", "GENERATOR #1 FULL LOAD REJECTION", 3)
	else
		clear_alarm("GENERATOR #1 FULL LOAD REJECTION")

	if(generator2.connected && generator2.last_load < 50000)
		register_alarm("GENERATOR #2 FULL LOAD REJECTION", "GENERATOR #2 FULL LOAD REJECTION", 3)
	else
		clear_alarm("GENERATOR #2 FULL LOAD REJECTION")

	if(turbine1.braking)
		register_alarm("TURBINE #1 BRAKING ACTION", "TURBINE #1 BRAKING ACTION", 2)
	else
		clear_alarm("TURBINE #1 BRAKING ACTION")
	if(turbine2.braking)
		register_alarm("TURBINE #2 BRAKING ACTION", "TURBINE #2 BRAKING ACTION", 2)
	else
		clear_alarm("TURBINE #2 BRAKING ACTION")

	switch(turbine1.vibration)
		if(10 to 25)
			register_alarm("EXCESSIVE VIBRATION IN TURBINE #1: [round(turbine1.vibration, 0.1)]mm/s", "EXCESSIVE VIBRATION IN TURBINE #1", 1)
		if(26 to 50)
			register_alarm("HIGH VIBRATION IN TURBINE #1: [round(turbine1.vibration, 0.1)]mm/s", "HIGH VIBRATION IN TURBINE #1", 2)
			clear_alarm("EXCESSIVE VIBRATION IN TURBINE #1")
		if(51 to INFINITY)
			register_alarm("CRITICAL VIBRATION IN TURBINE #1: [round(turbine1.vibration, 0.1)]mm/s", "CRITICAL VIBRATION IN TURBINE #1", 3)
			clear_alarm("EXCESSIVE VIBRATION IN TURBINE #1")
			clear_alarm("HIGH VIBRATION IN TURBINE #1")
	switch(turbine2.vibration)
		if(10 to 25)
			register_alarm("EXCESSIVE VIBRATION IN TURBINE #2: [round(turbine2.vibration, 0.1)]mm/s", "EXCESSIVE VIBRATION IN TURBINE #2", 1)
		if(26 to 50)
			register_alarm("HIGH VIBRATION IN TURBINE #2: [round(turbine2.vibration, 0.1)]mm/s", "HIGH VIBRATION IN TURBINE #2", 2)
			clear_alarm("EXCESSIVE VIBRATION IN TURBINE #2")
		if(51 to INFINITY)
			register_alarm("CRITICAL VIBRATION IN TURBINE #2: [round(turbine2.vibration, 0.1)]mm/s", "CRITICAL VIBRATION IN TURBINE #2", 3)
			clear_alarm("EXCESSIVE VIBRATION IN TURBINE #2")
			clear_alarm("HIGH VIBRATION IN TURBINE #2")

	if(get_meter_temperature("T-M-TURB IN") > MAX_REACTOR_STEAM_TEMP)
		register_alarm("TURBINE HEATEXCHANGER TEMPERATURE HIGH", "TURBINE HEATEXCHANGER TEMPERATURE HIGH", 2)
		pressure_temperature_should_alarm = TRUE
	else
		clear_alarm("TURBINE HEATEXCHANGER TEMPERATURE HIGH")

	if(get_meter_temperature("T-M-TURB EX") > 500 && !(current_switch && current_switch.state))
		register_alarm("TURBINE CONDENSER TEMPERATURE HIGH", "TURBINE CONDENSER TEMPERATURE HIGH", 2)
		pressure_temperature_should_alarm = TRUE
	else
		clear_alarm("TURBINE CONDENSER TEMPERATURE HIGH")

	if(get_meter_pressure("T-M-TURB IN") > 8500)
		register_alarm("STEAM DRUM OVERPRESSURE", "STEAM DRUM OVERPRESSURE", 2)
		pressure_temperature_should_alarm = TRUE
	else
		clear_alarm("STEAM DRUM OVERPRESSURE")

	if(get_meter_pressure("T-M-TURB EX") > 1000)
		register_alarm("CONDENSER OVERPRESSURE", "CONDENSER OVERPRESSURE", 2)
		pressure_temperature_should_alarm = TRUE
	else
		clear_alarm("CONDENSER OVERPRESSURE")


	if(get_pump_flow_rate("F-CP 1") < 50)
		register_alarm("REACTOR LOOP PUMP #1 FLOW LOW", "REACTOR LOOP PUMP #1 FLOW LOW", 1)
	else
		clear_alarm("REACTOR LOOP PUMP #1 FLOW LOW")
	if(get_pump_flow_rate("F-CP 2") < 50)
		register_alarm("REACTOR LOOP PUMP #2 FLOW LOW", "REACTOR LOOP PUMP #2 FLOW LOW", 1)
	else
		clear_alarm("REACTOR LOOP PUMP #2 FLOW LOW")
	if(get_pump_flow_rate("T-CP 1") < 50)
		register_alarm("TURBINE LOOP PUMP #1 FLOW LOW", "TURBINE LOOP PUMP #1 FLOW LOW", 1)
	else
		clear_alarm("TURBINE LOOP PUMP #1 FLOW LOW")
	if(get_pump_flow_rate("T-CP 2") < 50)
		register_alarm("TURBINE LOOP PUMP #2 FLOW LOW", "TURBINE LOOP PUMP #2 FLOW LOW", 1)
	else
		clear_alarm("TURBINE LOOP PUMP #2 FLOW LOW")

	if(get_meter_temperature("T-M-TURB EX") > 450 && get_meter_pressure("T-M-TURB EX") > 200 && !(current_switch && current_switch.state))
		register_alarm("VAPOR IN CONDENSER", "VAPOR IN CONDENSER", 2)
	else
		clear_alarm("VAPOR IN CONDENSER")

/datum/reactor_control_system/proc/auto_control()
	if(current_running_program)
		current_running_program.process()
	return

/datum/reactor_control_system/proc/moderate_reactor_loop()
	return

/datum/reactor_control_system/proc/scram(cause)
	if(has_trip("SCRAM"))
		return
	register_trip("SCRAM: [capitalize(cause)].", "SCRAM")
	var/obj/machinery/reactor_button/rswitch/current_switch
	var/obj/machinery/power/hybrid_reactor/R = reactor_components["core"]

	current_switch = reactor_buttons["EP-SCRAM"]
	playsound(current_switch.loc, 'sound/machines/switchbuzzer.ogg', 50)
	current_switch = reactor_buttons["AUTOSCRAM"]
	current_switch.state = 0
	current_switch.icon_state = current_switch.off_icon_state

	current_switch = reactor_buttons["BATTERY CHARGER"]
	current_switch.state = 0
	current_switch.icon_state = current_switch.off_icon_state

	spawn(4 SECONDS)
		containment_shutdown(TRUE)

	mode = REACTOR_CONTROL_MODE_MANUAL
	scram_control = FALSE

	R.reflector_position = 0
	R.moderator_position = 0

/datum/reactor_control_system/proc/containment_shutdown(emergency=FALSE)
	do_message("CONTAINMENT SHUTDOWN", 3)
	make_log("CONTAINMENT SHUTDOWN.", 3)
	var/obj/machinery/power/hybrid_reactor/R = reactor_components["core"]
	R.containment = FALSE
	if(emergency)
		purge()

/datum/reactor_control_system/proc/delayed_purge()
	for(var/obj/machinery/rotating_alarm/reactor/control_room/SL in rcontrol.control_spinning_lights)
		SL.purge_alarm = new(list(SL.loc), TRUE)
		spawn(31 SECONDS)
			purge()
		spawn(20 SECONDS)
			QDEL_NULL(SL.purge_alarm)

/datum/reactor_control_system/proc/purge()
	make_log("REACTOR CHAMBER PURGED.", 3)
	var/obj/machinery/power/hybrid_reactor/rcore = reactor_components["core"]
	playsound(rcore.superstructure, 'sound/effects/purge.ogg', 100, FALSE, 50, 1, ignore_walls = TRUE)
	var/datum/gas_mixture/total_mixture = rcore.containment_field.remove_ratio(0.9)
	total_mixture.temperature = T100C
	var/turf/sT = get_turf(rcore.superstructure)
	var/datum/gas_mixture/senvironment = sT.return_air()
	senvironment.merge(total_mixture.remove_ratio(0.05))

/datum/reactor_control_system/proc/do_message(message, urgency = 1) //urgency 1-3
	if(has_message(message))
		return //we already have that one
	all_messages[message] = urgency
	for(var/obj/machinery/reactor_monitor/general/mon in announcement_monitors)
		mon.chat_report(message, urgency)
	switch(urgency)
		if(2)
			radio_announce("Reactor Operations team presence requested in the control room.", name, "Engineering")
		if(3)
			radio_announce("REACTOR ALERT: [message].", name, "Engineering")

/datum/reactor_control_system/proc/has_message(message)
	var/msg = all_messages[message]
	if(msg)
		return TRUE
	return FALSE

/datum/reactor_control_system/proc/remove_message(message)
	all_messages.Remove(message)
	cleared_messages.Remove(message)

/datum/reactor_control_system/proc/get_pump_flow_rate(pumpid)
	var/obj/machinery/atmospherics/binary/pump/adv/P = reactor_pumps[pumpid]
	if(P)
		return P.last_mass_flow
	return 0

/datum/reactor_control_system/proc/get_meter_pressure(meterid)
	var/obj/machinery/meter/rmeter = reactor_meters[meterid]
	if(rmeter)
		var/datum/gas_mixture/gm = rmeter.return_air()
		return round(gm.return_pressure())
	return 0

// Get steam quality at meter
/datum/reactor_control_system/proc/get_meter_steam_quality(meterid)
	var/obj/machinery/meter/rmeter = reactor_meters[meterid]
	if(rmeter)
		var/datum/gas_mixture/gm = rmeter.return_air()
		if(!gm.liquids[/decl/material/liquid/water])
			return 100
		return round(Clamp(gm.gas[/decl/material/liquid/water] / gm.liquids[/decl/material/liquid/water] * 100, 0, 100), 0.1)
	return 0

/datum/reactor_control_system/proc/get_meter_temperature(meterid)
	var/obj/machinery/meter/rmeter = reactor_meters[meterid]
	if(rmeter)
		var/datum/gas_mixture/gm = rmeter.return_air()
		return round(gm.temperature)
	return T20C

/datum/reactor_control_system/proc/get_meter_mass(meterid)
	var/obj/machinery/meter/rmeter = reactor_meters[meterid]
	if(rmeter)
		var/datum/gas_mixture/gm = rmeter.return_air()
		return round(gm.get_mass())
	return 0

/datum/reactor_control_system/proc/get_meter_level(meterid)
	var/obj/machinery/meter/rmeter = reactor_meters[meterid]
	if(rmeter)
		var/datum/gas_mixture/gm = rmeter.return_air()
		return round((1 - (gm.available_volume / gm.volume)) * 100)
	return 0

/datum/reactor_control_system/proc/perform_laser_ignition()
	make_log("LASER IGNITION.", 1)
	if(laser_animating)
		return
	laser_animating = TRUE
	spawn(30)
		laser_animating = FALSE
	animate(laser_marker, alpha = 255, 15, easing = CUBIC_EASING|EASE_OUT)
	spawn(15)
		animate(laser_marker, alpha = 0, 10, easing = BOUNCE_EASING|EASE_IN)