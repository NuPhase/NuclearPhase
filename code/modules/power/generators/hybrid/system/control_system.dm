/datum/reactor_control_system/proc/initialize()
	turbine1 = reactor_components["turbine1"]
	turbine2 = reactor_components["turbine2"]
	generator1 = reactor_components["generator1"]
	generator2 = reactor_components["generator2"]
	if(!turbine1 || !turbine2)
		spawn(50)
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
		do_message("TURBINES ON BYPASS", 1)

	if((generator1.connected && generator1.last_load < 50000) || (generator2.connected && generator2.last_load < 50000))
		do_message("FULL LOAD REJECTION", 3)

	if(turbine1.braking)
		do_message("TURBINE #1 BRAKING ACTION", 2)
	else
		remove_message("TURBINE #1 BRAKING ACTION")
	if(turbine2.braking)
		do_message("TURBINE #2 BRAKING ACTION", 2)
	else
		remove_message("TURBINE #2 BRAKING ACTION")

	switch(turbine1.vibration)
		if(10 to 25)
			do_message("EXCESSIVE VIBRATION IN TURBINE #1", 1)
		if(26 to 50)
			do_message("HIGH VIBRATION IN TURBINE #1", 2)
			remove_message("EXCESSIVE VIBRATION IN TURBINE #1")
		if(51 to INFINITY)
			do_message("CRITICAL VIBRATION IN TURBINE #1", 3)
			remove_message("EXCESSIVE VIBRATION IN TURBINE #1")
			remove_message("HIGH VIBRATION IN TURBINE #1")
	switch(turbine2.vibration)
		if(10 to 25)
			do_message("EXCESSIVE VIBRATION IN TURBINE #2", 1)
		if(26 to 50)
			do_message("HIGH VIBRATION IN TURBINE #2", 2)
			remove_message("EXCESSIVE VIBRATION IN TURBINE #2")
		if(51 to INFINITY)
			do_message("CRITICAL VIBRATION IN TURBINE #2", 3)
			remove_message("EXCESSIVE VIBRATION IN TURBINE #2")
			remove_message("HIGH VIBRATION IN TURBINE #2")

	if(get_meter_temperature("REACTOR-M CHAMBER") > 4200)
		do_message("REACTOR HEATEXCHANGER OVERHEAT", 2)
		pressure_temperature_should_alarm = TRUE
	if(get_meter_temperature("T-M-TURB IN") > MAX_REACTOR_STEAM_TEMP)
		do_message("TURBINE HEATEXCHANGER TEMPERATURE HIGH", 2)
		pressure_temperature_should_alarm = TRUE
	if(get_meter_temperature("T-M-TURB EX") > 380 && !(current_switch && current_switch.state))
		do_message("TURBINE CONDENSER TEMPERATURE HIGH", 2)
		pressure_temperature_should_alarm = TRUE

	if(get_meter_pressure("T-M-TURB IN") > 8500)
		do_message("STEAM DRUM OVERPRESSURE", 2)
		pressure_temperature_should_alarm = TRUE
	if(get_meter_pressure("T-M-TURB EX") > 1000)
		do_message("HOTWELL OVERPRESSURE", 2)
		pressure_temperature_should_alarm = TRUE

	if(get_pump_flow_rate("F-CP 1") < 50)
		do_message("REACTOR LOOP PUMP #1 MASS FLOW < 25KG/S", 1)
	if(get_pump_flow_rate("F-CP 2") < 50)
		do_message("REACTOR LOOP PUMP #2 MASS FLOW < 25KG/S", 1)
	if(get_pump_flow_rate("T-CP 1") < 50)
		do_message("TURBINE LOOP PUMP #1 MASS FLOW < 50KG/S", 1)
	if(get_pump_flow_rate("T-CP 2") < 50)
		do_message("TURBINE LOOP PUMP #2 MASS FLOW < 50KG/S", 1)

	if(get_meter_temperature("T-M-TURB EX") > 390 && !(current_switch && current_switch.state))
		do_message("VAPOR IN HOTWELL LOOP", 2)

/datum/reactor_control_system/proc/auto_control()
	if(current_running_program)
		current_running_program.process()
	return

/datum/reactor_control_system/proc/moderate_reactor_loop()
	return

/datum/reactor_control_system/proc/scram(cause)
	do_message("SCRAM: [capitalize(cause)]", 3)
	var/obj/machinery/atmospherics/binary/regulated_valve/current_valve
	var/obj/machinery/reactor_button/rswitch/current_switch
	var/obj/machinery/power/hybrid_reactor/R = reactor_components["core"]

	current_switch = reactor_buttons["EP-SCRAM"]
	playsound(current_switch.loc, 'sound/machines/switchbuzzer.ogg', 50)
	current_switch = reactor_buttons["AUTOSCRAM"]
	current_switch.state = 0
	current_switch.icon_state = current_switch.off_icon_state

	//shutting down reactor
	current_valve = reactor_valves["REACTOR-F-V-IN"]
	current_valve.set_openage(0)
	current_valve = reactor_valves["REACTOR-F-V-OUT"]
	current_valve.set_openage(100)

	turbine_trip("SCRAM")

	mode = REACTOR_CONTROL_MODE_MANUAL
	scram_control = FALSE

	R.reflector_position = 0
	R.moderator_position = 0

/datum/reactor_control_system/proc/do_message(message, urgency = 1) //urgency 1-3
	if(has_message(message))
		return //we already have that one
	all_messages[message] = urgency
	for(var/obj/machinery/reactor_monitor/general/mon in announcement_monitors)
		mon.chat_report(message, urgency)

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

/datum/reactor_control_system/proc/perform_laser_ignition()
	if(laser_animating)
		return
	laser_animating = TRUE
	spawn(30)
		laser_animating = FALSE
	animate(laser_marker, alpha = 255, 15, easing = CUBIC_EASING|EASE_OUT)
	spawn(15)
		animate(laser_marker, alpha = 0, 10, easing = BOUNCE_EASING|EASE_IN)