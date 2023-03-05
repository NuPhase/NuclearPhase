/obj/item/grenade/incendiary
	name = "incendiary grenade"
	desc = "Used for clearing rooms of living things."
	icon = 'icons/obj/items/grenades/grenade_chem.dmi'
	var/strength = 20
	var/falloff = 5

/obj/item/grenade/incendiary/detonate()
	..()
	new /obj/effect/deflagarate(loc, strength, falloff)
	qdel(src)