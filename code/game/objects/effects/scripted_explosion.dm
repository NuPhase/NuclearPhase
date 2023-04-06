var/global/list/scripted_explosions = list()

/obj/effect/scripted_detonation
	anchored = 1
	mouse_opacity = 0
	mouse_opacity = FALSE
	simulated = FALSE
	var/devastation_radius = 0
	var/heavy_radius = 0
	var/light_radius = 0
	var/id = ""

/obj/effect/scripted_detonation/Destroy()
	. = ..()
	scripted_explosions[id] = null

/obj/effect/scripted_detonation/New(loc, ...)
	. = ..()
	if(id)
		scripted_explosions[id] = src

/obj/effect/scripted_detonation/proc/trigger()
	explosion(get_turf(src), devastation_radius, heavy_radius, light_radius, light_radius * 2)


/obj/effect/scripted_deflagration
	anchored = 1
	mouse_opacity = FALSE
	var/strength = 0
	var/falloff = 1
	var/id = ""

/obj/effect/scripted_deflagration/Destroy()
	. = ..()
	scripted_explosions[id] = null

/obj/effect/scripted_deflagration/New(loc, ...)
	. = ..()
	if(id)
		scripted_explosions[id] = src

/obj/effect/scripted_deflagration/proc/trigger()
	new /obj/effect/deflagarate(get_turf(src), strength, falloff)