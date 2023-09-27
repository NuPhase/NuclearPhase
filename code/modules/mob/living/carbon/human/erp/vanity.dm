/obj/effect/decal/cleanable/cum
	name = "cream"
	desc = "It's pie cream from a cream pie. Or not..."
	density = 0
	layer = 2
	icon = 'honk/icons/effects/cum.dmi'
	anchored = 1
	random_icon_states = list("cum1", "cum2", "cum3", "cum4", "cum5", "cum6", "cum7", "cum8", "cum9", "cum10", "cum11", "cum12")

/obj/effect/decal/cleanable/cum/attack_hand(mob/living/carbon/human/user)
	. = ..()
	visible_message(SPAN_CUMZONE("[user] licks [src] from the floor."))
	user.nutrition += 5
	qdel(src)

/obj/effect/decal/cleanable/cum/New()
	..()
	icon_state = pick(random_icon_states)

/obj/effect/decal/cleanable/cum/fem
	name = "slippery liquid"
	desc = "Uhh... Someone had fun..."
	icon = 'honk/icons/effects/lewd_decals.dmi'
	random_icon_states = list("femcum_1", "femcum_2", "femcum_3", "femcum_4")

/decl/material/liquid/semen
	solid_name = "semen"
	gas_name = "semen"
	liquid_name = "semen"
	uid = "liquid_semen"
	exoplanet_rarity = MAT_RARITY_NOWHERE
	ingest_met = 1
	taste_description = "salty slime"
	color = "#FFFFFF" // rgb: 255, 255, 255

/decl/material/liquid/semen/affect_ingest(mob/living/carbon/M, removed, datum/reagents/holder)
	. = ..()
	M.nutrition += removed * 1.5 //rich in protein
	M.hydration -= removed * 0.1