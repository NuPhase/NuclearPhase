/obj/machinery/modernsuit_storage

	name = "exosuit storage"
	desc = "A special module for fitting on suits."
	anchored = 1
	density = 1

	icon = 'icons/obj/storage/suitstorage.dmi'
	icon_state = "base"

	initial_access = list(list(access_captain, access_bridge))

	var/active = 0          // PLEASE HOLD.
	var/decontaminating = 0     // If this is > 0, the storage is decontaminating whatever is inside it.
	var/model_text = ""     // Some flavour text for the topic box.
	var/locked = 0          // If locked, nothing can be taken from or added to the storage.
	var/electrified = 0     // If set, will shock users.

	var/mob/living/carbon/human/occupant
	var/obj/item/clothing/suit/modern/space/suit
	var/obj/item/clothing/head/helmet/modern/space/helmet

	stat_immune = 0
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	base_type = /obj/machinery/modernsuit_storage

/obj/machinery/modernsuit_storage/physical_attack_hand(mob/user)
	if(suit)
		suit.lifesupportsystem.open(user)
	return TRUE

/obj/machinery/modernsuit_storage/on_update_icon()

	var/new_overlays

	if(suit)
		LAZYADD(new_overlays, suit.get_mob_overlay(null, slot_wear_suit_str))
	if(helmet)
		LAZYADD(new_overlays, helmet.get_mob_overlay(null, slot_head_str))
	if(occupant)
		LAZYADD(new_overlays, image(occupant))
	LAZYADD(new_overlays, image(icon, "overbase", layer = ABOVE_HUMAN_LAYER))

	if(locked || active)
		LAZYADD(new_overlays, image(icon, "closed", layer = ABOVE_HUMAN_LAYER))
	else
		LAZYADD(new_overlays, image(icon, "open", layer = ABOVE_HUMAN_LAYER))

	if(decontaminating)
		LAZYADD(new_overlays, image(icon, "light_radiation", layer = ABOVE_HUMAN_LAYER))
		set_light(3, 0.8, COLOR_RED_LIGHT)
	else if(active)
		LAZYADD(new_overlays, image(icon, "light_active", layer = ABOVE_HUMAN_LAYER))
		set_light(3, 0.8, COLOR_YELLOW)
	else
		set_light(0)

	if(panel_open)
		LAZYADD(new_overlays, image(icon, "panel", layer = ABOVE_HUMAN_LAYER))

	overlays = new_overlays

/obj/machinery/modernsuit_storage/receive_mouse_drop(var/atom/dropping, var/mob/user)
	. = ..()

	if(istype(dropping, /obj/item/clothing/suit/modern/space) && !suit)
		user.drop_from_inventory(dropping, src)
		suit = dropping
		update_icon()
		return TRUE
	if(istype(dropping, /obj/item/clothing/head/helmet/modern/space) && !helmet)
		user.drop_from_inventory(dropping, src)
		helmet = dropping
		update_icon()
		return TRUE

	if(!. && ismob(dropping) && try_move_inside(dropping, user))
		return TRUE

/obj/machinery/modernsuit_storage/proc/try_move_inside(var/mob/living/target, var/mob/living/user)
	if(!istype(target) || !istype(user) || !target.Adjacent(user) || !user.Adjacent(src) || user.incapacitated())
		return FALSE

	if(locked)
		to_chat(user, SPAN_WARNING("The [src] is locked."))
		return FALSE

	visible_message(SPAN_WARNING("\The [user] starts putting \the [target] into \the [src]."))
	if(do_after(user, 20, src))
		if(!istype(target) || locked || !target.Adjacent(user) || !user.Adjacent(src) || user.incapacitated())
			return FALSE
		target.reset_view(src)
		target.forceMove(src)
		occupant = target
		add_fingerprint(user)
		update_icon()
		return TRUE
	return FALSE

/obj/machinery/modernsuit_storage/attackby(obj/item/I, mob/user)

	if(electrified != 0)
		if(shock(user, 100))
			return

	//Other interface stuff.
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I

		if(!(ismob(G.affecting)))
			return

		if(try_move_inside(G.affecting, user))
			qdel(G)
			updateUsrDialog()
			return

	return ..()

/obj/machinery/modernsuit_storage/physical_attack_hand(mob/user)
	if(electrified != 0)
		if(shock(user, 100))
			return TRUE

/obj/machinery/modernsuit_storage/verb/leave()
	set name = "Eject Cycler"
	set category = "Object"
	set src in oview(1)
	if (usr.incapacitated())
		return
	eject_occupant(usr)

