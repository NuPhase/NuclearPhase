/obj/machinery/reactor_button/scram
	name = "SCRAM"
	cooldown = 60 SECONDS

/obj/machinery/reactor_button/scram/do_action(mob/user)
	..()
	rcontrol.scram("OPERATOR REQUEST")
	visible_message(SPAN_WARNING("[user] SCRAMs the reactor!"))
	playsound(src, 'sound/machines/switchbuzzer.ogg', 50)

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
	visible_message(SPAN_WARNING("[user] switches [src] to [newmode]!"))

/obj/machinery/reactor_button/acknowledge_alarms
	name = "ACKNOWLEDGE ALARMS"
	cooldown = 5 SECONDS

/obj/machinery/reactor_button/acknowledge_alarms/do_action(mob/user)
	..()
	rcontrol.cleared_messages = rcontrol.all_messages.Copy()

/obj/machinery/reactor_button/mute_alarms
	name = "MUTE ALARMS"
	cooldown = 5 SECONDS