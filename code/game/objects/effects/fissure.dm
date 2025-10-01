/obj/effect/fissure
	name = "fissure"
	desc = "A pressurized opening in the ground. It can probably be closed with something heavy.."
	icon = 'icons/effects/geyser.dmi'
	icon_state = "geyser"
	anchored = TRUE
	layer = TURF_LAYER + 0.01

	var/datum/effect/effect/system/steam_spread/steam

	var/emission_amount = 1200
	var/emission_temperature = T20C
	var/fluid_type

	var/large_item_count = 0

/obj/effect/fissure/attackby(obj/item/I, mob/user)
	. = ..()
	if(I.w_class >= ITEM_SIZE_LARGE)
		user.drop_from_inventory(I, src)
		large_item_count++
		if(large_item_count > 5)
			to_chat(user, "The fissure stops leaking as you stuff even more stuff into it.")
			qdel(src)
		else
			to_chat(user, "You put [I] in the [src]. It isn't enough, you need more.")

/obj/effect/fissure/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/fissure/Process()
	if(emission_temperature > 350)
		fluid_type = /decl/material/liquid/water/dirty1
		release_steam()
	else
		fluid_type = /decl/material/liquid/water/dirty2
	release_water()

/obj/effect/fissure/proc/release_water()
	var/turf/T = get_turf(src)
	if(istype(T))
		T.add_fluid(fluid_type, emission_amount, ntemperature = emission_temperature)

/obj/effect/fissure/proc/release_steam()
	if(!steam)
		steam = new
		steam.set_up(5, 0, src)
	steam.start()