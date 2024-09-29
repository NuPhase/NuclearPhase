/obj/machinery/reactor_button/rswitch/valve
	name = "valve switch"
	icon_state = "switch1-off"
	off_icon_state = "switch1-off"
	on_icon_state = "switch1-on"

/obj/machinery/reactor_button/rswitch/valve/do_action()
	. = ..()
	var/obj/machinery/atmospherics/valve/V = rcontrol.reactor_valves[id]
	if(!state)
		V.close()
		rcontrol.make_log("VALVE [id] CLOSED.", 1)
	else
		V.open()
		rcontrol.make_log("VALVE [id] OPENED.", 1)

/obj/machinery/reactor_button/turn_switch/presvalve
	name = "pressure valve regulator"

/obj/machinery/reactor_button/turn_switch/presvalve/do_action(mob/user)
	..()
	var/obj/machinery/atmospherics/binary/passive_gate/current_valve = rcontrol.reactor_valves[id]
	if(!current_valve)
		return
	var/setting = tgui_input_list(user, "Which setting do you want to change?", "Setting change", list("Status", "Pressure Setting", "Direction"))
	switch(setting)
		if("Status")
			var/newinput = tgui_input_list(user, "Select status", "Status selection", list("On", "Off"))
			if(newinput == "On")
				current_valve.unlocked = TRUE
			else
				current_valve.unlocked = FALSE
		if("Pressure Setting")
			var/newinput = tgui_input_number(user, "Choose Max Pressure", "Pressure adjustment", current_valve.max_pressure_setting, 15000, 0)
			if(newinput)
				current_valve.target_pressure = clamp(newinput, 0, current_valve.max_pressure_setting)
		if("Direction")
			var/newinput = tgui_input_list(user, "Which direction to regulate?", "Regulation selection", list("Input", "Output"))
			if(newinput == "Input")
				current_valve.regulate_mode = 1
			else if(newinput == "Output")
				current_valve.regulate_mode = 2

/obj/machinery/reactor_button/turn_switch/regvalve
	name = "adjustable valve regulator"

/obj/machinery/reactor_button/turn_switch/regvalve/do_action(mob/user)
	..()
	var/obj/machinery/atmospherics/binary/regulated_valve/current_valve = rcontrol.reactor_valves[id]
	if(!current_valve)
		return
	var/openage = tgui_input_number(user, "Select a new openage percentage for this valve.", "Valve regulation", 0, 100, 0)
	if(isnum(openage))
		current_valve.set_openage(Clamp(openage, 0, 100))
		update_icon(openage * 0.01)

/obj/machinery/reactor_button/turn_switch/turbine_valve/do_action(mob/user)
	..()
	var/obj/machinery/atmospherics/binary/turbinestage/tst = reactor_components[id]
	var/openage = tgui_input_number(user, "Select a new openage percentage for this turbine.", "Turbine intake regulation", 0, 100, 0)
	if(isnum(openage))
		tst.feeder_valve_openage = Clamp(openage * 0.01, 0, 1)
		update_icon(openage * 0.01)

/obj/machinery/reactor_button/turn_switch/turbine_valve/first
	name = "TURB 1V-IN"
	id = "turbine1"

/obj/machinery/reactor_button/turn_switch/turbine_valve/second
	name = "TURB 2V-IN"
	id = "turbine2"

/obj/machinery/reactor_button/rswitch/valve/turbinebypass
	name = "TURB V-BYPASS"
	id = "TURB V-BYPASS"
	icon_state = "switch1-off"
	off_icon_state = "switch1-off"
	on_icon_state = "switch1-on"

/obj/machinery/reactor_button/rswitch/turbine_expansion/first
	name = "TURB 1-EXPANSION"
	id = "turbine1"

/obj/machinery/reactor_button/rswitch/turbine_expansion/second
	name = "TURB 2-EXPANSION"
	id = "turbine2"

/obj/machinery/reactor_button/rswitch/turbine_expansion/do_action(mob/user)
	..()
	var/obj/machinery/atmospherics/binary/turbinestage/tst = reactor_components[id]
	var/expansion = tgui_input_number(user, "Select a new expansion percentage for this turbine.", "Turbine expansion regulation", 0, 100, 0)
	if(isnum(expansion))
		tst.expansion_ratio = Clamp(expansion * 0.01, 0.65, 0.87)

/obj/machinery/reactor_button/rswitch/turbine_grates
	name = "TURB V-GRATES"
	id = "turbine_grates"

/obj/machinery/reactor_button/rswitch/turbine_grates/do_action(mob/user)
	..()
	var/obj/machinery/atmospherics/binary/turbinestage/tst = reactor_components["turbine1"]
	tst.water_grates_open = state
	tst = reactor_components["turbine2"]
	tst.water_grates_open = state

/obj/machinery/reactor_button/relief_valve
	name = "relief valve"
	var/working = FALSE
	icon_state = "switch1-off"
	cooldown = 5.1 SECONDS

/obj/machinery/reactor_button/relief_valve/do_action(mob/user)
	..()
	if(!working)
		rcontrol.make_log("RELIEF VALVE [id] ENGAGED.", 2)
		working = TRUE
		icon_state = "switch1-on"
		var/obj/machinery/atmospherics/binary/passive_gate/current_valve = rcontrol.reactor_valves[id]
		var/memorized_pressure_setting = current_valve.target_pressure
		current_valve.target_pressure = 0
		spawn(5 SECONDS)
			current_valve.target_pressure = memorized_pressure_setting
			working = FALSE
			icon_state = "switch1-off"