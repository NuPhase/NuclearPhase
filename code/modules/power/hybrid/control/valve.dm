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

/obj/machinery/reactor_button/regvalve/turbine1
	name = "TURB 1V-IN"
	id = "TURB 1V-IN"

/obj/machinery/reactor_button/regvalve/turbine2
	name = "TURB 2V-IN"
	id = "TURB 2V-IN"

/obj/machinery/reactor_button/rswitch/valve/turbinebypass
	name = "TURB V-BYPASS"
	id = "TURB V-BYPASS"