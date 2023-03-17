/obj/item/clothing/head/helmet/modern/space
	name = "pressure helmet"
	desc = "A heavy and bulky helmet designed to work in a wide variety of temperatures and pressures. Looks quite unwieldy."
	icon = 'icons/clothing/spacesuit/generic/helmet.dmi'
	w_class = ITEM_SIZE_LARGE
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_AIRTIGHT
	permeability_coefficient = 0
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCK_ALL_HAIR
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	cold_protection = SLOT_HEAD
	min_cold_protection_temperature = UNIVERSAL_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0
	max_pressure_protection = RIG_MAX_PRESSURE
	siemens_coefficient = 0.9
	center_of_mass = null
	randpixel = 0
	flash_protection = FLASH_PROTECTION_MAJOR
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	light_wedge = LIGHT_WIDE
	on = 0
	volume_multiplier = 0.5

	var/obj/machinery/camera/camera
	var/tinted = null	//Set to non-null for toggleable tint helmets
	origin_tech = "{'materials':1}"
	material = /decl/material/solid/metal/steel
	weight = 15

/obj/item/clothing/head/helmet/modern/space/Destroy()
	if(camera && !ispath(camera))
		QDEL_NULL(camera)
	. = ..()

/obj/item/clothing/head/helmet/modern/space/Initialize()
	. = ..()
	if(camera)
		verbs += /obj/item/clothing/head/helmet/space/proc/toggle_camera
	if(!isnull(tinted))
		verbs += /obj/item/clothing/head/helmet/space/proc/toggle_tint
		update_tint()

/obj/item/clothing/head/helmet/modern/space/proc/toggle_camera()
	set name = "Toggle Helmet Camera"
	set category = "Object"
	set src in usr

	if(ispath(camera))
		camera = new camera(src)
		camera.set_status(0)

	if(camera)
		camera.set_status(!camera.status)
		if(camera.status)
			camera.c_tag = FindNameFromID(usr)
			to_chat(usr, "<span class='notice'>User scanned as [camera.c_tag]. Camera activated.</span>")
		else
			to_chat(usr, "<span class='notice'>Camera deactivated.</span>")

/obj/item/clothing/head/helmet/modern/space/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && camera)
		to_chat(user, "This helmet has a built-in camera. Its [!ispath(camera) && camera.status ? "" : "in"]active.")

/obj/item/clothing/head/helmet/modern/space/proc/update_tint()
	if(tinted)
		flash_protection = FLASH_PROTECTION_MAJOR
		flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCK_ALL_HAIR
	else
		flash_protection = FLASH_PROTECTION_NONE
		flags_inv = HIDEEARS|BLOCK_HEAD_HAIR
	update_icon()
	update_clothing_icon()

/obj/item/clothing/head/helmet/modern/space/proc/toggle_tint()
	set name = "Toggle Helmet Tint"
	set category = "Object"
	set src in usr

	var/mob/user = usr
	if(istype(user) && user.incapacitated())
		return

	tinted = !tinted
	to_chat(usr, "You toggle [src]'s visor tint.")
	update_tint()

/obj/item/clothing/head/helmet/modern/space/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && tint && check_state_in_icon("[overlay.icon_state]_dark", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]_dark"
	. = ..()

/obj/item/clothing/head/helmet/modern/space/on_update_icon(mob/user)
	. = ..()
	var/base_icon = get_world_inventory_state()
	if(!base_icon)
		base_icon = initial(icon_state)
	if(tint && check_state_in_icon("[base_icon]_dark", icon))
		icon_state = "[base_icon]_dark"
	else
		icon_state = base_icon

///obj/item/clothing/head/helmet/modern/space/mob_can_equip(mob/living/M, slot, disable_warning, force)
//	return FALSE

/obj/item/clothing/suit/modern/space
	name = "pressure suit"
	desc = "A pinnacle of past-laden engineering, this suit is capable of surviving a wide variety of temperatures and pressures. Doesn't look like it, though."
	icon = 'icons/clothing/spacesuit/generic/suit.dmi'
	w_class = ITEM_SIZE_HUGE
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/baton,/obj/item/energy_blade/sword,/obj/item/handcuffs)
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = SLOT_UPPER_BODY | SLOT_LOWER_BODY | SLOT_LEGS | SLOT_FEET | SLOT_ARMS | SLOT_HANDS
	min_cold_protection_temperature = UNIVERSAL_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0
	max_pressure_protection = PRESSURE_SUIT_MAX_PRESSURE
	max_heat_protection_temperature = UNIVERSAL_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	center_of_mass = null
	randpixel = 0
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_OVER)
	origin_tech = "{'materials':3, 'engineering':3}"
	material = /decl/material/solid/plastic
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT
	)
	protects_against_weather = TRUE

	var/list/components = list()
	var/datum/gas_mixture/internal_atmosphere = new
	var/mob/living/carbon/human/wearer = null
	var/obj/item/storage/backpack/lifesupportpack/lifesupportsystem = new

	var/leakiness = 0 //0-100. Determines how much air leaks out in percent per second
	var/leak_message_on_cooldown = FALSE
	var/minimum_leak_damage = 10
	var/windbreak_coefficient = 1 //basically suit aerodynamics and shockwave creation. A coefficient of 0.3 would mean that the suit receives x1.7 of convective heat and x0.3 of the wind
	weight = 100

