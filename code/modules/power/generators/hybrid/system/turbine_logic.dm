/datum/reactor_control_system/proc/moderate_turbine_loop()
	control_cooling()
	if(turbine1.feeder_valve_openage || turbine2.feeder_valve_openage)
		control_turbine_rpm()
		check_trip_conditions()

/datum/reactor_control_system/proc/check_trip_conditions()
	if(!scram_control)
		return FALSE
	var/should_trip = FALSE
	var/trip_reason

	if(get_meter_temperature("T-M-TURB IN") < 690) //water in intake
		if(generator1.connected || generator2.connected)
			should_trip = TRUE
			trip_reason = "INTAKE CONDENSATION"

	if(get_meter_pressure("T-M-TURB EX") > ONE_ATMOSPHERE*6) //low vacuum
		should_trip = TRUE
		trip_reason = "LOW CONDENSER VACUUM"

	if(turbine1.vibration > 50 || turbine2.vibration > 50)
		should_trip = TRUE
		trip_reason = "CRITICAL VIBRATION"

	if(turbine1.rpm > 4000 || turbine2.rpm > 4000)
		should_trip = TRUE
		trip_reason = "OVERSPEED"

	if(should_trip)
		turbine_trip(trip_reason)
		return TRUE
	return FALSE

#define IDEAL_EXHAUST_TEMP 375
/datum/reactor_control_system/proc/control_turbine_rpm()
	var/obj/machinery/reactor_button/rswitch/current_switch
	var/rpm_difference = 0
	var/target_valve_openage = 0

	if(turbine1.feeder_valve_openage > 0 || turbine1.rpm > 3000) //don't start turbines from a complete standstill
		rpm_difference = 3600 - turbine1.rpm
		target_valve_openage = Clamp(rpm_difference * 2, 0, 100) //main spinup function
		target_valve_openage *= min(OPTIMAL_TURBINE_PRESSURE, get_meter_pressure("T-M-TURB IN")) / OPTIMAL_TURBINE_PRESSURE //low pressure protection
		if(turbine1.rpm > 3600) //overspeed protection
			target_valve_openage -= 0.15
		turbine1.feeder_valve_openage = Interpolate(turbine1.feeder_valve_openage, Clamp(target_valve_openage * 0.01, 0, 1), 0.2)
		current_switch = reactor_buttons["turbine1"]
		current_switch.update_icon(turbine1.feeder_valve_openage)
	if(turbine2.feeder_valve_openage > 0 || turbine2.rpm > 3000) //don't start turbines from a complete standstill
		rpm_difference = 3600 - turbine2.rpm
		target_valve_openage = Clamp(rpm_difference * 2, 0, 100) //main spinup function
		target_valve_openage *= min(OPTIMAL_TURBINE_PRESSURE, get_meter_pressure("T-M-TURB IN")) / OPTIMAL_TURBINE_PRESSURE //low pressure protection
		if(turbine2.rpm > 3600) //overspeed protection
			target_valve_openage -= 0.15
		turbine2.feeder_valve_openage = Interpolate(turbine2.feeder_valve_openage, Clamp(target_valve_openage * 0.01, 0, 1), 0.2)
		current_switch = reactor_buttons["turbine2"]
		current_switch.update_icon(turbine2.feeder_valve_openage)

	//control the expansion so we get the ideal temperature at the exhaust
	if(turbine1.feeder_valve_openage > 0)
		if(turbine1.exhaust_temperature < IDEAL_EXHAUST_TEMP)
			turbine1.expansion_ratio += 0.01
		else if(turbine1.exhaust_temperature > IDEAL_EXHAUST_TEMP)
			turbine1.expansion_ratio -= 0.01
		turbine1.expansion_ratio = Clamp(turbine1.expansion_ratio, 0.15, 0.87)
	if(turbine2.feeder_valve_openage > 0)
		if(turbine2.exhaust_temperature < IDEAL_EXHAUST_TEMP)
			turbine2.expansion_ratio += 0.01
		else if(turbine2.exhaust_temperature > IDEAL_EXHAUST_TEMP)
			turbine2.expansion_ratio -= 0.01
		turbine2.expansion_ratio = Clamp(turbine2.expansion_ratio, 0.15, 0.87)

/datum/reactor_control_system/proc/control_cooling()
	return

/datum/reactor_control_system/proc/turbine_trip(reason)
	do_message("TURBINE TRIP: [reason]", 3)
	make_log("TURBINE TRIP: [reason].", 3)
	var/obj/machinery/reactor_button/rswitch/current_switch

	turbine1.feeder_valve_openage = 0
	turbine2.feeder_valve_openage = 0
	current_switch = reactor_buttons["turbine1"]
	current_switch.update_icon(turbine1.feeder_valve_openage)
	current_switch = reactor_buttons["turbine2"]
	current_switch.update_icon(turbine2.feeder_valve_openage)

	current_switch = reactor_buttons["TURB V-BYPASS"]
	current_switch.state = 0
	current_switch.do_action()

	playsound(current_switch.loc, 'sound/machines/switchbuzzer.ogg', 50)
	SSstatistics.turbines_tripped = TRUE