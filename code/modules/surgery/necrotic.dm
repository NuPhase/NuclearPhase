//////////////////////////////////////////////////////////////////
//	 Necrotic organ recovery
//////////////////////////////////////////////////////////////////
/decl/surgery_step/necrotic
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_ROBOTIC | SURGERY_NEEDS_ENCASEMENT
	blood_level = 1
	shock_level = 30
	surgery_step_category = /decl/surgery_step/necrotic

//////////////////////////////////////////////////////////////////
//	 Necrotic tissue removal
//////////////////////////////////////////////////////////////////
/decl/surgery_step/necrotic/tissue
	name = "Remove necrotic tissue"
	description = "This procedure removes tissue lost to necrosis and prepares for regeneration."
	allowed_tools = list(TOOL_SCALPEL = 90)
	min_duration = 150
	max_duration = 170

/decl/surgery_step/necrotic/tissue/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	. = ..()
	if(.)
		var/obj/item/organ/external/affected = .
		if(affected.status & ORGAN_DEAD && affected.germ_level > INFECTION_LEVEL_ONE)
			return TRUE
		for(var/obj/item/organ/O in affected.internal_organs)
			if(O.status & ORGAN_DEAD && O.germ_level > INFECTION_LEVEL_ONE)
				return TRUE
		return FALSE

/decl/surgery_step/necrotic/tissue/pre_surgery_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)

	var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(target, target_zone)
	if(!E)
		to_chat(user, SPAN_WARNING("\The [target] is missing that limb."))
		return FALSE

	var/list/dead_organs
	if((E.status & ORGAN_DEAD) && E.germ_level > INFECTION_LEVEL_ONE)
		var/image/radial_button = image(icon = E.icon, icon_state = E.icon_state)
		radial_button.name = "Debride \the [E]"
		LAZYSET(dead_organs, E.organ_tag, radial_button)

	for(var/obj/item/organ/internal/I in E.internal_organs)
		if(I && (I.status & ORGAN_DEAD) && I.germ_level > INFECTION_LEVEL_ONE && I.parent_organ == target_zone)
			var/image/radial_button = image(icon = I.icon, icon_state = I.icon_state)
			radial_button.name = "Debride \the [I]"
			LAZYSET(dead_organs, I.organ_tag, radial_button)

	if(!LAZYLEN(dead_organs))
		to_chat(user, SPAN_WARNING("You can't find any dead tissue to remove."))
	else
		if(length(dead_organs) == 1)
			return dead_organs[1]
		return show_radial_menu(user, tool, dead_organs, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))
	return FALSE

/decl/surgery_step/necrotic/tissue/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/affected = target.get_organ(target_zone)
	if(affected)
		var/target_organ = LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)
		user.visible_message(
			"\The [user] slowly starts removing necrotic tissue from \the [target]'s [target_organ] with \the [tool].", \
			"You slowly start removing necrotic tissue from \the [target]'s [target_organ] with \the [tool].")
		target.custom_pain("You feel sporadic spikes of pain from points around your [affected.name]!",200, affecting = affected)
	..()

/decl/surgery_step/necrotic/tissue/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/target_organ = LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] has excised the necrotic tissue from \the [target]'s [target_organ] with \the [tool]."), \
		SPAN_NOTICE("You have excised the necrotic tissue from \the [target]'s [target_organ] with \the [tool]."))
	playsound(target.loc, 'sound/weapons/bladeslice.ogg', 15, 1)

	var/obj/item/organ/O = target.get_organ(LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone))
	if(O)
		O.germ_level = min(INFECTION_LEVEL_ONE, O.germ_level * 0.4)

/decl/surgery_step/necrotic/tissue/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/affected = target.get_organ(target_zone)
	if(affected)
		user.visible_message(
			SPAN_DANGER("\The [user]'s hand slips, slicing into a healthy portion of \the [target]'s [affected.name] with \the [tool]!"),
			SPAN_DANGER("Your hand slips, slicing into a healthy portion of [target]'s [affected.name] with \the [tool]!"))
		affected.take_external_damage(10, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)