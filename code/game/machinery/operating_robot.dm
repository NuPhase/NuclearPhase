/obj/machinery/operating_robot
	name = "operating robot"
	desc = "An extremely complex operating robot for surgery. It uses high-precision tools that may need frequent replacement."
	icon = 'icons/obj/artillery.dmi'
	icon_state = "pointdefense"
	density = 1
	anchored = TRUE
	active_power_usage = 7000
	obj_flags = OBJ_FLAG_ANCHORABLE
	var/tools_condition = 150 //0-150. At below 100 will cause secondary damage during operations.
	var/operating = null //reference to a mob we're currently operating
	var/mythical_instrument = new /obj/item/incision_manager

/obj/machinery/operating_robot/examine(mob/user)
	. = ..()
	if(operating)
		to_chat(user, SPAN_NOTICE("It is currently operating on [operating]."))
	switch(tools_condition)
		if(100 to 150)
			to_chat(user, SPAN_NOTICE("The tools of \the [src] are in pristine condition!"))
		if(75 to 100)
			to_chat(user, SPAN_NOTICE("The tools of \the [src] are slightly worn down."))
		if(50 to 75)
			to_chat(user, SPAN_WARNING("The tools of \the [src] are quite worn down."))
		if(0 to 50)
			to_chat(user, SPAN_WARNING("The tools of \the [src] are very worn down."))

/obj/machinery/operating_robot/physical_attack_hand(user)
	. = ..()
	if(operating)
		to_chat(user, SPAN_NOTICE("\The [src] is busy!"))
		return
	if(!powered(EQUIP))
		to_chat(user, SPAN_NOTICE("\The [src] doesn't have power."))
		return
	var/chosen_bodypart = tgui_input_list(user, "Select a body part", "Bodypart Selection", all_limb_tags)
	if(!chosen_bodypart)
		return
	var/mob/surgery_target = find_target()
	if(!surgery_target)
		to_chat(user, "[SPAN_NOTICE("\The [src] couldn't find a target to operate on.")] [SPAN_INFO("Please make sure the patient is either attached to a surface or lying down.")]")
		return
	var/possible_steps = list()
	for(var/step_decl_type in subtypesof(/decl/surgery_step))
		var/decl/surgery_step/actual_decl = GET_DECL(step_decl_type)
		if(actual_decl.assess_bodypart(user, surgery_target, chosen_bodypart))
			possible_steps[actual_decl.name] = actual_decl
	var/decl/surgery_step/chosen_operation = tgui_input_list(user, "Select a surgery operation.", "Operation Selection", possible_steps)
	chosen_operation = possible_steps[chosen_operation]
	if(!chosen_operation)
		return
	operating = surgery_target
	if(!conduct_operation(surgery_target, chosen_operation, chosen_bodypart))
		visible_message(SPAN_WARNING("\The [src] has failed to conduct surgery. Please contact a system administrator."))
	else
		visible_message(SPAN_NOTICE("\The [src] finishes operating."))
	operating = null

/obj/machinery/operating_robot/proc/find_target()
	for(var/mob/living/carbon/human/H in range(1, get_turf(src)))
		if(H.lying || H.buckled)
			return H

/obj/machinery/operating_robot/proc/conduct_operation(mob/target, decl/surgery_step/chosen_operation, bodypart)
	chosen_operation.begin_step(src, target, bodypart, mythical_instrument, TRUE)
	sleep(rand(chosen_operation.min_duration, chosen_operation.max_duration))
	chosen_operation.end_step(src, target, bodypart, mythical_instrument)
	return TRUE