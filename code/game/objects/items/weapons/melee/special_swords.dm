//Slightly increased cooldown, high accuracy and parry chance
/obj/item/composite_sword
	name = "ultralight composite sword"
	desc = "A huge titanium sword. It's weight can be a considerable disadvantage and it may require considerate skill to wield it. Laser sharpened."
	icon = 'icons/obj/items/weapon/swords/composite.dmi'
	base_parry_chance = 75
	parry_sound = 'sound/weapons/rapidslice.ogg'
	melee_accuracy_bonus = 15
	hitsound = 'sound/weapons/bladeslice.ogg'
	pickup_sound = 'sound/foley/knife1.ogg'
	drop_sound = 'sound/foley/knifedrop3.ogg'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_HUGE
	sharp = 1
	edge = 1
	max_force = 35
	force = 35
	armor_penetration = ARMOR_MELEE_MAJOR
	attack_cooldown = 10
	attack_verb = list("slashed", "sliced", "torn", "ripped", "cut")
	weight = 6
	slot_flags = SLOT_BACK
	material = /decl/material/solid/metal/titanium

// needs polishing in a laser cutter
/obj/item/composite_sword/unpolished
	name = "dull composite sword"
	desc = "A huge titanium sword. It's weight can be a considerable disadvantage and it may require considerate skill to wield it. It is very dull."
	max_force = 15
	force = 15
	armor_penetration = ARMOR_MELEE_SMALL

/obj/item/composite_sword/can_embed()
	return FALSE

/obj/item/composite_sword/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_SAW = TOOL_QUALITY_BAD))
	force = max_force

/obj/item/energy_blade/molten_sword
	name = "powered ninjato"
	desc = "A tungsten-titanium sword that is electrically heated."
	icon = 'icons/obj/items/weapon/e_nsword.dmi'
	w_class = ITEM_SIZE_LARGE
	active_parry_chance = 30
	parry_sound = 'sound/weapons/rapidslice.ogg'
	lighting_color = LIGHT_COLOR_ORANGE
	max_force = 25
	force = 25
	active_force = 40
	armor_penetration = ARMOR_MELEE_KNIVES
	active_armour_pen = ARMOR_MELEE_RESISTANT
	weight = 2.5
	material = /decl/material/solid/metal/tungsten

/obj/item/energy_blade/molten_sword/dropped(var/mob/user)
	..()
	addtimer(CALLBACK(src, PROC_REF(check_loc)), 1) // Swapping hands or passing to another person should not deactivate the sword.

/obj/item/energy_blade/molten_sword/proc/check_loc()
	if(!istype(loc, /mob) && active)
		toggle_active()

/obj/item/energy_blade/molten_sword/attack(mob/living/M, mob/living/user, target_zone, animate)
	. = ..()
	if(active && isliving(M))
		var/mob/living/H = M
		H.adjust_fire_stacks(1)
		H.IgniteMob()
		H.bodytemperature += 20