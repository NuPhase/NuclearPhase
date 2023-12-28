/obj/item/grenade/incendiary
	name = "incendiary grenade"
	desc = "Used for clearing rooms of living things."
	icon = 'icons/obj/items/grenades/grenade_chem.dmi'
	var/strength = 200
	var/falloff = 5

/obj/item/grenade/incendiary/detonate()
	..()
	deflagration(loc, strength, falloff, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, spread_fluid = /decl/material/solid/phosphorus)
	var/datum/effect/effect/system/smoke_spread/bad/smoke = new
	smoke.attach(get_turf(src))
	smoke.set_up(10, 0, get_turf(src))
	qdel(src)