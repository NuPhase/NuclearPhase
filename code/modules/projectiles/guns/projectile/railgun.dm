/obj/item/gun/projectile/railgun
	name = "PHR 'Slegdehammer'"
	desc = "Prototype Heatshielded Railgun."
	icon = 'icons/obj/guns/railgun.dmi'
	load_method = MAGAZINE
	caliber = "3x20"
	ammo_type = /obj/item/ammo_casing/magneticfletchette
	magazine_type = /obj/item/ammo_magazine/railgunfletchette
	allowed_magazines = /obj/item/ammo_magazine/railgunfletchette
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	accuracy = 15
	accuracy_power = 7
	one_hand_penalty = 6
	fire_delay = 3
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	bulk = GUN_BULK_RIFLE + 3

	var/slowdown_held = 3
	var/slowdown_worn = 2
	firemodes = list(
		list(mode_name="semi auto",      burst=1,    fire_delay=null, use_launcher=null, one_hand_penalty=8,  burst_accuracy=null,            dispersion=null),
		list(mode_name="3-round bursts", burst=3,    fire_delay=1, use_launcher=null, one_hand_penalty=9,  burst_accuracy=null,   		  dispersion=null),
		list(mode_name="full auto",      burst=1,    fire_delay=0,    burst_delay=1,     use_launcher=null,   one_hand_penalty=7,             burst_accuracy =null, dispersion=null, autofire_enabled=1)
	)
	var/use_launcher = 0

/obj/item/gun/magnetic/railgun/Initialize()
	LAZYSET(slowdown_per_slot, BP_L_HAND,        slowdown_held)
	LAZYSET(slowdown_per_slot, BP_R_HAND,        slowdown_held)
	LAZYSET(slowdown_per_slot, slot_back_str,    slowdown_worn)
	LAZYSET(slowdown_per_slot, slot_belt_str,    slowdown_worn)
	LAZYSET(slowdown_per_slot, slot_s_store_str, slowdown_worn)

	. = ..()