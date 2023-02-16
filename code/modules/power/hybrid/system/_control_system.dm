#define REACTOR_CONTROL_MODE_MANUAL "manual"
#define REACTOR_CONTROL_MODE_SEMIAUTO "semi-auto"
#define REACTOR_CONTROL_MODE_AUTO "auto"

#define MAX_REACTOR_VESSEL_PRESSURE 500000 //kPa
#define ALARM_REACTOR_TUNGSTEN_TEMP 4600
#define MAX_REACTOR_TUNGSTEN_TEMP 4500
#define OPERATIONAL_REACTOR_TUNGSTEN_TEMP 4100

#define OPTIMAL_REACTOR_STEAM_TEMP 700
#define MAX_REACTOR_STEAM_TEMP 800
#define OPTIMAL_TURBINE_MASS_FLOW 500

/datum/reactor_control_system
	var/mode = REACTOR_CONTROL_MODE_MANUAL

	var/list/all_messages = list()
	var/list/uncleared_messages = list()

	var/list/reactor_pumps = list()
	var/list/reactor_meters = list()
	var/list/reactor_valves = list()

/datum/reactor_control_system/proc/control()
	make_reports()
	switch(mode)
		if(REACTOR_CONTROL_MODE_SEMIAUTO)
			semi_auto_control()

/datum/reactor_control_system/proc/semi_auto_control()
	moderate_reactor_loop()
	moderate_turbine_loop()

/datum/reactor_control_system/proc/make_reports()
	if(get_meter_temperature("REACTOR-M CHAMBER") > ALARM_REACTOR_TUNGSTEN_TEMP)
		do_message("HIGH TEMPERATURE IN REACTOR VESSEL", 2)
	if(get_meter_pressure("REACTOR-M CHAMBER") > MAX_REACTOR_VESSEL_PRESSURE)
		do_message("HIGH PRESSURE IN REACTOR VESSEL", 2)
	if(get_pump_flow_rate("F-CP 1") < 50)
		do_message("REACTOR LOOP PUMP #1 MASS FLOW < 25KG/S", 2)
	if(get_pump_flow_rate("F-CP 2") < 50)
		do_message("REACTOR LOOP PUMP #2 MASS FLOW < 25KG/S", 2)
	if(get_pump_flow_rate("T-CP 1") < 50)
		do_message("TURBINE LOOP PUMP #1 MASS FLOW < 50KG/S", 1)
	if(get_pump_flow_rate("T-CP 2") < 50)
		do_message("TURBINE LOOP PUMP #2 MASS FLOW < 50KG/S", 1)

/datum/reactor_control_system/proc/moderate_reactor_loop()
	var/obj/machinery/atmospherics/binary/regulated_valve/current_valve

	current_valve = reactor_valves["REACTOR-F-V-IN"]
	if(!current_valve.manual)
		if(get_meter_temperature("REACTOR-M CHAMBER") > MAX_REACTOR_TUNGSTEN_TEMP)
			current_valve.adjust_openage(-1)
		else
			current_valve.adjust_openage(1)

	current_valve = reactor_valves["REACTOR-F-V-OUT"]
	if(!current_valve.manual)
		if(get_meter_temperature("REACTOR-M CHAMBER") > OPERATIONAL_REACTOR_TUNGSTEN_TEMP)
			current_valve.adjust_openage(1)
		else
			current_valve.adjust_openage(-1)

/datum/reactor_control_system/proc/moderate_turbine_loop()

/datum/reactor_control_system/proc/do_message(message, urgency = 1) //urgency 1-3
	if(has_message(message))
		return //we already have that one
	all_messages[message] = urgency
	uncleared_messages[message] = urgency

/datum/reactor_control_system/proc/has_message(message)
	var/msg = all_messages[message]
	if(msg)
		return TRUE
	return FALSE

/datum/reactor_control_system/proc/get_pump_flow_rate(pumpid)
	var/obj/machinery/atmospherics/binary/pump/adv/P = reactor_pumps[pumpid]
	if(P)
		return P.last_mass_flow
	return 0

/datum/reactor_control_system/proc/get_meter_pressure(meterid)
	var/obj/machinery/meter/rmeter = reactor_meters[meterid]
	if(rmeter)
		var/datum/gas_mixture/gm = rmeter.return_air()
		return gm.return_pressure()
	return 0

/datum/reactor_control_system/proc/get_meter_temperature(meterid)
	var/obj/machinery/meter/rmeter = reactor_meters[meterid]
	if(rmeter)
		var/datum/gas_mixture/gm = rmeter.return_air()
		return gm.temperature
	return 0