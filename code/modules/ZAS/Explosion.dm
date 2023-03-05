

#define MAX_DEFLAGRATION_STRENGTH 100

/obj/effect/deflagarate
	name = "gust of flames"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	color = FIRE_COLOR_DEFAULT
	anchored = TRUE
	density = 0
	var/strength = 50
	var/falloff = 3

/obj/effect/deflagarate/Destroy()
	set_light(0, 0, null)
	. = ..()

/obj/effect/deflagarate/New(loc, nstrength = 50, nfalloff = 5)
	var/turf/simulated/floor/F = get_turf(src)
	F.deflaged = TRUE
	spawn(10)
		F.deflaged = FALSE
	strength = nstrength
	falloff = nfalloff
	strength -= falloff
	alpha = strength / MAX_DEFLAGRATION_STRENGTH * 255
	if(strength < 5)
		qdel(src)
		return

	spawn(1)
		for(var/mob/living/L in loc)
			L.apply_damage(strength * 2, BURN)
			L.apply_damage(strength * 0.5, BRUTE)
			L.throw_at(get_step_away(L, src), strength * 0.5, L.throw_speed, src)
			L.adjust_fire_stacks(10)
		for(var/obj/item/item in loc)
			item.throw_at(get_step_away(item, src), item.throw_range, item.throw_speed, src)
		for(var/direction in global.alldirs)
			var/turf/simulated/T = get_step(get_turf(src), direction)
			if(istype(T, /turf/simulated/floor) && T.CanPass(null,F,0,0))
				var/turf/simulated/floor/Tf = T
				if(!Tf.deflaged)
					var/obj/effect/deflagarate/D = new(T, strength, falloff)
					D.dir = direction
					D.update_icon()
					Tf.create_fire(strength / 10)
			if(istype(T, /turf/simulated/wall))
				var/turf/simulated/wall/Tw = T
				Tw.take_damage(strength * 0.1)
		spawn(1)
			qdel(src)

/obj/effect/deflagarate/update_icon()
	. = ..()
	set_light(2, strength * 0.5, color)