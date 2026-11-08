/obj/item/gun/projectile/automatic/smg
	name = "Viper 7 SMG"
	desc = "A BlasTech Viper 7. A full-size submachine gun chambered in 10x21mm Auto and a premier choice for up-arming law enforcement officers. Well-balanced and reliable - the staple of rebel cops."
	icon = 'icons/obj/guns/viper_smg.dmi'
	icon_state = ICON_STATE_WORLD
	safety_icon = "safety"
	w_class = ITEM_SIZE_NORMAL
	caliber = CALIBER_PISTOL
	origin_tech = @'{"combat":5,"materials":2}'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	ammo_type = /obj/item/ammo_casing/pistol
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/smg/medium_pistol
	allowed_magazines = /obj/item/ammo_magazine/smg/medium_pistol
	accuracy_power = 7
	one_hand_penalty = 2
	bulk = 1.5
	fire_sound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)

	fire_delay = 2
	firemodes = list(
		list(mode_name="semi auto",      burst=1, fire_delay=1.5, one_hand_penalty=2, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=1.5, one_hand_penalty=3,       dispersion=list(0.0, 0.3, 0.6, 0.8)),
		list(mode_name="full auto",      burst=1, fire_delay=0,    burst_delay=0,      one_hand_penalty=4, autofire_enabled=1)
	)
	weight = 2.89
	muzzle_flash_intensity = 4

/obj/item/gun/projectile/automatic/smg/update_base_icon()
	if(ammo_magazine)
		if(ammo_magazine.stored_ammo.len)
			icon_state = "[get_world_inventory_state()]-loaded"
		else
			icon_state = "[get_world_inventory_state()]-empty"
	else
		icon_state = get_world_inventory_state()

/obj/item/gun/projectile/automatic/smg/empty
	starts_loaded = 0

/obj/item/gun/projectile/automatic/smg/robot
	magazine_type = /obj/item/ammo_magazine/smg/light_pistol/robot

/obj/item/gun/projectile/automatic/smg/piercer
	name = "Borschevik SMG"
	desc = "A ShakTac Borschevik. A compact, versatile submachine gun chambered in 9x20mm, excellent for any close quarters engagements, as well as occasional infantry use."
	icon = 'icons/obj/guns/mp16.dmi'
	icon_state = ICON_STATE_WORLD
	safety_icon = "safety"
	w_class = ITEM_SIZE_NORMAL
	caliber = CALIBER_PISTOL_SMG
	origin_tech = @'{"combat":5,"materials":2}'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	ammo_type = /obj/item/ammo_casing/light_pistol
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/smg/light_pistol
	allowed_magazines = list(/obj/item/ammo_magazine/smg/light_pistol)
	accuracy_power = 7
	one_hand_penalty = 2
	bulk = 1.5
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
		list(mode_name="full auto",      burst=1, fire_delay=0,    burst_delay=0,      one_hand_penalty=4, autofire_enabled=1)
	)
	weight = 2.76
	muzzle_flash_intensity = 4

/obj/item/gun/projectile/automatic/smg/piercer/empty
	starts_loaded = 0

/obj/item/gun/projectile/automatic/assault_rifle
	name = "M8 automatic carbine"
	desc = "An Arisaka Arms M8. A fully automatic infantry carbine chambered in 6.5x35mm SSA caseless and the first new design to ever pass Sirius Standard Arms regulations. Widespread, widely used and plentiful in surplus stocks."
	russian_desc = "Арисака Армс М8. Полностью автоматический пехотный карабин под безгильзовый патрон 6.5x35мм SSA и первая модель производства Сириуса, прошедшая требования госкоммиссии. Встречается повсеместно."
	icon = 'icons/obj/guns/automatic_rifle.dmi'
	w_class = ITEM_SIZE_HUGE
	force = 10
	caliber = CALIBER_RIFLE
	origin_tech = @'{"combat":7,"materials":3}'
	ammo_type = /obj/item/ammo_casing/medium_rifle
	handle_casings = CLEAR_CASINGS //CASELESS: does not leave brass on the floor
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/medium_rifle
	allowed_magazines = list(/obj/item/ammo_magazine/medium_rifle/ap, /obj/item/ammo_magazine/medium_rifle, /obj/item/ammo_magazine/medium_rifle/hp)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	accuracy = 2
	accuracy_power = 7
	one_hand_penalty = 4
	bulk = 3
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
	weight = 3.41
	muzzle_flash_intensity = 5

/obj/item/gun/projectile/automatic/assault_rifle/update_base_icon()
	if(ammo_magazine)
		if(ammo_magazine.stored_ammo.len)
			icon_state = "[get_world_inventory_state()]-loaded"
		else
			icon_state = "[get_world_inventory_state()]-empty"
	else
		icon_state = get_world_inventory_state()

/obj/item/gun/projectile/automatic/assault_rifle/empty
	starts_loaded = 0

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
	allowed_magazines = list(/obj/item/ammo_magazine/snapdragon)
	accuracy = 2
	accuracy_power = 7
	one_hand_penalty = 4
	bulk = 3
	fire_delay = 2
	burst_delay = 2
	mag_insert_sound = 'sound/weapons/guns/interaction/batrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/batrifle_magout.ogg'
	material = /decl/material/solid/metal/steel
	firemodes = list(
		list(mode_name="semi auto",      burst=1,    fire_delay=2, one_hand_penalty=4,  burst_accuracy=null,            dispersion=null),
		list(mode_name="short bursts",   burst=5, fire_delay=2, one_hand_penalty=3, dispersion=null),
		list(mode_name="full auto",      burst=1,    fire_delay=0.8,    burst_delay=-2,     one_hand_penalty=5,             autofire_enabled=1)
	)
	weight = 3.6
	muzzle_flash_intensity = 8

/obj/item/gun/projectile/automatic/snapdragon/robot
	magazine_type = /obj/item/ammo_magazine/snapdragon/robot

/obj/item/gun/projectile/automatic/snapdragon/update_base_icon()
	if(ammo_magazine)
		icon_state = "[get_world_inventory_state()]-loaded"
	else
		icon_state = "[get_world_inventory_state()]-empty"


// infri custom
/obj/item/gun/projectile/automatic/shock_smg
	name = "handcrafted shock SMG"
	desc = "A well-crafted SMG. It looks like a heavily modified TEC-9."
	icon = 'icons/obj/guns/shock_smg.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	caliber = CALIBER_PISTOL_SMALL
	slot_flags = SLOT_LOWER_BODY
	ammo_type = /obj/item/ammo_casing/pistol/small
	load_method = MAGAZINE
	allowed_magazines = list(/obj/item/ammo_magazine/pistol/small, /obj/item/ammo_magazine/pistol/small/shock)
	accuracy_power = 7
	one_hand_penalty = 2
	bulk = 1.5
	fire_sound = 'sound/weapons/gunshot/gunshot.ogg'
	material = /decl/material/solid/metal/steel

	fire_delay = 2
	firemodes = list(
		list(mode_name="semi auto",      burst=1, fire_delay=1.5, one_hand_penalty=2, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=1.5, one_hand_penalty=3,       dispersion=list(0.0, 1.6, 2.4, 2.4)),
		list(mode_name="short bursts",   burst=5, fire_delay=1.5, one_hand_penalty=3, dispersion=list(1.6, 1.6, 2.0, 2.0, 2.4)),
		list(mode_name="full auto",      burst=1, fire_delay=0,    burst_delay=0,      one_hand_penalty=4, autofire_enabled=1)
	)
	weight = 1.2
	muzzle_flash_intensity = 4