/datum/reactor_control_system/proc/run_selftest()
	for(var/valve_id in pressure_valves_to_check)
		var/obj/machinery/atmospherics/binary/passive_gate/current_valve = reactor_valves[valve_id]
		if(!current_valve)
			report_error("VALVE '[valve_id]' NON-RESPONSIVE.")
			return FALSE
	for(var/meter_id in meters_to_check)
		var/obj/machinery/meter/current_meter = reactor_meters[meter_id]
		if(!current_meter)
			report_error("VALVE '[meter_id]' NON-RESPONSIVE.")
			return FALSE

/datum/reactor_control_system/proc/report_error(message)
	do_message("SELFTEST FAIL: [message]", 2)