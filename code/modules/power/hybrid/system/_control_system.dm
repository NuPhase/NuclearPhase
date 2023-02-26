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
	var/semiautocontrol_available = TRUE
	var/autocontrol_available = FALSE

	var/list/all_messages = list()
	var/list/uncleared_messages = list()

	var/list/reactor_pumps = list()
	var/list/reactor_meters = list()
	var/list/reactor_valves = list()
	var/obj/machinery/atmospherics/binary/turbinestage/turbine1 = null
	var/obj/machinery/atmospherics/binary/turbinestage/turbine2 = null
	var/obj/machinery/power/turbine_generator/generator1 = null
	var/obj/machinery/power/turbine_generator/generator2 = null

/datum/reactor_control_system/proc/initialize()
	turbine1 = reactor_components["turbine1"]
	turbine2 = reactor_components["turbine2"]

/datum/reactor_control_system/proc/switch_mode(newmode) //returns 1 if modes were switched succesfully, 0 if mode is unavailable and 2 if it is the same mode
	if(newmode == mode)
		return 2
	switch(newmode)
		if(REACTOR_CONTROL_MODE_MANUAL)
			mode = REACTOR_CONTROL_MODE_MANUAL
			do_message("MANUAL CONTROL ENGAGED", 1)
		if(REACTOR_CONTROL_MODE_SEMIAUTO)
			if(semiautocontrol_available)
				mode = REACTOR_CONTROL_MODE_SEMIAUTO
				do_message("SEMI-AUTO CONTROL ENGAGED", 1)
			else
				return 0
		if(REACTOR_CONTROL_MODE_AUTO)
			if(autocontrol_available)
				mode = REACTOR_CONTROL_MODE_AUTO
				do_message("FULL-AUTO CONTROL ENGAGED", 1)
			else
				return 0

/datum/reactor_control_system/proc/control()
	make_reports()
	switch(mode)
		if(REACTOR_CONTROL_MODE_SEMIAUTO)
			semi_auto_control()

/datum/reactor_control_system/proc/semi_auto_control()
	moderate_reactor_loop()
	moderate_turbine_loop()

/datum/reactor_control_system/proc/make_reports()
	var/obj/machinery/reactor_button/rswitch/current_switch
	current_switch = reactor_buttons["TURB V-BYPASS"]
	if(current_switch.state)
		do_message("TURBINES ON BYPASS", 1)

	if(turbine1.rpm > 50 || turbine2.rpm > 50) //you shouldn't accelerate past that without load
		if(generator1.last_load < 50000)
			do_message("GENERATOR #1 FULL LOAD REJECTION", 3)
		if(generator2.last_load < 50000)
			do_message("GENERATOR #2 FULL LOAD REJECTION", 3)

	switch(turbine1.vibration)
		if(0 to 25)
			do_message("EXCESSIVE VIBRATION IN TURBINE #1", 1)
		if(26 to 50)
			do_message("HIGH VIBRATION IN TURBINE #1", 2)
		if(51 to INFINITY)
			do_message("CRITICAL VIBRATION IN TURBINE #1", 3)
	switch(turbine2.vibration)
		if(0 to 25)
			do_message("EXCESSIVE VIBRATION IN TURBINE #2", 1)
		if(26 to 50)
			do_message("HIGH VIBRATION IN TURBINE #2", 2)
		if(51 to INFINITY)
			do_message("CRITICAL VIBRATION IN TURBINE #2", 3)

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
	var/obj/machinery/atmospherics/binary/regulated_valve/current_valve
	var/obj/machinery/reactor_button/rswitch/current_switch

	current_valve = reactor_valves["HEATEXCHANGER V-IN"]
	if(get_meter_pressure("TURBINE LINE") > 7000)
		current_valve.adjust_openage(-1)
	else
		current_valve.adjust_openage(1)
	if(get_meter_temperature("TURBINE LINE") < 450)
		current_valve = reactor_valves["TURB 1V-IN"]
		current_valve.set_openage(0)
		current_valve = reactor_valves["TURB 2V-IN"]
		current_valve.set_openage(0)
		current_switch = reactor_buttons["TURB V-BYPASS"]
		current_switch.state = 0
		current_switch.do_action()

	current_valve = reactor_valves["TURB 1V-IN"]
	if(turbine1.rpm > 3800)
		current_valve.adjust_openage(-1)
	else if(turbine1.rpm < 3600)
		current_valve.adjust_openage(1)
	current_valve = reactor_valves["TURB 2V-IN"]
	if(turbine2.rpm > 3800)
		current_valve.adjust_openage(-1)
	else if(turbine2.rpm < 3600)
		current_valve.adjust_openage(1)


/datum/reactor_control_system/proc/scram(cause)
	do_message("SCRAM. CAUSE: [capitalize(cause)]", 3)
	var/obj/machinery/atmospherics/binary/regulated_valve/current_valve
	var/obj/machinery/reactor_button/rswitch/current_switch

	//shutting down reactor
	current_valve = reactor_valves["REACTOR-F-V-IN"]
	current_valve.set_openage(0)
	current_valve = reactor_valves["REACTOR-F-V-OUT"]
	current_valve.set_openage(100)

	//shutting down turbines
	turbine1.braking = TRUE
	turbine2.braking = TRUE
	generator1.connected = FALSE
	generator2.connected = FALSE
	current_switch = reactor_buttons["TURB V-BYPASS"]
	current_switch.state = 0
	current_switch.do_action()



/datum/reactor_control_system/proc/do_message(message, urgency = 1) //urgency 1-3
	if(has_message(message))
		return //we already have that one
	all_messages[message] = urgency
	uncleared_messages[message] = urgency
	spawn(100)
		all_messages.Remove(message)
		uncleared_messages.Remove(message)

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