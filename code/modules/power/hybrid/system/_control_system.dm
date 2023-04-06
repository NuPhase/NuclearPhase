#define MAX_REACTOR_VESSEL_PRESSURE 500000 //kPa
#define ALARM_REACTOR_TUNGSTEN_TEMP 3700
#define MAX_REACTOR_TUNGSTEN_TEMP 3800
#define OPERATIONAL_REACTOR_TUNGSTEN_TEMP 3550

#define OPTIMAL_REACTOR_STEAM_TEMP 700
#define MAX_REACTOR_STEAM_TEMP 800
#define OPTIMAL_TURBINE_MASS_FLOW 500

/datum/reactor_control_system
	var/name = "'Velocity' Control System"
	var/mode = REACTOR_CONTROL_MODE_MANUAL
	var/semiautocontrol_available = TRUE
	var/autocontrol_available = FALSE
	var/scram_control = FALSE //should we autoscram?

	var/list/all_messages = list()
	var/list/cleared_messages = list()

	var/list/spinning_lights = list()
	var/list/control_spinning_lights = list() //these are specifically inside the control room and similiar areas
	var/list/radlocks = list()

	var/list/reactor_pumps = list()
	var/list/reactor_meters = list()
	var/list/reactor_valves = list()
	var/list/announcement_monitors = list() //list of monitors we should announce warnings on
	var/obj/machinery/atmospherics/binary/turbinestage/turbine1 = null
	var/obj/machinery/atmospherics/binary/turbinestage/turbine2 = null
	var/obj/machinery/power/generator/turbine_generator/generator1 = null
	var/obj/machinery/power/generator/turbine_generator/generator2 = null
	var/last_message_clearing = 0

	var/should_alarm = TRUE
	var/pressure_temperature_should_alarm = FALSE

	var/list/unwanted_materials = list(
		/decl/material/solid/metal/fission_byproduct,
		/decl/material/gas/oxygen,
		/decl/material/gas/nitrogen,
		/decl/material/gas/helium,
		/decl/material/solid/caesium
	)

/datum/reactor_control_system/proc/initialize()
	turbine1 = reactor_components["turbine1"]
	turbine2 = reactor_components["turbine2"]
	generator1 = reactor_components["generator1"]
	generator2 = reactor_components["generator2"]
	if(!turbine1 || !turbine2)
		spawn(50)
			initialize()

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
	do_alarms()
	switch(mode)
		if(REACTOR_CONTROL_MODE_SEMIAUTO)
			semi_auto_control()
	if(scram_control)
		check_autoscram()
	last_message_clearing += 1
	if(last_message_clearing == 5)
		for(var/cleared_message in cleared_messages)
			if(cleared_message in all_messages)
				all_messages.Remove(cleared_message)
		cleared_messages.Cut()
		last_message_clearing = 0

/datum/reactor_control_system/proc/semi_auto_control()
	moderate_reactor_loop()
	moderate_turbine_loop()

