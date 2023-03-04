/obj/machinery/reactor_button/rswitch/lasarm
	name = "LAS-ARM"
	cooldown = 20

/obj/machinery/reactor_button/rswitch/lasarm/do_action(mob/user)
	..()
	visible_message(SPAN_WARNING("[user] switches [src] to [state ? "ARMED" : "DISARMED"]!"))
	for(var/tag in reactor_components)
		var/obj/machinery/rlaser/las = reactor_components[tag]
		if(!istype(las, /obj/machinery/rlaser))
			continue
		las.armed = state


/obj/machinery/reactor_button/rswitch/lasprime
	name = "LAS-PRIMER"
	cooldown = 100

/obj/machinery/reactor_button/rswitch/lasprime/do_action(mob/user)
	..()
	visible_message(SPAN_WARNING("[user] switches [src] to [state ? "PRIMED" : "ABORT"]!"))
	if(state == 1)
		var/primed = FALSE
		for(var/tag in reactor_components)
			var/obj/machinery/rlaser/las = reactor_components[tag]
			if(!istype(las, /obj/machinery/rlaser))
				continue
			if(las.prime())
				primed = TRUE
		if(primed)
			playsound(src, 'sound/machines/switchbuzzer.ogg', 50)
		spawn(5 SECONDS)
			state = 0
			icon_state = off_icon_state
	else
		for(var/tag in reactor_components)
			var/obj/machinery/rlaser/las = reactor_components[tag]
			if(!istype(las, /obj/machinery/rlaser))
				continue
			las.primed = FALSE

/obj/machinery/reactor_button/lasomode
	name = "LAS-OMODE"

/obj/machinery/reactor_button/lasomode/do_action(mob/user)
	..()
	var/mode = input(user, "Select a new laser operation mode", "LASER-OMODE") in list(LASER_MODE_CONTINUOUS, LASER_MODE_IGNITION, LASER_MODE_IMPULSE)
	if(!mode)
		return
	for(var/tag in reactor_components)
		var/obj/machinery/rlaser/las = reactor_components[tag]
		if(!istype(las, /obj/machinery/rlaser))
			continue
		las.switch_omode(mode)
	visible_message(SPAN_WARNING("[user] switches [src] to [mode]!"))

/obj/machinery/reactor_button/lasnmode
	name = "LAS-NMODE"

/obj/machinery/reactor_button/lasnmode/do_action(mob/user)
	..()
	var/mode = input(user, "Select a new laser neutron mode", "LASER-OMODE") in list(NEUTRON_MODE_BOMBARDMENT, NEUTRON_MODE_MODERATION, NEUTRON_MODE_OFF)
	if(!mode)
		return
	for(var/tag in reactor_components)
		var/obj/machinery/rlaser/las = reactor_components[tag]
		if(!istype(las, /obj/machinery/rlaser))
			continue
		las.nmode = mode
	visible_message(SPAN_WARNING("[user] switches [src] to [mode]!"))