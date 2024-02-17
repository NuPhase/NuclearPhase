/decl/surgery_step/suit_cut
	name = "Slice suit apart"
	allowed_tools = list(
		TOOL_WELDER = 80
	)
	can_infect = 1
	blood_level = 0
	min_duration = 120
	max_duration = 180
	surgery_candidate_flags = 0
	hidden_from_codex = TRUE

/decl/surgery_step/suit_cut/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	return TRUE

/decl/surgery_step/suit_cut/get_skill_reqs(mob/living/user, mob/living/target, obj/item/tool)
	return list(SKILL_EVA = SKILL_NONE)

/decl/surgery_step/suit_cut/can_use(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	if(!istype(target))
		return FALSE
	if(IS_WELDER(tool))
		var/obj/item/weldingtool/welder = tool
		if(!welder.isOn() || !welder.remove_fuel(1,user))
			return FALSE
	var/obj/item/clothing/suit/modern/space/msuit = target.get_equipped_item(slot_wear_suit_str)
	return (target_zone == BP_CHEST) && istype(msuit)

/decl/surgery_step/suit_cut/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/clothing/suit/modern/space/msuit = target.get_equipped_item(slot_wear_suit_str)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("[user] starts cutting through the outer material of [target]'s [msuit] with \the [tool]." , \
	"You start cutting through the outer material of [target]'s [msuit] with \the [tool].")
	target.custom_pain("Something is burning its way through your flesh!", 250, affecting = affected)
	affected.take_external_damage(0, 15, used_weapon = tool)
	..()

/decl/surgery_step/suit_cut/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/mhelmet = target.get_equipped_item(slot_head_str)
	var/obj/item/clothing/suit/modern/space/msuit = target.get_equipped_item(slot_wear_suit_str)
	if(!istype(msuit))
		return
	msuit.leakiness = 50
	msuit.canremove = TRUE
	mhelmet.canremove = TRUE
	target.drop_from_inventory(msuit)
	target.drop_from_inventory(mhelmet)
	user.visible_message("<span class='notice'>[user] has cut through the [target]'s [msuit] with \the [tool].</span>", \
		"<span class='notice'>You have cut through the [target]'s [msuit] with \the [tool].</span>")

/decl/surgery_step/suit_cut/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	user.visible_message("<span class='danger'>[user]'s [tool] can't quite seem to get through the metal...</span>", \
	"<span class='danger'>Your [tool] can't quite seem to get through the metal. It's weakening, though - try again.</span>")



/decl/surgery_step/suit_unbolt
	name = "Unbolt suit"
	allowed_tools = list(
		TOOL_SCREWDRIVER = 80
	)
	can_infect = 0
	blood_level = 0
	min_duration = 200
	max_duration = 250
	surgery_candidate_flags = 0
	hidden_from_codex = TRUE

/decl/surgery_step/suit_unbolt/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	return TRUE

/decl/surgery_step/suit_unbolt/get_skill_reqs(mob/living/user, mob/living/target, obj/item/tool)
	return list(SKILL_CONSTRUCTION = SKILL_BASIC)

/decl/surgery_step/suit_unbolt/can_use(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	if(!istype(target))
		return FALSE
	if(tool.get_tool_quality(TOOL_SCREWDRIVER) < TOOL_QUALITY_GOOD)
		to_chat(user, SPAN_WARNING("\The [tool] is too weak to take out these bolts."))
	var/obj/item/clothing/suit/modern/space/msuit = target.get_equipped_item(slot_wear_suit_str)
	return (target_zone == BP_CHEST) && istype(msuit)

/decl/surgery_step/suit_unbolt/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/clothing/suit/modern/space/msuit = target.get_equipped_item(slot_wear_suit_str)
	user.visible_message("[user] starts carefully unbolting [target]'s [msuit] with \the [tool]." , \
	"You start unbolting [target]'s [msuit] with \the [tool].")
	..()

/decl/surgery_step/suit_unbolt/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/mhelmet = target.get_equipped_item(slot_head_str)
	var/obj/item/clothing/suit/modern/space/msuit = target.get_equipped_item(slot_wear_suit_str)
	if(!istype(msuit))
		return
	msuit.canremove = TRUE
	mhelmet.canremove = TRUE
	target.drop_from_inventory(msuit)
	target.drop_from_inventory(mhelmet)
	user.visible_message("<span class='notice'>[user] has unbolted the [target]'s [msuit] with \the [tool].</span>", \
		"<span class='notice'>You have unbolted the [target]'s [msuit] with \the [tool].</span>")

/decl/surgery_step/suit_cut/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	user.visible_message("<span class='danger'>[user]'s [tool] can't get a good grip on the bolts...</span>", \
	"<span class='danger'>Your [tool] can't get a good grip on the bolts. Try again.</span>")