/datum/reactor_control_system/proc/check_autoscram()
	if(turbine1.vibration > 50)
		scram("TURBINE #1 VIBRATION TRIP")
	if(turbine2.vibration > 50)
		scram("TURBINE #2 VIBRATION TRIP")

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

	if(turbine1.rpm > 500 || turbine2.rpm > 500) //you shouldn't accelerate past that without load
		if(generator1.last_load < 50000 || generator2.last_load < 50000)
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

	if(get_meter_temperature("REACTOR-M CHAMBER") > 3950)
		do_message("REACTOR HEATEXCHANGER OVERHEAT", 2)
		pressure_temperature_should_alarm = TRUE
	if(get_meter_temperature("REACTOR-M CHAMBER") < 3500 && get_meter_mass("REACTOR-M CHAMBER") > 10)
		do_message("REACTOR HEATEXCHANGER TEMPERATURE LOW", 2)
		pressure_temperature_should_alarm = TRUE
	if(get_meter_temperature("T-M-TURB IN") > 630)
		do_message("TURBINE HEATEXCHANGER TEMPERATURE HIGH", 2)
		pressure_temperature_should_alarm = TRUE
	if(get_meter_temperature("T-M-TURB EX") > 380)
		do_message("TURBINE CONDENSER TEMPERATURE HIGH", 2)
		pressure_temperature_should_alarm = TRUE

	if(get_meter_pressure("T-M-TURB IN") > 12000)
		do_message("TURBINE INLET OVERPRESSURE", 2)
		pressure_temperature_should_alarm = TRUE
	if(get_meter_pressure("T-M-TURB EX") > 3000)
		do_message("TURBINE CONDENSER OVERPRESSURE", 2)
		pressure_temperature_should_alarm = TRUE

	if(get_pump_flow_rate("F-CP 1") < 50)
		do_message("REACTOR LOOP PUMP #1 MASS FLOW < 25KG/S", 1)
	if(get_pump_flow_rate("F-CP 2") < 50)
		do_message("REACTOR LOOP PUMP #2 MASS FLOW < 25KG/S", 1)
	if(get_pump_flow_rate("T-CP 1") < 50)
		do_message("TURBINE LOOP PUMP #1 MASS FLOW < 50KG/S", 1)
	if(get_pump_flow_rate("T-CP 2") < 50)
		do_message("TURBINE LOOP PUMP #2 MASS FLOW < 50KG/S", 1)

	if(get_meter_temperature("T-M-TURB EX") > 390)
		do_message("VAPOR IN FEEDWATER LOOP", 2)

/datum/reactor_control_system/proc/moderate_reactor_loop()
	return

/datum/reactor_control_system/proc/moderate_turbine_loop()
	var/obj/machinery/atmospherics/binary/regulated_valve/current_valve
	var/obj/machinery/atmospherics/binary/passive_gate/current_gate
	//var/obj/machinery/reactor_button/rswitch/current_switch

	current_valve = reactor_valves["HEATEXCHANGER V-IN"]
	if(get_meter_pressure("T-M-TURB IN") > 15000)
		current_valve.adjust_openage(-1)
	else
		current_valve.adjust_openage(1)

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

	if(get_meter_temperature("T-M-TURB IN") < 550)
		turbine1.feeder_valve_openage = 0
		turbine2.feeder_valve_openage = 0
		return

	if(get_meter_temperature("T-M-TURB IN") < 570)
		turbine1.feeder_valve_openage = max(0, turbine1.feeder_valve_openage - 0.1)
		turbine2.feeder_valve_openage = max(0, turbine2.feeder_valve_openage - 0.1)

	if(turbine1.rpm > 3600)
		turbine1.feeder_valve_openage = max(0, turbine1.feeder_valve_openage - 0.05)
	else if(turbine1.rpm < 3500)
		turbine1.feeder_valve_openage = min(1, turbine1.feeder_valve_openage + 0.01)

	if(turbine2.rpm > 3600)
		turbine2.feeder_valve_openage = max(0, turbine2.feeder_valve_openage - 0.05)
	else if(turbine2.rpm < 3500)
		turbine2.feeder_valve_openage = min(1, turbine2.feeder_valve_openage + 0.01)


/datum/reactor_control_system/proc/scram(cause)
	do_message("SCRAM. CAUSE: [capitalize(cause)]", 3)
	var/obj/machinery/atmospherics/binary/regulated_valve/current_valve
	var/obj/machinery/reactor_button/rswitch/current_switch

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

	//shutting down turbines
	turbine1.feeder_valve_openage = 0
	turbine2.feeder_valve_openage = 0
	generator1.connected = FALSE
	generator2.connected = FALSE
	current_switch = reactor_buttons["TURB V-BYPASS"]
	current_switch.state = 0
	current_switch.do_action()

	mode = REACTOR_CONTROL_MODE_MANUAL
	scram_control = FALSE

/datum/reactor_control_system/proc/do_message(message, urgency = 1) //urgency 1-3
	if(has_message(message))
		return //we already have that one
	all_messages[message] = urgency
	for(var/obj/machinery/reactor_monitor/warnings/mon in announcement_monitors)
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