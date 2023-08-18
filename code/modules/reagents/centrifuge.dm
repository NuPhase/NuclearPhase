/obj/machinery/centrifuge
	name = "centrifuge"
	desc = "Separates various chemicals from a mix. Can also separate blood."
	icon = 'icons/obj/machines/centrifuge.dmi'
	icon_state = "closed"
	active_power_usage = 1400
	core_skill = SKILL_CHEMISTRY
	var/list/inserted_vials = list()
	var/open = FALSE
	var/running = FALSE

/obj/machinery/centrifuge/on_update_icon()
	if(running)
		icon_state = "running"
		return
	if(open)
		icon_state = "open"
		return
	else
		icon_state = "closed"

/obj/machinery/centrifuge/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/chems/glass/beaker/vial))
		if(!open)
			return
		if(length(inserted_vials) > 7)
			to_chat(user, SPAN_NOTICE("There are already 8 vials in the centrifuge."))
			return
		inserted_vials += I
		user.drop_from_inventory(I, src)
		visible_message(SPAN_NOTICE("[user] adds a vial to the centrifuge."))
		return
	. = ..()

/obj/machinery/centrifuge/proc/start()
	running = TRUE
	spawn(15 SECONDS)
		visible_message(SPAN_NOTICE("The centrifuge finishes running."))
		running = FALSE
		for(var/obj/item/chems/glass/beaker/vial/cur_vial in inserted_vials)
			if(cur_vial.reagents.has_reagent(/decl/material/liquid/blood))
				var/transfer_data = cur_vial.reagents.reagent_data[/decl/material/liquid/blood]
				var/transfer_volume = REAGENT_VOLUME(cur_vial.reagents, /decl/material/liquid/blood)
				cur_vial.reagents.remove_any(cur_vial.reagents.maximum_volume)
				cur_vial.reagents.add_reagent(/decl/material/liquid/separated_blood, transfer_volume, transfer_data)

/obj/machinery/centrifuge/physical_attack_hand(user)
	. = ..()
	try_handle_interactions(user, get_alt_interactions(user))

/obj/machinery/centrifuge/get_alt_interactions(mob/user)
	. = ..()
	if(open)
		LAZYADD(., /decl/interaction_handler/centrifuge_close)
		LAZYADD(., /decl/interaction_handler/centrifuge_remove_vial)
	else if(!running)
		LAZYADD(., /decl/interaction_handler/centrifuge_open)
		LAZYADD(., /decl/interaction_handler/centrifuge_start)


/decl/interaction_handler/centrifuge_close
	name = "Close Lid"
	expected_target_type = /obj/machinery/centrifuge

/decl/interaction_handler/centrifuge_close/invoked(obj/machinery/centrifuge/target, mob/user)
	if(!do_after(user, 15, target))
		return
	target.visible_message(SPAN_NOTICE("[user] closes the centrifuge."))
	target.open = FALSE
	target.update_icon()

/decl/interaction_handler/centrifuge_open
	name = "Open Lid"
	expected_target_type = /obj/machinery/centrifuge

/decl/interaction_handler/centrifuge_open/invoked(obj/machinery/centrifuge/target, mob/user)
	if(!do_after(user, 10, target))
		return
	target.visible_message(SPAN_NOTICE("[user] opens the centrifuge."))
	target.open = TRUE
	target.update_icon()

/decl/interaction_handler/centrifuge_start
	name = "Start"
	expected_target_type = /obj/machinery/centrifuge

/decl/interaction_handler/centrifuge_start/invoked(obj/machinery/centrifuge/target, mob/user)
	if(!do_after(user, 5, target))
		return
	if(!target.powered(EQUIP))
		return
	target.start()
	target.visible_message(SPAN_NOTICE("[user] turns on the centrifuge."))

/decl/interaction_handler/centrifuge_remove_vial
	name = "Remove a Vial"
	expected_target_type = /obj/machinery/centrifuge

/decl/interaction_handler/centrifuge_remove_vial/invoked(obj/machinery/centrifuge/target, mob/user)
	if(!length(target.inserted_vials))
		to_chat(user, SPAN_NOTICE("There are no vials in the centrifuge."))
		return
	var/obj/item/chems/glass/beaker/vial/cur_vial = pick(target.inserted_vials)
	user.put_in_hands(cur_vial)
	target.inserted_vials -= cur_vial
	target.visible_message(SPAN_NOTICE("[user] removes a vial from the centrifuge."))