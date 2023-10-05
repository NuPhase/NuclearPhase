/obj/machinery/reactor_button/pump
	name = "pump switch"
	icon_state = "switch3-off"

/obj/machinery/reactor_button/pump/Initialize()
	. = ..()
	name = "[id] MODE"

/obj/machinery/reactor_button/pump/do_action(mob/user)
	. = ..()
	var/mode = tgui_input_list(user, "Select a new pump operation mode", "Pump Mode", list(REACTOR_PUMP_MODE_OFF, REACTOR_PUMP_MODE_IDLE, REACTOR_PUMP_MODE_MAX, "Cancel"))
	if(!mode || mode == "Cancel")
		return
	switch(mode)
		if(REACTOR_PUMP_MODE_OFF)
			icon_state = "switch3-off"
		if(REACTOR_PUMP_MODE_IDLE)
			icon_state = "switch3-on"
		if(REACTOR_PUMP_MODE_MAX)
			icon_state = "switch3-max"
	var/obj/machinery/atmospherics/binary/pump/adv/P = rcontrol.reactor_pumps[id]
	P.update_mode(mode)

/obj/machinery/reactor_button/pump/fcp1
	id = "F-CP 1"

/obj/machinery/reactor_button/pump/fcp2
	id = "F-CP 2"

/obj/machinery/reactor_button/pump/tcp1
	id = "T-CP 1"

/obj/machinery/reactor_button/pump/tcp2
	id = "T-CP 2"

/obj/machinery/reactor_button/pump/feedmakeup
	name = "T-FEEDWATER-CP MAKEUP"
	id = "T-FEEDWATER CP-MAKEUP"