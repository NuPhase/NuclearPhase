/obj/machinery/material_processing
	density =  TRUE
	anchored = TRUE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "compressor-off"
	var/obj/item/stack/ore/processing_stack
	var/required_flag = ORE_FLAG_CRUSHED
	var/produced_flag = ORE_FLAG_SEPARATED_CRUDE
	var/amount_processed = 1 //mass of material processed per Process() tick
	var/already_processed = 0
	var/finish_message = "grinds to a halt."
	var/active_state = "compressor"

/obj/machinery/material_processing/examine(mob/user)
	. = ..()
	if(!processing_stack)
		return
	if(processing_stack.processing_flags & required_flag)
		to_chat(user, "It has finished running and can be emptied.")

/obj/machinery/material_processing/attackby(obj/item/I, mob/user)
	. = ..()
	if(istype(I, /obj/item/stack/ore) && !processing_stack)
		if(!user.do_skilled(50, SKILL_DEVICES, src))
			return
		user.visible_message("[user] loads \the [src].")
		user.drop_from_inventory(I, src)
		processing_stack = I
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/material_processing/physical_attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(use_power == POWER_USE_ACTIVE)
		if(ishuman(user))
			if(user.get_skill_value(SKILL_DEVICES) > SKILL_BASIC)
				return //your hand is saved you smart virgin
			var/affected = pick(BP_R_HAND, BP_L_HAND)
			var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(user, affected)
			affecting.take_external_damage(rand(20, 30), damage_flags = DAM_SHARP)
			user.visible_message(SPAN_DANGER("[user]'s hand gets mangled by \the [src]!"))
	else if(processing_stack)
		if(!user.do_skilled(50, SKILL_DEVICES, src))
			return
		user.visible_message("[user] unloads \the [src].")
		processing_stack.forceMove(get_turf(src))
		processing_stack = null
		use_power = POWER_USE_IDLE
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_ALL)

/obj/machinery/material_processing/proc/can_work()
	if(!processing_stack)
		return FALSE
	if(!powered(EQUIP))
		return FALSE
	if(processing_stack.processing_flags & produced_flag)
		return FALSE
	if(processing_stack.processing_flags & required_flag)
		return TRUE
	return FALSE

/obj/machinery/material_processing/proc/finish_processing()
	processing_stack.processing_flags |= produced_flag
	visible_message("[src] [finish_message]")
	already_processed = 0

/obj/machinery/material_processing/Process()
	if(!can_work())
		use_power = POWER_USE_IDLE
		icon_state = initial(icon_state)
		return FALSE
	use_power = POWER_USE_ACTIVE
	icon_state = active_state
	already_processed += amount_processed
	if(already_processed > processing_stack.amount)
		finish_processing()