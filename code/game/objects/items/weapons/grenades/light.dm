/obj/item/grenade/light
	name = "illumination grenade"
	desc = "A grenade designed to illuminate an area without the use of a flame or electronics, regardless of the atmosphere."
	icon = 'icons/obj/items/grenades/grenade_light.dmi'

/obj/item/grenade/light/detonate()
	..()
	var/lifetime = rand(2 MINUTES, 4 MINUTES)
	playsound(src, 'sound/effects/snap.ogg', 80, 1)
	audible_message("<span class='warning'>\The [src] ignites with a sharp crack!</span>")
	set_light(12, 2.5, "#e3ebff")
	QDEL_IN(src, lifetime)