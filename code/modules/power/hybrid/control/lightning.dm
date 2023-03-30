/obj/machinery/reactor_button/rswitch/lighting
	cooldown = 50

/obj/machinery/reactor_button/rswitch/lighting/do_action()
	. = ..()
	var/current_spawn_time = 0
	for(var/obj/machinery/light/L in reactor_floodlights)
		if(L.uid == id)
			current_spawn_time += 5
			spawn(current_spawn_time)
				L.on = state
				L.update_icon()
				if(state == 1)
					playsound(L.loc, 'sound/machines/floodlight.ogg', 50, 1, 30, 10)

/obj/machinery/reactor_button/rswitch/lighting/superstructure
	name = "FL-MAIN"
	id = "superstructure"