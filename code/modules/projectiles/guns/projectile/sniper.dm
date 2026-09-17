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
	caliber = CALIBER_ANTI_MATERIEL
	origin_tech = "{'combat':8,'materials':3}"
	ammo_type = /obj/item/ammo_casing/shell
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c127x99
	allowed_magazines = list(
		/obj/item/ammo_magazine/c127x99,
		/obj/item/ammo_magazine/c127x99/ap,
		/obj/item/ammo_magazine/c127x99/tracer,
		/obj/item/ammo_magazine/c127x99/tracer/heavy,
		/obj/item/ammo_magazine/c127x99/tracer/explosive
	)
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
	material = /decl/material/solid/stone/ceramic/hafniumcarbonitride
	hot_color = COLOR_AMBER
	muzzle_flash_intensity = 0
	weight = 14.4

/obj/item/gun/projectile/sniper/ngdmr/update_base_icon()
	if(ammo_magazine)
		if(ammo_magazine.stored_ammo.len)
			icon_state = "[get_world_inventory_state()]-loaded"
		else
			icon_state = "[get_world_inventory_state()]-empty"
	else
		icon_state = get_world_inventory_state()

/obj/item/gun/projectile/bolt_action/sniper
	name = "HI PTR-7"
	desc = "A lightweight bolt-action anti-materiel rifle. Lacks in rate of fire, but is relatively easy to carry."
	icon = 'icons/obj/guns/heavysniper.dmi'
	force = 10
	origin_tech = @'{"combat":7,"materials":2,"esoteric":8}'
	caliber = CALIBER_ANTI_MATERIEL
	screen_shake = 16 //extra kickback
	one_hand_penalty = 7
	accuracy = 6
	bulk = 8
	scoped_accuracy = 16 //increased accuracy over the LWAP because only one shot
	scope_zoom = 2
	fire_delay = 12
	weight = 8.9

/obj/item/gun/projectile/sniper/semiauto
	name = "AMR GEN-1"
	desc = "A semi-automatic sniper rifle. Chambered in 50BMG."
	icon = 'icons/obj/guns/m82.dmi'
	w_class = ITEM_SIZE_HUGE
	force = 10
	caliber = CALIBER_ANTI_MATERIEL
	origin_tech = "{'combat':8,'materials':3}"
	ammo_type = /obj/item/ammo_casing/shell
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c127x99
	allowed_magazines = list(
		/obj/item/ammo_magazine/c127x99,
		/obj/item/ammo_magazine/c127x99/ap,
		/obj/item/ammo_magazine/c127x99/tracer,
		/obj/item/ammo_magazine/c127x99/tracer/heavy,
		/obj/item/ammo_magazine/c127x99/tracer/explosive
	)
	auto_eject = 0
	accuracy = 5
	accuracy_power = 7
	scoped_accuracy = 30
	scope_zoom = 1.5
	one_hand_penalty = 8
	bulk = 8
	fire_delay = 40
	mag_insert_sound = 'sound/weapons/guns/interaction/batrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/batrifle_magout.ogg'
	weight = 14.4

/obj/item/gun/projectile/sniper/semiauto/update_base_icon()
	if(ammo_magazine)
		icon_state = "[get_world_inventory_state()]-loaded"
	else
		icon_state = get_world_inventory_state()