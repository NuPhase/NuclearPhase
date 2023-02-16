/obj/machinery/reactor_button/rswitch/valve
	name = "valve switch"
	icon_state = "light3"
	var/id = ""

/obj/machinery/reactor_button/rswitch/valve/do_action()
	. = ..()
	var/obj/machinery/atmospherics/valve/V = rcontrol.reactor_valves[id]
	if(state)
		V.close()
	else
		V.open()
/obj/machinery/reactor_button/presvalve
	name = "valve regulator"
	icon_state = "light3"
	var/id = ""