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

#define IDEAL_EXHAUST_TEMP 390
/datum/reactor_control_system/proc/control_turbine_rpm()
	var/obj/machinery/reactor_button/rswitch/current_switch
	if(closed_governor_cycle) //open cycle achieves RPM, closed cycle adapts to generator load
		var/governor_adjustment = 0.01
		var/load_difference = 0
		//predefining vars for performance
		if(turbine1.feeder_valve_openage > 0)
			load_difference = generator1.last_load - (turbine1.kin_total * turbine1.efficiency)
			governor_adjustment = sqrt(abs(load_difference)) * 0.0001 * (load_difference > 0 ? 1 : -1)
			if(turbine1.rpm > 3600)
				governor_adjustment -= 0.15
			else
				governor_adjustment += 0.15
			turbine1.feeder_valve_openage = CLAMP01(governor_adjustment)
			current_switch = reactor_buttons["turbine1"]
			current_switch.update_icon(turbine1.feeder_valve_openage)

		if(turbine2.feeder_valve_openage > 0)
			load_difference = generator2.last_load - (turbine2.kin_total * turbine2.efficiency)
			governor_adjustment = sqrt(abs(load_difference)) * 0.0001 * (load_difference > 0 ? 1 : -1)
			if(turbine2.rpm > 3600)
				governor_adjustment -= 0.15
			else
				governor_adjustment += 0.15
			turbine2.feeder_valve_openage = CLAMP01(governor_adjustment)
			current_switch = reactor_buttons["turbine2"]
			current_switch.update_icon(turbine2.feeder_valve_openage)
	else
		var/rpm_difference = 0
		var/target_valve_openage = 0
		if(turbine1.feeder_valve_openage > 0 || turbine1.rpm > 3000) //don't start turbines from a complete standstill
			rpm_difference = 3600 - turbine1.rpm
			target_valve_openage = rpm_difference * 0.063 //main spinup function
			target_valve_openage *= min(OPTIMAL_TURBINE_PRESSURE, get_meter_pressure("T-M-TURB IN")) / OPTIMAL_TURBINE_PRESSURE //low pressure protection
			if(turbine1.rpm > 3600) //overspeed protection
				target_valve_openage -= 0.15
			turbine1.feeder_valve_openage = Interpolate(turbine1.feeder_valve_openage, Clamp(target_valve_openage * 0.01, 0, 1), 0.2)
			current_switch = reactor_buttons["turbine1"]
			current_switch.update_icon(turbine1.feeder_valve_openage)
		if(turbine2.feeder_valve_openage > 0 || turbine2.rpm > 3000) //don't start turbines from a complete standstill
			rpm_difference = 3600 - turbine2.rpm
			target_valve_openage = rpm_difference * 0.063 //main spinup function
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
	var/obj/machinery/atmospherics/binary/passive_gate/current_gate
	current_gate = reactor_valves["T-COOLANT V-IN"]
	if(current_gate)
		if(get_meter_temperature("T-M-TURB EX") > 360)
			current_gate.target_pressure = min(15000, current_gate.target_pressure += 100)
		else
			current_gate.target_pressure = max(1000, current_gate.target_pressure -= 100)

	current_gate = reactor_valves["T-COOLANT V-OUT"]
	if(current_gate)
		if(get_meter_temperature("T-M-COOLANT") > 320 || get_meter_pressure("T-M-COOLANT") > 9000 || get_meter_temperature("T-M-TURB EX") > 360)
			current_gate.target_pressure = max(1000, current_gate.target_pressure -= 100)
		else
			current_gate.target_pressure = min(15000, current_gate.target_pressure += 100)

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

	generator1.connected = FALSE
	generator2.connected = FALSE
	current_switch = reactor_buttons["generator1"]
	current_switch.state = 1
	current_switch.do_action()
	current_switch = reactor_buttons["generator2"]
	current_switch.state = 1
	current_switch.do_action()

	current_switch = reactor_buttons["TURB V-BYPASS"]
	current_switch.state = 0
	current_switch.do_action()

	playsound(current_switch.loc, 'sound/machines/switchbuzzer.ogg', 50)
	SSstatistics.turbines_tripped = TRUE