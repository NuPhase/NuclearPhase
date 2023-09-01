/obj/machinery/reactor_button/rswitch/lasarm
	name = "LAS-ARM"
	cooldown = 20
	icon_state = "switch2-off"
	off_icon_state = "switch2-off"
	on_icon_state = "switch2-on"

/obj/machinery/reactor_button/rswitch/lasarm/do_action(mob/user)
	..()
	visible_message(SPAN_WARNING("[user] switches [src] to [state ? "ARMED" : "DISARMED"]!"))
	for(var/tag in reactor_components)
		var/obj/machinery/rlaser/las = reactor_components[tag]
		if(!istype(las, /obj/machinery/rlaser))
			continue
		las.armed = state
		if(state)
			las.operating = TRUE
			START_PROCESSING_MACHINE(las, MACHINERY_PROCESS_SELF)
		else
			las.operating = FALSE
			STOP_PROCESSING_MACHINE(las, MACHINERY_PROCESS_SELF)


/obj/machinery/reactor_button/rswitch/lasprime
	name = "LAS-PRIMER"
	cooldown = 10
	icon_state = "switch2-off"
	off_icon_state = "switch2-off"
	on_icon_state = "switch2-on"

/obj/machinery/reactor_button/rswitch/lasprime/do_action(mob/user)
	..()
	visible_message(SPAN_WARNING("[user] switches [src] to [state ? "PRIMED" : "ABORT"]!"))
	if(state == 1)
		var/primed = FALSE
		var/total_energy = 0
		for(var/tag in reactor_components)
			var/obj/machinery/rlaser/las = reactor_components[tag]
			if(!istype(las, /obj/machinery/rlaser))
				continue
			if(las.prime())
				total_energy += las.capacitor_charge * las.active_power_usage
				primed = TRUE
		if(primed)
			playsound(src, 'sound/machines/switchbuzzer.ogg', 50)
		spawn(5 SECONDS)
			for(var/obj/machinery/reactor_monitor/warnings/mon in rcontrol.announcement_monitors)
				mon.chat_report("LASERS DISCHARGED. TOTAL ENERGY: [watts_to_text(total_energy)]/s*1.4.", 1)
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
	icon_state = "button2"

/obj/machinery/reactor_button/lasomode/do_action(mob/user)
	..()
	var/mode = input(user, "Select a new laser operation mode", "LASER-OMODE") in list(LASER_MODE_CONTINUOUS, LASER_MODE_IGNITION, LASER_MODE_IMPULSE, "Cancel")
	if(!mode || mode == "Cancel")
		return
	for(var/tag in reactor_components)
		var/obj/machinery/rlaser/las = reactor_components[tag]
		if(!istype(las, /obj/machinery/rlaser))
			continue
		las.switch_omode(mode)
	visible_message(SPAN_WARNING("[user] switches [src] to [mode]!"))

/obj/machinery/reactor_button/lasnmode
	name = "LAS-NMODE"
	icon_state = "button2"

/obj/machinery/reactor_button/lasnmode/do_action(mob/user)
	..()
	var/mode = input(user, "Select a new laser neutron mode", "LASER-OMODE") in list(NEUTRON_MODE_BOMBARDMENT, NEUTRON_MODE_MODERATION, NEUTRON_MODE_OFF, "Cancel")
	if(!mode || mode == "Cancel")
		return
	for(var/tag in reactor_components)
		var/obj/machinery/rlaser/las = reactor_components[tag]
		if(!istype(las, /obj/machinery/rlaser))
			continue
		las.nmode = mode
	visible_message(SPAN_WARNING("[user] switches [src] to [mode]!"))