/obj/machinery/reactor_button/protected/scram
	name = "EP-SCRAM"
	id = "EP-SCRAM"
	cooldown = 60 SECONDS

/obj/machinery/reactor_button/protected/scram/do_action(mob/user)
	..()
	rcontrol.scram("OPERATOR REQUEST")
	visible_message(SPAN_WARNING("[user] SCRAMs the reactor!"))

/obj/machinery/reactor_button/protected/mode_of_operation
	name = "CONTROL MODE"
	cooldown = 10 SECONDS

/obj/machinery/reactor_button/protected/mode_of_operation/do_action(mob/user)
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

/obj/machinery/reactor_button/rswitch/autoscram
	name = "AUTOSCRAM"
	id = "AUTOSCRAM"
	cooldown = 5 SECONDS

/obj/machinery/reactor_button/rswitch/autoscram/do_action(mob/user)
	..()
	rcontrol.scram_control = state
	if(state)
		visible_message(SPAN_NOTICE("[user] turns on automatic SCRAM control."))
	else
		visible_message(SPAN_WARNING("[user] shuts down automatic SCRAM control."))

/obj/machinery/reactor_button/acknowledge_alarms
	name = "ACKNOWLEDGE ALARMS"
	cooldown = 5 SECONDS

/obj/machinery/reactor_button/acknowledge_alarms/do_action(mob/user)
	..()
	rcontrol.cleared_messages = rcontrol.all_messages.Copy()

/obj/machinery/reactor_button/mute_alarms
	name = "MUTE ALARMS"
	cooldown = 1 MINUTE

/obj/machinery/reactor_button/mute_alarms/do_action(mob/user)
	..()
	visible_message(SPAN_WARNING("[user] temporarily disables the control system alarms."))
	rcontrol.should_alarm = FALSE
	spawn(2 MINUTE)
		rcontrol.should_alarm = TRUE
	for(var/obj/machinery/rotating_alarm/reactor/control_room/SL in rcontrol.control_spinning_lights)
		QDEL_NULL(SL.oo_alarm)
		QDEL_NULL(SL.arm_alarm)
