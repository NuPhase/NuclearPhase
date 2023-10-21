/obj/item/auto_cpr
	name = "auto-compressor"
	desc = "A device that gives regular compression to the victim's ribcage, used in case of urgent heart issues."
	icon = 'icons/obj/items/device/auto_cpr.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'magnets':2,'biotech':2}"
	slot_flags = SLOT_OVER_BODY
	var/skilled_setup

/obj/item/auto_cpr/mob_can_equip(mob/living/carbon/human/H, slot, disable_warning = 0, force = 0)
	. = ..()
	if(. && slot == slot_wear_suit_str)
		. = H.get_bodytype_category() == BODYTYPE_HUMANOID

/obj/item/auto_cpr/attack(mob/living/carbon/human/M, mob/living/user, var/target_zone)
	if(istype(M) && user.a_intent == I_HELP)
		var/obj/item/suit = M.get_equipped_item(slot_wear_suit_str)
		if(suit)
			to_chat(user, SPAN_WARNING("Their [suit] is in the way, remove it first!"))
			return 1
		user.visible_message(SPAN_NOTICE("[user] starts fitting [src] onto the [M]'s chest."))

		if(!do_mob(user, M, 2 SECONDS))
			return

		if(user.unEquip(src))
			if(!M.equip_to_slot_if_possible(src, slot_wear_suit_str, del_on_fail=0, disable_warning=1, redraw_mob=1))
				user.put_in_active_hand(src)
			return 1
	else
		return ..()

/obj/item/auto_cpr/equipped(mob/user, slot)
	..()
	START_PROCESSING(SSobj,src)

/obj/item/auto_cpr/attack_hand(mob/user)
	skilled_setup = user.skill_check(SKILL_ANATOMY, SKILL_BASIC) && user.skill_check(SKILL_MEDICAL, SKILL_BASIC)
	..()

/obj/item/auto_cpr/dropped(mob/user)
	STOP_PROCESSING(SSobj,src)
	..()

/obj/item/auto_cpr/Process()
	if(!ishuman(loc))
		return PROCESS_KILL

	var/mob/living/carbon/human/H = loc
	if(H.get_inventory_slot(src) != slot_wear_suit_str)
		return PROCESS_KILL

	playsound(src, 'sound/machines/pump.ogg', 25)
	var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(H, BP_CHEST)
	to_chat_cooldown(H, "<span class='danger'>Your [E] is compressed painfully!</span>", "autocpr", time = 50)
	E.add_pain(5)
	if(!skilled_setup && prob(5))
		E.fracture()
	else
		H.add_mcv = rand(250, 500)