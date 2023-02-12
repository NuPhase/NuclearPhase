/obj/item/gun/projectile/sniper/ngdmr
	name = "NG-HDMR"
	desc = "Next-Gen Heatshielded Designated Marksman Rifle is a long-distance weapon made specifically for use in harsh atmospheric conditions. It is coated in special temperature-resistant alloys\
			and equipped with an active cooling system powered by an RTG. The embedded, tungsten-lined text clearly reads: 'RATED FOR TEMPERATURES RANGING FROM 11K TO 932K'. You can probably push it\
			 even more, though."
	russian_desc = "Next-Gen Heatshielded Designated Marksman Rifle - это оружие дальнего боя, созданное специально для использования в суровых атмосферных условиях. Оно покрыто специальными\
			 термостойкими сплавами и оснащено активной системой охлаждения, работающей от РИТЭГ. На боковой стороне винтовки нанесен текст с вольфрамовым напылением, который четко гласит:\
			  'РАССЧИТАНА НА ТЕМПЕРАТУРУ ОТ 11 ДО 932 КВ.' Вероятно, она может выдержать ещё больше."
	icon = 'icons/obj/guns/sniper.dmi'
	w_class = ITEM_SIZE_HUGE
	force = 10
	caliber = "10x77"
	origin_tech = "{'combat':8,'materials':3}"
	ammo_type = /obj/item/ammo_casing/c10x77
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c10x77
	allowed_magazines = /obj/item/ammo_magazine/c10x77
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	accuracy = 15
	accuracy_power = 7
	scoped_accuracy = 30
	scope_zoom = 1.5
	one_hand_penalty = 8
	bulk = 8
	fire_delay = 40
	mag_insert_sound = 'sound/weapons/guns/interaction/batrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/batrifle_magout.ogg'
	material = /decl/material/solid/metal/tantalumhafniumcarbide
	hot_color = COLOR_AMBER

/obj/item/gun/projectile/sniper/ngdmr/update_base_icon()
	if(ammo_magazine)
		if(ammo_magazine.stored_ammo.len)
			icon_state = "[get_world_inventory_state()]-loaded"
		else
			icon_state = "[get_world_inventory_state()]-empty"
	else
		icon_state = get_world_inventory_state()

/obj/item/gun/projectile/sniper/ngdmr/Fire(atom/target, mob/living/user, clickparams, pointblank, reflex, set_click_cooldown)
	. = ..()
	var/turf/T = get_turf(src)
	for(var/mob/living/carbon/human/M in view(7, user))
		var/eye_safety = 0
		var/ear_safety = 0
		if(istype(M))
			eye_safety = M.eyecheck()
			if(M.get_sound_volume_multiplier() < 0.5)
				ear_safety += 2
			if(istype(M.get_equipped_item(slot_head_str), /obj/item/clothing/head/helmet))
				ear_safety += 1
		M.flash_eyes(FLASH_PROTECTION_MODERATE)
		if(eye_safety < FLASH_PROTECTION_MODERATE)
			SET_STATUS_MAX(M, STAT_STUN, 2)
			SET_STATUS_MAX(M, STAT_CONFUSE, 5)

		//Now applying sound
		if(ear_safety)
			if(ear_safety < 2 && get_dist(M, T) <= 2)
				SET_STATUS_MAX(M, STAT_STUN, 1)
				SET_STATUS_MAX(M, STAT_CONFUSE, 3)

		else if(get_dist(M, T) <= 2)
			SET_STATUS_MAX(M, STAT_STUN, 3)
			SET_STATUS_MAX(M, STAT_CONFUSE, 8)
			SET_STATUS_MAX(M, STAT_TINNITUS, rand(0, 5))
			SET_STATUS_MAX(M, STAT_DEAF, 15)

		else if(get_dist(M, T) <= 5)
			SET_STATUS_MAX(M, STAT_STUN, 2)
			SET_STATUS_MAX(M, STAT_CONFUSE, 5)
			SET_STATUS_MAX(M, STAT_TINNITUS, rand(0, 3))
			SET_STATUS_MAX(M, STAT_DEAF, 10)

		else
			SET_STATUS_MAX(M, STAT_STUN, 1)
			SET_STATUS_MAX(M, STAT_CONFUSE, 3)
			SET_STATUS_MAX(M, STAT_TINNITUS, rand(0, 1))
			SET_STATUS_MAX(M, STAT_DEAF, 5)

		switch(GET_STATUS(M, STAT_TINNITUS))
			if(1 to 14)
				to_chat(M, "<span class='danger'>Your ears start to ring!</span>")
			if(15 to INFINITY)
				to_chat(M, "<span class='danger'>Your ears start to ring badly!</span>")

		if(!ear_safety)
			sound_to(M, 'sound/weapons/flash_ring.ogg')