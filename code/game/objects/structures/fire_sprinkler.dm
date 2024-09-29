/obj/structure/fire_sprinkler
	name = "fire sprinkler"
	desc = "Designed to keep you safe. Works only up to 5 atmospheres and dispenses 1.5L of water per second."
	icon = 'icons/obj/structures/fire_sprinkler.dmi'
	icon_state = "world"
	anchored = TRUE
	density = FALSE
	material = /decl/material/solid/metal/stainlesssteel
	layer = ABOVE_HUMAN_LAYER
	pixel_y = 8
	var/next_mist = 0

/obj/structure/fire_sprinkler/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	fire_alarm.register_alarm(src, TYPE_PROC_REF(/obj/structure/fire_sprinkler, alarm_change))

/obj/structure/fire_sprinkler/Destroy()
	. = ..()
	fire_alarm.unregister_alarm(src)

/obj/structure/fire_sprinkler/proc/alarm_change(alarm_handler, datum/alarm/alarm, was_raised)
	if(alarm.origin.get_alarm_area() != get_area(src))
		return
	if(was_raised)
		activate()
	else
		deactivate()

/obj/structure/fire_sprinkler/Process()
	var/turf/T = get_turf(src)
	var/datum/gas_mixture/environment = T.return_air()
	if(environment.pressure > 5*ONE_ATMOSPHERE)
		return
	environment.adjust_gas_temp(/decl/material/liquid/water/dirty1, 83.28, T20C)
	if(world.time >= next_mist && !(locate(/obj/effect/mist) in loc))
		new /obj/effect/mist(loc)
		next_mist = world.time + (25 SECONDS)

/obj/structure/fire_sprinkler/proc/activate()
	playsound(src, 'sound/structures/emergency_shower.mp3', 50, 0)
	START_PROCESSING(SSobj, src)

/obj/structure/fire_sprinkler/proc/deactivate()
	STOP_PROCESSING(SSobj, src)
	qdel(locate(/obj/effect/mist) in loc)