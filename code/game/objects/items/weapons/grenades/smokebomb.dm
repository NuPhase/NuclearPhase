/obj/item/grenade/smokebomb
	desc = "It is set to detonate in 2 seconds."
	name = "WMA smoke grenade"
	icon = 'icons/obj/items/grenades/flashbang.dmi'
	det_time = 25
	slot_flags = SLOT_LOWER_BODY
	var/datum/effect/effect/system/smoke_spread/bad/smoke
	var/smoke_times = 4

/obj/item/grenade/smokebomb/Destroy()
	QDEL_NULL(smoke)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/grenade/smokebomb/detonate()
	playsound(src.loc, 'sound/effects/tank_rupture.wav', 50, 1, -3)
	smoke = new /datum/effect/effect/system/smoke_spread/bad
	smoke.attach(src)
	smoke.set_up(10, 0, get_turf(src))
	START_PROCESSING(SSobj, src)
	for(var/obj/effect/blob/B in view(8,src))
		var/damage = round(30/(get_dist(B,src)+1))
		B.health -= damage
		B.update_icon()
	QDEL_IN(src, 8 SECONDS)

/obj/item/grenade/smokebomb/Process()
	if(!QDELETED(smoke) && (smoke_times > 0))
		smoke_times--
		smoke.start()
		return
	return PROCESS_KILL

/obj/item/grenade/smokebomb/poison
	name = "WMA poison grenade"
	icon = 'icons/obj/items/grenades/grenade_large.dmi'

/obj/item/grenade/smokebomb/poison/detonate()
	playsound(src.loc, 'sound/effects/tank_rupture.wav', 50, 1, -3)
	smoke = new /datum/effect/effect/system/smoke_spread/bad/poison
	smoke.attach(src)
	smoke.set_up(10, 0, get_turf(src))
	START_PROCESSING(SSobj, src)
	for(var/obj/effect/blob/B in view(8,src))
		var/damage = round(30/(get_dist(B,src)+1))
		B.health -= damage
		B.update_icon()
	QDEL_IN(src, 8 SECONDS)