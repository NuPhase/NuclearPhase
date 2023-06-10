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

/obj/machinery/reactor_button/protected/containment
	name = "CONTAINMENT PRIMER"
	desc = "Turns on the reactor's shields. Has a very large cooldown."
	id = "CONTAINMENT PRIMER"
	cooldown = 5 MINUTES

/obj/machinery/reactor_button/protected/containment/do_action(mob/user)
	..()
	var/obj/machinery/power/hybrid_reactor/rcore = reactor_components["core"]
	if(rcore.containment)
		return
	rcore.containment = TRUE

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

/obj/machinery/reactor_button/protected/purge
	name = "PURGE"
	id = "PURGE"
	cooldown = 5 MINUTES

/obj/machinery/reactor_button/protected/purge/do_action(mob/user)
	..()
	var/obj/machinery/power/hybrid_reactor/rcore = reactor_components["core"]
	for(var/obj/machinery/rotating_alarm/reactor/control_room/SL in rcontrol.control_spinning_lights)
		SL.purge_alarm = new(list(SL.loc), TRUE)
		spawn(31 SECONDS)
			playsound(rcore.superstructure, 'sound/effects/purge.ogg', 300, falloff = 3)
			var/turf/T = get_turf(rcore)
			var/datum/gas_mixture/coreenvironment = T.return_air()
			var/datum/gas_mixture/total_mixture = coreenvironment.remove_ratio(0.8)
			var/turf/sT = get_turf(rcore.superstructure)
			var/datum/gas_mixture/senvironment = sT.return_air()
			senvironment.merge(total_mixture.remove_ratio(0.05))
		spawn(50 SECONDS)
			QDEL_NULL(SL.purge_alarm)