/obj/machinery/reactor_button/scram
	name = "SCRAM"
	cooldown = 60 SECONDS

/obj/machinery/reactor_button/scram/do_action(mob/user)
	..()
	rcontrol.scram("OPERATOR REQUEST")

/obj/machinery/reactor_button/mode_of_operation
	name = "CONTROL MODE"
	cooldown = 10 SECONDS

/obj/machinery/reactor_button/mode_of_operation/do_action(mob/user)
	..()
	var/newmode = input(user, "Select a new reactor system mode", "control mode") in list(REACTOR_CONTROL_MODE_MANUAL, REACTOR_CONTROL_MODE_SEMIAUTO, REACTOR_CONTROL_MODE_AUTO)
	var/response = rcontrol.switch_mode(newmode)
	if(!response)
		to_chat(user, SPAN_WARNING("This mode is unavailable!"))
		return
	if(response == 2)
		to_chat(user, SPAN_NOTICE("The system is already in the same mode."))
		return
	to_chat(user, SPAN_NOTICE("Reactor control mode switched to [newmode]."))