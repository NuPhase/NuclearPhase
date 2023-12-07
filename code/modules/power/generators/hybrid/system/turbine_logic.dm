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

	if(get_meter_pressure("T-M-TURB EX") > ONE_ATMOSPHERE*3) //low vacuum
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

/datum/reactor_control_system/proc/control_turbine_rpm()
	if(closed_governor_cycle) //open cycle achieves RPM, closed cycle adapts to generator load
		var/governor_adjustment = 0.01
		var/load_difference = 0
		//predefining vars for performance
		load_difference = generator1.last_load - (turbine1.kin_total * turbine1.efficiency)
		governor_adjustment = sqrt(abs(load_difference)) * 0.0001 * (load_difference > 0 ? 1 : -1)
		if(turbine1.rpm > 3600)
			governor_adjustment -= 0.15
		else
			governor_adjustment += 0.15
		turbine1.feeder_valve_openage = CLAMP01(turbine1.feeder_valve_openage + governor_adjustment)

		load_difference = generator2.last_load - (turbine2.kin_total * turbine2.efficiency)
		governor_adjustment = sqrt(abs(load_difference)) * 0.0001 * (load_difference > 0 ? 1 : -1)
		if(turbine2.rpm > 3600)
			governor_adjustment -= 0.15
		else
			governor_adjustment += 0.15
		turbine2.feeder_valve_openage = CLAMP01(turbine2.feeder_valve_openage + governor_adjustment)
	else
		var/rpm_difference = 0
		var/target_valve_openage = 0
		if(turbine1.feeder_valve_openage >= 0.1) //don't start turbines from a complete standstill
			rpm_difference = 3600 - turbine1.rpm
			target_valve_openage = rpm_difference * 0.073
			turbine1.feeder_valve_openage = Interpolate(turbine1.feeder_valve_openage, Clamp(target_valve_openage * 0.01, 0, 1), 0.2)
		if(turbine2.feeder_valve_openage >= 0.1) //don't start turbines from a complete standstill
			rpm_difference = 3600 - turbine2.rpm
			target_valve_openage = rpm_difference * 0.073
			turbine2.feeder_valve_openage = Interpolate(turbine2.feeder_valve_openage, Clamp(target_valve_openage * 0.01, 0, 1), 0.2)

/datum/reactor_control_system/proc/control_cooling()
	var/obj/machinery/atmospherics/binary/passive_gate/current_gate
	current_gate = reactor_valves["T-COOLANT V-IN"]
	if(get_meter_temperature("T-M-TURB EX") > 360)
		current_gate.target_pressure = min(15000, current_gate.target_pressure += 100)
	else
		current_gate.target_pressure = max(1000, current_gate.target_pressure -= 100)

	current_gate = reactor_valves["T-COOLANT V-OUT"]
	if(get_meter_temperature("T-M-COOLANT") > 320 || get_meter_pressure("T-M-COOLANT") > 9000 || get_meter_temperature("T-M-TURB EX") > 360)
		current_gate.target_pressure = max(1000, current_gate.target_pressure -= 100)
	else
		current_gate.target_pressure = min(15000, current_gate.target_pressure += 100)

/datum/reactor_control_system/proc/turbine_trip(reason)
	do_message("TURBINE TRIP: [reason]", 3)
	var/obj/machinery/reactor_button/rswitch/current_switch
	turbine1.feeder_valve_openage = 0
	turbine2.feeder_valve_openage = 0
	generator1.connected = FALSE
	generator2.connected = FALSE
	current_switch = reactor_buttons["TURB V-BYPASS"]
	current_switch.state = 0
	current_switch.do_action()
	playsound(current_switch.loc, 'sound/machines/switchbuzzer.ogg', 50)
	SSstatistics.turbines_tripped = TRUE