/obj/item/clothing/suit/modern/space/attackby(obj/item/I, mob/user)
	. = ..()
	if(istype(I, /obj/item/stack/tape_roll/suit_sealing))
		if(!leakiness)
			to_chat(user, SPAN_NOTICE("The suit is intact!"))
			return
		var/obj/item/stack/tape_roll/suit_sealing/tape = I
		var/use_message = ""
		var/use_time = 0
		var/leak_removal = 0
		switch(leakiness)
			if(1 to 5)
				use_time = 100
				use_message = "You take your time to find the last breach on \the [src]..."
				leak_removal = 5
			if(6 to 25)
				use_time = 50
				use_message = "You carefully seal some of the breaches on \the [src]."
				leak_removal = 7
			if(26 to 100)
				use_time = 15
				use_message = "You hastily apply the [tape.name] over flaps of material on \the [src]. It needs more."
				leak_removal = 10
		if(!do_after(user, use_time, user, can_move = TRUE))
			return
		leakiness = max(leakiness - leak_removal, 0)
		to_chat(user, "<span class='notice'>[use_message]</span>")

/obj/item/clothing/suit/modern/space/examine(mob/user)
	. = ..()
	to_chat(user, "The pressure in your suit is [internal_atmosphere.return_pressure()]")
	switch(leakiness)
		if(0)
			to_chat(user, SPAN_NOTICE("[src] is intact."))
		if(0.1 to 25)
			to_chat(user, SPAN_WARNING("[src] has several minor leaks. You probably should patch them up."))
		if(26 to INFINITY)
			to_chat(user, SPAN_DANGER("[src] has several tears and flaps of material all over it!"))

	switch(windbreak_coefficient)
		if(1.1 to 2)
			to_chat(user, SPAN_NOTICE("It looks insanely blunt, like a nose of a reentry vehicle. It will worsen the wind's effect on you and improve your temperature conservation."))
		if(0.71 to 1)
			to_chat(user, SPAN_NOTICE("This piece of high-tech clothing doesn't have anything special about its aerodynamics."))
		if(0.51 to 0.7)
			to_chat(user, SPAN_NOTICE("It has good aerodynamics, which will help you against the wind. Mind the temperature, though."))
		if(0.1 to 0.5)
			to_chat(user, SPAN_NOTICE("This suit is so streamlined that you can cut yourself on it."))

/obj/item/clothing/suit/modern/space/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1)
	internal_atmosphere.volume = 20
	lifesupportsystem.owner = src

///obj/item/clothing/suit/modern/space/mob_can_equip(mob/living/M, slot, disable_warning, force)
//	return FALSE

/obj/item/clothing/suit/modern/space/equipped(mob/user)
	. = ..()
	if(user.get_equipped_item(slot_wear_suit_str) != src)
		return
	wearer = user
	wearer.msuit = src
	var/obj/item/backp = wearer.get_equipped_item(slot_back_str)
	if(backp)
		wearer.drop_from_inventory(backp, get_turf(wearer))
	wearer.equip_to_slot(lifesupportsystem, slot_back_str)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/suit/modern/space/dropped(mob/user)
	. = ..()
	STOP_PROCESSING(SSobj, src)
	wearer?.msuit = null
	wearer = null
	user.drop_from_inventory(lifesupportsystem, src)

/obj/item/clothing/suit/modern/space/Process()
	lifesupportsystem.do_support()
	if(leakiness)
		internal_atmosphere.remove_ratio(leakiness * 0.01)
		if(!leak_message_on_cooldown)
			leak_message_on_cooldown = TRUE
			spawn(50)
				leak_message_on_cooldown = FALSE
			switch(leakiness)
				if(1 to 5)
					to_chat(wearer, "<span class='notice'>[pick("You hear strange hissing from somewhere on your suit. Is it leaking?", "Something hisses on your suit.", "You feel gas flowing around in your suit.")]</span>")
				if(6 to 25)
					to_chat(wearer, "<span class='warning'>[pick("You see gas flowing out of your suit!", "Something is leaking out of your suit!", "There is a lot of gas escaping your suit!")]</span>")
				if(26 to 100)
					to_chat(wearer, "<span class='danger'>[pick("Gas rapidly escapes out of your suit!", "Your suit is losing pressure!", "Your suit is bleeding to death!")]</span>")
