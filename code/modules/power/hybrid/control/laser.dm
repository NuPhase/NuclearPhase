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
			if(las.prime())
				playsound(src, 'sound/machines/switchbuzzer.ogg', 50)
	else
		for(var/obj/machinery/rlaser/las in reactor_components)
			las.primed = FALSE
	spawn(50)
		state = 0
		icon_state = off_icon_state

/obj/machinery/reactor_button/lasomode
	name = "LAS-OMODE"

/obj/machinery/reactor_button/lasomode/do_action(mob/user)
	..()
	var/mode = input(user, "Select a new laser operation mode", "LASER-OMODE") in list(LASER_MODE_CONTINUOUS, LASER_MODE_IGNITION, LASER_MODE_IMPULSE)
	if(!mode)
		return
	for(var/obj/machinery/rlaser/las in reactor_components)
		las.switch_omode(mode)

/obj/machinery/reactor_button/lasnmode
	name = "LAS-NMODE"

/obj/machinery/reactor_button/lasnmode/do_action(mob/user)
	..()
	var/mode = input(user, "Select a new laser neutron mode", "LASER-OMODE") in list(NEUTRON_MODE_BOMBARDMENT, NEUTRON_MODE_MODERATION, NEUTRON_MODE_OFF)
	if(!mode)
		return
	for(var/obj/machinery/rlaser/las in reactor_components)
		las.nmode = mode