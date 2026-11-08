
/obj/item/gun/projectile/pistol
	name = "pistol"
	icon = 'icons/obj/guns/pistol.dmi'
	load_method = MAGAZINE
	caliber = CALIBER_PISTOL
	allowed_magazines = /obj/item/ammo_magazine/pistol
	accuracy_power = 7
	safety_icon = "safety"
	ammo_indicator = TRUE
	bulk = 1

/obj/item/gun/projectile/pistol/update_base_icon()
	var/base_state = get_world_inventory_state()
	if(ammo_magazine)
		if(ammo_magazine.stored_ammo.len)
			icon_state = "[base_state]-loaded"
		else
			icon_state = "[base_state]-empty"
	else
		icon_state = base_state

/obj/item/gun/projectile/pistol/holdout
	name = "holdout pistol"
	desc = "The Lumoco Arms P3 Whisper. A small, easily concealable gun."
	icon = 'icons/obj/guns/holdout_pistol.dmi'
	item_state = null
	ammo_indicator = FALSE
	w_class = ITEM_SIZE_SMALL
	caliber = CALIBER_PISTOL_SMALL
	silenced = 0
	fire_delay = 4
	origin_tech = @'{"combat":2,"materials":2,"esoteric":8}'
	allowed_magazines = /obj/item/ammo_magazine/pistol/small

/obj/item/gun/projectile/pistol/holdout/attack_hand(mob/user)
	if(silenced && user.is_holding_offhand(src))
		to_chat(user, SPAN_NOTICE("You unscrew \the [silenced] from \the [src]."))
		user.put_in_hands(silenced)
		silenced = initial(silenced)
		w_class = initial(w_class)
		update_icon()
		return
	..()

/obj/item/gun/projectile/pistol/holdout/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/silencer))
		if(src in user.get_held_items())	//if we're not in his hands
			to_chat(user, SPAN_WARNING("You'll need [src] in your hands to do that."))
			return TRUE
		if(user.unEquip(I, src))
			to_chat(user, SPAN_NOTICE("You screw [I] onto [src]."))
			silenced = I	//dodgy?
			w_class = ITEM_SIZE_NORMAL
			update_icon()
		return TRUE
	. = ..()

/obj/item/gun/projectile/pistol/holdout/update_base_icon()
	..()
	if(silenced)
		overlays += mutable_appearance(icon, "[get_world_inventory_state()]-silencer")

/obj/item/gun/projectile/pistol/holdout/get_on_belt_overlay()
	if(silenced && check_state_in_icon("on_belt_silenced", icon))
		return overlay_image(icon, "on_belt_silenced", color)
	return ..()

/obj/item/silencer
	name = "silencer"
	desc = "A silencer."
	icon = 'icons/obj/guns/holdout_pistol_silencer.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL

/obj/item/gun/projectile/pistol/military_service
	name = "HAMMER service pistol"
	desc = "A BlasTech HAMMER Gen II. A modular polymer-frame pistol chambered in 10x21mm Auto, widely recognised as the singular most popular firearm on Sirius. Thought to be so robust you can drive nails with it just fine! Probably."
	russian_desc = "БласТэк HAMMER II-го поколения. Модульный пистолет с полимерной рамой под патрон 10x21мм Авто, известный, как самое популярное стрелковое оружие Сириуса. Говорят, что он настолько крепкий, что им можно забивать гвозди! Наверное."
	icon = 'icons/obj/guns/gyropistol.dmi'
	w_class = ITEM_SIZE_NORMAL
	weight = 0.82
//	jam_chance = 1 //find out later if it's supposed to be that
	magazine_type = /obj/item/ammo_magazine/pistol //ffs just use var/starts_loaded
	allowed_magazines = list(/obj/item/ammo_magazine/pistol, /obj/item/ammo_magazine/pistol/rubber, /obj/item/ammo_magazine/pistol/srec) //GOD FORBID
	ammo_indicator = FALSE
	waterproof = TRUE
	fire_delay = 5
	muzzle_flash_intensity = 5

/obj/item/gun/projectile/pistol/military_service/loadout
	magazine_type = /obj/item/ammo_magazine/pistol/oneround

/obj/item/gun/projectile/pistol/military_service/empty
	starts_loaded = 0

/obj/item/gun/projectile/pistol/low_caliber
	name = "Mk. VI V/T pistol"
	desc = "A Polaris Arms Mark 6 Varmint/Target. A simple pistol chambered in 6x15mm Plinker, well-suited for practice shooting as well as hunting rats."
	russian_desc = "Полярис Армс Марк 6 Варминт/Таргет. Простой пистолет под маломощный патрон 6x15мм, рассчитанный на тренировочную стрельбу и отстрел крыс."
	icon = 'icons/obj/guns/simplepistol.dmi'
	w_class = ITEM_SIZE_NORMAL
	caliber = CALIBER_PISTOL_SMALL
	silenced = 1
	weight = 0.85
	magazine_type = /obj/item/ammo_magazine/pistol/small
	allowed_magazines = list(/obj/item/ammo_magazine/pistol/small)
	ammo_indicator = FALSE
	waterproof = TRUE
	fire_delay = 2
	muzzle_flash_intensity = 3

/obj/item/gun/projectile/pistol/low_caliber/loadout
	magazine_type = /obj/item/ammo_magazine/pistol/small

/obj/item/gun/projectile/pistol/low_caliber/empty
	starts_loaded = 0

/obj/item/gun/projectile/pistol/gyro_rocket
	name = "REF-V4"
	desc = "Rocket Expander Firearm."
	icon = 'icons/obj/guns/gyropistol.dmi'
	w_class = ITEM_SIZE_NORMAL
	weight = 1.7
	magazine_type = null
	allowed_magazines = list(/obj/item/ammo_magazine/pistol)
	magazine_type = /obj/item/ammo_magazine/pistol
	ammo_indicator = FALSE
	waterproof = TRUE
	fire_delay = 3
