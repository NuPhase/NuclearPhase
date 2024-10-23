/obj/item/gun/projectile/automatic/smg
	name = "MX-16"
	desc = "The MX-16 is a modern lightweight SMG."
	icon = 'icons/obj/guns/mp16.dmi'
	icon_state = ICON_STATE_WORLD
	safety_icon = "safety"
	w_class = ITEM_SIZE_NORMAL
	caliber = "11x25"
	origin_tech = @'{"combat":5,"materials":2}'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	ammo_type = /obj/item/ammo_casing/caseless/c11x25
	load_method = MAGAZINE
	magazine_type = null
	allowed_magazines = /obj/item/ammo_magazine/smg/c11x25
	accuracy_power = 7
	one_hand_penalty = 2
	bulk = -1
	fire_sound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)

	fire_delay = 2
	firemodes = list(
		list(mode_name="semi auto",      burst=1, fire_delay=1.5, one_hand_penalty=2, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=1.5, one_hand_penalty=3,       dispersion=list(0.0, 1.6, 2.4, 2.4)),
		list(mode_name="short bursts",   burst=5, fire_delay=1.5, one_hand_penalty=3, dispersion=list(1.6, 1.6, 2.0, 2.0, 2.4)),
		list(mode_name="full auto",      burst=1, fire_delay=0,    burst_delay=0,      one_hand_penalty=4, autofire_enabled=1)
	)
	weight = 1.4
	muzzle_flash_intensity = 4

/obj/item/gun/projectile/automatic/assault_rifle
	name = "assault rifle"
	desc = "A standard issue assault rifle."
	icon = 'icons/obj/guns/automatic_rifle.dmi'
	w_class = ITEM_SIZE_HUGE
	force = 10
	caliber = CALIBER_RIFLE
	origin_tech = @'{"combat":7,"materials":3}'
	ammo_type = /obj/item/ammo_casing/c6p8x51/fmj
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c6p8x51/fmj
	allowed_magazines = list(/obj/item/ammo_magazine/c6p8x51/ap, /obj/item/ammo_magazine/c6p8x51/fmj, /obj/item/ammo_magazine/c6p8x51/hp)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	accuracy = 2
	accuracy_power = 7
	one_hand_penalty = 4
	bulk = GUN_BULK_RIFLE
	fire_delay = 2
	burst_delay = 1
	mag_insert_sound = 'sound/weapons/guns/interaction/batrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/batrifle_magout.ogg'
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
	firemodes = list(
		list(mode_name="semi auto",      burst=1,    fire_delay=null, one_hand_penalty=4,  burst_accuracy=null,            dispersion=null),
		list(mode_name="full auto",      burst=1,    fire_delay=0.6,    burst_delay=-2,     one_hand_penalty=5,             autofire_enabled=1)
	)
	weight = 4.09
	muzzle_flash_intensity = 5

/obj/item/gun/projectile/automatic/assault_rifle/update_base_icon()
	if(ammo_magazine)
		if(ammo_magazine.stored_ammo.len)
			icon_state = "[get_world_inventory_state()]-loaded"
		else
			icon_state = "[get_world_inventory_state()]-empty"
	else
		icon_state = get_world_inventory_state()

/obj/item/gun/projectile/automatic/snapdragon
	name = "snapdragon rifle"
	desc = "An unique, non-lethal takedown rifle. It fires flamamble gel projectiles at high speeds that stick to surfaces and can easily take down lightly-armored targets."
	icon = 'icons/obj/guns/snapdragon_rifle.dmi'
	pixel_x = -10
	w_class = ITEM_SIZE_HUGE
	force = 10
	caliber = CALIBER_RIFLE_SNAPDRAGON
	ammo_type = /obj/item/ammo_casing/caseless/snapdragon
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/snapdragon
	allowed_magazines = list(/obj/item/ammo_magazine/snapdragon)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	accuracy = 2
	accuracy_power = 7
	one_hand_penalty = 4
	bulk = GUN_BULK_RIFLE
	fire_delay = 2
	burst_delay = 2
	mag_insert_sound = 'sound/weapons/guns/interaction/batrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/batrifle_magout.ogg'
	material = /decl/material/solid/metal/steel
	firemodes = list(
		list(mode_name="semi auto",      burst=1,    fire_delay=2, one_hand_penalty=4,  burst_accuracy=null,            dispersion=null),
		list(mode_name="full auto",      burst=1,    fire_delay=0.8,    burst_delay=-2,     one_hand_penalty=5,             autofire_enabled=1)
	)
	weight = 3.6
	muzzle_flash_intensity = 8

/obj/item/gun/projectile/automatic/snapdragon/update_base_icon()
	if(ammo_magazine)
		icon_state = "[get_world_inventory_state()]-loaded"
	else
		icon_state = "[get_world_inventory_state()]-empty"
