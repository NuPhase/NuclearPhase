/obj/item/plasma_sword
	name = "plasma sword prototype"
	desc = "Sustainable fusion is impossible, right?.." //It should have HEAVY power consumption
	icon = 'icons/obj/items/weapon/plasma_sword.dmi'
	origin_tech = "{'magnets':3,'esoteric':4}"
	base_parry_chance = 75
	melee_accuracy_bonus = 15
	hitsound = 'sound/weapons/bladeslice.ogg'
	material = /decl/material/solid/metal/titanium
	pickup_sound = 'sound/foley/knife1.ogg'
	drop_sound = 'sound/foley/knifedrop3.ogg'
	icon_state = ICON_STATE_WORLD
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD
	w_class = ITEM_SIZE_LARGE
	sharp = 1
	edge = 1
	max_force = 35
	force = 35
	throwforce = 75
	throw_speed = 2
	throw_range = 10
	armor_penetration = 100
	attack_verb = list("slashed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/plasma_sword/handle_shield(mob/user, damage, atom/damage_source, mob/attacker, def_zone, attack_text)
	. = ..()
	if(.)
		spark_at(src, amount = 5, holder = src)

/obj/item/plasma_sword/get_heat()
	return 47000

/obj/item/plasma_sword/get_autopsy_descriptors()
	. = ..()
	. += "so precise it looks impossible"

/obj/item/plasma_sword/can_embed()
	return FALSE

/obj/item/plasma_sword/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_SAW = TOOL_QUALITY_GOOD))
	set_light(2, 0.8, COLOR_PINK)
	force = max_force