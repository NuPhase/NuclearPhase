/obj/item/chest_tube
	name = "thoracic catheter"
	desc = "A chest tube (also chest drain, thoracic catheter, tube thoracostomy or intercostal drain) is a surgical drain that is inserted through the chest wall and into the pleural space or the mediastinum in order to remove clinically undesired substances such as air."
	icon = 'icons/obj/medical_kits.dmi'
	icon_state = "chest-tube"
	w_class = ITEM_SIZE_SMALL

/obj/item/chest_tube/proc/should_succeed(var/mob/living/carbon/human/installer)
	if(prob(installer.skill_fail_chance(SKILL_ANATOMY, 80, SKILL_EXPERT, 2)))
		return FALSE
	return TRUE

/obj/item/chest_tube/attack(mob/living/carbon/human/M, mob/living/user, target_zone, animate)
	if(!ishuman(M))
		. = ..()
		return

	M.visible_message(SPAN_NOTICE("[user] starts inserting a [src] into [M]'s chest..."))
	if(!do_after(user, 5 SECONDS * user.skill_delay_mult(SKILL_ANATOMY, 0.4), M))
		M.visible_message(SPAN_NOTICE("[user] stops trying to rape [M]'s chest with the [src]."))
		return
	var/obj/item/organ/internal/lungs/lungs = GET_INTERNAL_ORGAN(M, BP_LUNGS)
	if(should_succeed(user))
		if(lungs.chest_tube)
			to_chat(user, SPAN_NOTICE("[M] already has a chest tube in place."))
			return
		lungs.chest_tube = src
		user.drop_from_inventory(src, lungs)
		M.visible_message(SPAN_NOTICE("[user] successfully installs a [src] into [M]'s chest."))
		var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(M, BP_CHEST)
		M.custom_pain("You are stabbed in the ribs!", 40, 0, affecting)
	else
		lungs.ruptured = TRUE
		M.visible_message(SPAN_DANGER("[user] installs a [src] into [M]'s chest. Something pops inside of it!"))
		var/obj/item/organ/external/chest/chest = GET_EXTERNAL_ORGAN(M, BP_CHEST)
		user.drop_from_inventory(src, M.loc)
		chest.embed(src, 0)
		M.custom_pain("You are stabbed in the ribs!", 50, 0, chest)