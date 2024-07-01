/obj/item/composite_sword
	name = "ultralight composite sword"
	desc = "A huge titanium sword. It's weight can be a considerable disadvantage and it may require considerate skill to wield it. Laser sharpened."
	icon = 'icons/obj/items/weapon/swords/composite.dmi'
	base_parry_chance = 75
	melee_accuracy_bonus = 15
	hitsound = 'sound/weapons/bladeslice.ogg'
	material = /decl/material/solid/metal/titanium
	pickup_sound = 'sound/foley/knife1.ogg'
	drop_sound = 'sound/foley/knifedrop3.ogg'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_HUGE
	sharp = 1
	edge = 1
	max_force = 35
	force = 35
	armor_penetration = 35
	attack_cooldown = 1
	attack_verb = list("slashed", "sliced", "torn", "ripped", "diced", "cut")
	weight = 2.5

/obj/item/composite_sword/can_embed()
	return FALSE

/obj/item/composite_sword/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_SAW = TOOL_QUALITY_MEDIOCRE))
	force = max_force