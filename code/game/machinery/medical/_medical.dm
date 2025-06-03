/obj/machinery/medical
	icon = 'icons/obj/structures/iv_drip.dmi'
	icon_state = "abcs-off"
	density = FALSE
	active_power_usage = 200
	var/mob/living/carbon/human/connected = null
	var/required_skill_type = SKILL_MEDICAL
	var/required_skill_level = SKILL_BASIC
	var/connection_time = 10 SECONDS
	var/max_distance = 4

	var/datum/beam/connection_beam
	var/connection_beam_icon_state = "1-full"
	var/connection_beam_color = COLOR_BLUE_LIGHT

/obj/machinery/medical/Destroy()
	. = ..()
	connected = null
	QDEL_NULL(connection_beam)

/obj/machinery/medical/Initialize()
	. = ..()
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/medical/handle_mouse_drop(atom/over, mob/user)
	if(connected)
		try_disconnect(user)
		return TRUE
	if(ishuman(over))
		try_connect(user, over)
		return TRUE
	. = ..()

/obj/machinery/medical/proc/try_disconnect(mob/living/carbon/human/user)
	if(!connected)
		to_chat(user, SPAN_WARNING("\The [src] isn't connected to anyone."))
		return FALSE
	if(!user.skill_check(required_skill_type, required_skill_level))
		to_chat(user, SPAN_WARNING("You don't know how to safely disconnect \the [src]."))
		return FALSE
	if(tgui_alert(user, "Are you sure you want to disconnect \the [src]?", "[src]", list("No", "Yes")) != "Yes")
		return FALSE
	disconnect(user)
	return TRUE

/obj/machinery/medical/proc/try_connect(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/connect_attempt_result = can_connect(user, target)
	if(connect_attempt_result != TRUE)
		to_chat(user, SPAN_WARNING(connect_attempt_result))
		return FALSE
	visible_message(SPAN_NOTICE("[user] starts connecting [target] to \the [src]."))
	var/adjusted_time = connection_time / (user.get_skill_value(required_skill_type) - required_skill_level + 1)
	if(!do_mob(user, target, adjusted_time))
		return FALSE
	connect(user, target)

/obj/machinery/medical/proc/can_connect(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(connected)
		return "\The [src] is already connected to someone."
	if(!user.skill_check(required_skill_type, required_skill_level))
		return "You don't have enough skill to connect \the [src]."
	if(get_dist(user, target) > max_distance || get_dist(user, src) > 1)
		return "You're too far to connect \the [src]."
	return TRUE

/obj/machinery/medical/proc/connect(mob/living/carbon/human/user, mob/living/carbon/human/target)
	connected = target
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	visible_message(SPAN_NOTICE("[user] connects \the [src] to [target]."))
	connection_beam = Beam(connected, connection_beam_icon_state, time = INFINITY, beam_color = connection_beam_color)
	return

/obj/machinery/medical/proc/disconnect(mob/living/carbon/human/user)
	visible_message(SPAN_WARNING("[user] disconnects \the [src] from [connected]."))
	connected = null
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	QDEL_NULL(connection_beam)
	return