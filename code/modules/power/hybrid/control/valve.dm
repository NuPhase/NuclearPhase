/obj/machinery/reactor_button/rswitch/valve
	name = "valve switch"
	icon_state = "light3"

/obj/machinery/reactor_button/rswitch/valve/do_action()
	. = ..()
	var/obj/machinery/atmospherics/valve/V = rcontrol.reactor_valves[id]
	if(!state)
		V.close()
	else
		V.open()
/obj/machinery/reactor_button/presvalve
	name = "pressure valve regulator"
	icon_state = "light3"

/obj/machinery/reactor_button/presvalve/do_action(mob/user)
	..()
	var/obj/machinery/atmospherics/binary/passive_gate/current_valve = rcontrol.reactor_valves[id]
	if(!current_valve)
		return
	var/setting = input(user, "Which setting do you want to change?", "Setting change") in list("Status", "Pressure Setting", "Direction")
	switch(setting)
		if("Status")
			var/newinput = input(user, "Select status", "Status selection") in list("On", "Off")
			if(newinput == "On")
				current_valve.unlocked = TRUE
			else
				current_valve.unlocked = FALSE
		if("Pressure Setting")
			var/newinput = input(user, "Choose Pressure", "Pressure adjustment") as null|num
			if(newinput)
				current_valve.target_pressure = clamp(newinput, 0, current_valve.max_pressure_setting)
		if("Direction")
			var/newinput = input(user, "Which direction to regulate?", "Regulation selection") in list("Input", "Output")
			if(newinput == "Input")
				current_valve.regulate_mode = 1
			else if(newinput == "Output")
				current_valve.regulate_mode = 2

/obj/machinery/reactor_button/regvalve
	name = "adjustable valve regulator"
	icon_state = "light3"

/obj/machinery/reactor_button/regvalve/do_action(mob/user)
	..()
	var/obj/machinery/atmospherics/binary/regulated_valve/current_valve = rcontrol.reactor_valves[id]
	if(!current_valve)
		return
	var/openage = input(user, "Select a new openage percentage for this valve.", "Valve regulation") as null|num
	current_valve.set_openage(Clamp(openage, 0, 100))

/obj/machinery/reactor_button/turbine_valve/do_action(mob/user)
	..()
	var/obj/machinery/atmospherics/binary/turbinestage/tst = reactor_components[id]
	var/openage = input(user, "Select a new openage percentage for this turbine.", "Turbine intake regulation") as null|num
	tst.feeder_valve_openage = Clamp(openage * 0.01, 0, 1)

/obj/machinery/reactor_button/turbine_valve/first
	name = "TURB 1V-IN"
	id = "turbine1"
	icon_state = "light3"

/obj/machinery/reactor_button/turbine_valve/second
	name = "TURB 2V-IN"
	id = "turbine2"
	icon_state = "light3"

/obj/machinery/reactor_button/rswitch/valve/turbinebypass
	name = "TURB V-BYPASS"
	id = "TURB V-BYPASS"