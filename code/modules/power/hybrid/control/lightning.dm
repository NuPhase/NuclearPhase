/obj/machinery/reactor_button/rswitch/lighting
	cooldown = 50

/obj/machinery/reactor_button/rswitch/lighting/Initialize()
	. = ..()
	do_action() //lol
	do_action()

/obj/machinery/reactor_button/rswitch/lighting/do_action()
	. = ..()
	for(var/obj/machinery/light/L in reactor_floodlights)
		if(L.uid == id)
			L.on = state
			L.update_icon()
			if(state == 1)
				playsound(L.loc, 'sound/machines/floodlight.ogg', 50, 1, 30, 10)
				sleep(5) //for dramatism

/obj/machinery/reactor_button/rswitch/lighting/superstructure
	name = "FL-MAIN"
	id = "superstructure"