/obj/machinery/reactor_button/rswitch/lasarm
	name = "LAS-ARM"
	cooldown = 20

/obj/machinery/reactor_button/rswitch/lasarm/do_action()
	..()
	if(state == 1)
		for(var/obj/machinery/rlaser/las in reactor_components)
			las.armed = TRUE
	else
		for(var/obj/machinery/rlaser/las in reactor_components)
			las.armed = FALSE


/obj/machinery/reactor_button/rswitch/lasprime
	name = "LAS-PRIMER"
	cooldown = 100

/obj/machinery/reactor_button/rswitch/lasprime/do_action()
	..()
	if(state == 1)
		for(var/obj/machinery/rlaser/las in reactor_components)
			las.prime()
		playsound(src, 'sound/machines/switchbuzzer.ogg', 50)
	else
		for(var/obj/machinery/rlaser/las in reactor_components)
			las.primed = FALSE
	spawn(50)
		state = 0
		icon_state = off_icon_state

/obj/machinery/reactor_button/rswitch/lasomode
	name = "LAS-OMODE"
/obj/machinery/reactor_button/rswitch/lasnmode
	name = "LAS-NMODE"