/obj/machinery/modernsuit_storage/verb/put_on()
	set name = "Start Dressup"
	set category = "Object"
	set src in oview(1)
	if (usr.incapacitated())
		return
	if(active)
		return
	if(!suit || !helmet)
		return
	var/mob/living/carbon/human/H = occupant
	if(H.get_equipped_item(slot_wear_suit_str))
		to_chat(H, SPAN_WARNING("You already have a suit on."))
		return
	if(H.get_equipped_item(slot_head_str))
		to_chat(H, SPAN_WARNING("You already something on your head."))
		return
	use_power_oneoff(10000)
	if(emagged)
		visible_message(SPAN_DANGER("[src] hums as it starts to carefully crush [H] into a neat cube."))
		spawn(5 SECONDS)
			playsound(loc, 'sound/effects/splat.ogg', 50, 1)
			H.dropInto(loc)
			H.reset_view()
			H = null
			H.gib()
		return
	active = TRUE
	visible_message(SPAN_NOTICE("[src] hums as it starts to dress [H] up."))
	spawn(5 SECONDS)
		H.equip_to_slot_if_possible(suit, slot_wear_suit_str, 0, 0, 1)
		H.equip_to_slot_if_possible(helmet, slot_head_str, 0, 0, 1)
		suit.canremove = FALSE
		helmet.canremove = FALSE
		suit = null
		helmet = null
		H.update_inv_wear_suit()
		active = FALSE
		visible_message(SPAN_NOTICE("[src] powers down, ejecting its cooling gas from its top."))
		update_icon()

/obj/machinery/modernsuit_storage/verb/take_off()
	set name = "Take Suit Off"
	set category = "Object"
	set src in oview(1)
	if (usr.incapacitated())
		return
	if(active)
		return
	if(suit || helmet)
		return
	var/mob/living/carbon/human/H = occupant
	if(!H.get_equipped_item(slot_wear_suit_str))
		to_chat(H, SPAN_WARNING("You don't have a suit on."))
		return
	if(!H.get_equipped_item(slot_head_str))
		to_chat(H, SPAN_WARNING("You don't have a helmet on."))
		return
	use_power_oneoff(10000)
	if(emagged)
		visible_message(SPAN_DANGER("[src] hums as it starts to carefully crush [H] into a neat cube."))
		spawn(5 SECONDS)
			playsound(loc, 'sound/effects/splat.ogg', 50, 1)
			H.dropInto(loc)
			H.reset_view()
			H.gib()
			occupant = null
			update_icon()
		return
	active = TRUE
	visible_message(SPAN_NOTICE("[src] hums as it starts to undress [H]."))
	spawn(5 SECONDS)
		var/obj/item/nsuit = H.get_equipped_item(slot_wear_suit_str)
		var/obj/item/nhelmet = H.get_equipped_item(slot_head_str)
		suit = nsuit
		helmet = nhelmet
		suit.canremove = TRUE
		helmet.canremove = TRUE
		H.drop_from_inventory(nsuit)
		H.drop_from_inventory(nhelmet)
		nsuit.forceMove(src)
		nhelmet.forceMove(src)
		update_icon()
		H.update_inv_wear_suit()
		active = FALSE
		visible_message(SPAN_NOTICE("[src] powers down, ejecting its cooling gas from its top."))

/obj/machinery/modernsuit_storage/proc/eject_occupant(mob/user)

	if(locked || active)
		to_chat(user, SPAN_WARNING("The storage unit is locked."))
		return

	if (!occupant)
		return

	occupant.dropInto(loc)
	occupant.reset_view()
	occupant = null

	update_icon()
	add_fingerprint(user)
	updateUsrDialog()

	return

/obj/machinery/modernsuit_storage/research_cold/Initialize()
	. = ..()
	suit = new /obj/item/clothing/suit/modern/space/research/cold
	helmet = new /obj/item/clothing/head/helmet/modern/space/research/cold

/obj/machinery/modernsuit_storage/research_hot/Initialize()
	. = ..()
	suit = new /obj/item/clothing/suit/modern/space/research/hot
	helmet = new /obj/item/clothing/head/helmet/modern/space/research/hot

/obj/machinery/modernsuit_storage/medical/Initialize()
	. = ..()
	suit = new /obj/item/clothing/suit/modern/space/medical
	helmet = new /obj/item/clothing/head/helmet/modern/space/medical

/obj/machinery/modernsuit_storage/security_cold/Initialize()
	. = ..()
	suit = new /obj/item/clothing/suit/modern/space/combat_specialized/cold
	helmet = new /obj/item/clothing/head/helmet/modern/space/combat_specialized/cold

/obj/machinery/modernsuit_storage/engineering/Initialize()
	. = ..()
	suit = new /obj/item/clothing/suit/modern/space/engineering
	helmet = new /obj/item/clothing/head/helmet/modern/space/engineering