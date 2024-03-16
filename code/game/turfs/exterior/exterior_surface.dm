/turf/exterior/surface
	name = "surface"
	icon = 'icons/turf/exterior/snow.dmi'
	icon_edge_layer = EXT_EDGE_SNOW
	footstep_type = /decl/footsteps/snow
	possible_states = 13
	color = "#bdb3c2"
	dirt_color = "#7a707e"
	var/datum/map/mapowner = null

/turf/exterior/surface/explosion_act(severity)
	return

/turf/exterior/surface/get_air_graphic()
	return mapowner.exterior_atmosphere?.graphic

/turf/exterior/surface/Initialize(mapload, no_update_icon)
	mapowner = global.using_map

	if(possible_states > 0)
		icon_state = "[rand(0, possible_states)]"

	if(!istype(mapowner))
		owner = null
	else
		//Must be done here, as light data is not fully carried over by ChangeTurf (but overlays are).
		if(mapowner.planetary_area && istype(loc, world.area))
			ChangeArea(src, mapowner.planetary_area)

	//. = ..(mapload)	// second param is our own, don't pass to children
	setup_environmental_lighting()

	var/air_graphic = get_air_graphic()
	if(length(air_graphic))
		add_vis_contents(src, air_graphic)

	if (no_update_icon)
		return

	if (mapload)	// If this is a mapload, then our neighbors will be updating their own icons too -- doing it for them is rude.
		update_icon()
	else
		for (var/turf/T in RANGE_TURFS(src, 1))
			if (T == src)
				continue
			if (TICK_CHECK)	// not CHECK_TICK -- only queue if the server is overloaded
				T.queue_icon_update()
			else
				T.update_icon()

	. = ..(mapload, no_update_icon, should_override = TRUE)

/turf/exterior/surface/setup_environmental_lighting(var/ncolor = COLOR_COLD_SURFACE)
	if (is_outside())
		surface_turfs += src
		if (mapowner)
			set_ambient_light(ncolor, mapowner.lightlevel)
			return
	else if (ambient_light)
		clear_ambient_light()

/turf/exterior/surface/return_air()
	if(!mapowner)
		return
	var/datum/gas_mixture/gas
	gas = new
	gas.copy_from(mapowner.exterior_atmosphere)

	var/initial_temperature = gas.temperature
	for(var/thing in affecting_heat_sources)
		if((gas.temperature - initial_temperature) >= 100)
			break
		var/obj/structure/fire_source/heat_source = thing
		gas.temperature = gas.temperature + heat_source.exterior_temperature / max(1, get_dist(src, get_turf(heat_source)))
	return gas

/turf/exterior/surface/proc/switch_cracks(var/remove_cracks = FALSE) //i shat myself
	if(remove_cracks)
		overlays.Cut()
		return
	if(prob(15))
		overlays += image('icons/turf/snow.dmi', "cracks", dir = pick(cardinal))
	else
		spawn(50)
			if(prob(15))
				overlays += image('icons/turf/snow.dmi', "cracks", dir = pick(cardinal))

/turf/exterior/surface/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	density = 0
	pathweight = 100000
	z_flags = ZM_MIMIC_DEFAULTS | ZM_MIMIC_OVERWRITE | ZM_MIMIC_NO_AO | ZM_ALLOW_ATMOS
	turf_flags = TURF_FLAG_BACKGROUND
	icon_edge_layer = -1

/turf/exterior/surface/open/flooded
	name = "open water"
	flooded = TRUE

/turf/exterior/surface/open/Entered(var/atom/movable/mover, var/atom/oldloc)
	..()
	mover.fall(oldloc)

/turf/exterior/surface/open/hitby(var/atom/movable/AM)
	..()
	if(!QDELETED(AM))
		AM.fall()

/turf/exterior/surface/open/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 2)
		var/depth = 1
		for(var/turf/T = GetBelow(src); (istype(T) && T.is_open()); T = GetBelow(T))
			depth += 1
		to_chat(user, "It is about [depth] level\s deep.")

/turf/exterior/surface/open/is_open()
	return TRUE

/turf/exterior/surface/open/attackby(obj/item/C, mob/user)
	return shared_open_turf_attackby(src, C, user)

/turf/exterior/open/attack_hand(mob/user)
	return shared_open_turf_attackhand(src, user)

/turf/exterior/surface/open/cannot_build_cable()
	return 0

/turf/simulated/open/exterior
	name = "canyon"
	desc = "Looks very deep..."
	var/datum/map/mapowner = null

/turf/simulated/open/exterior/Initialize()
	..()
	mapowner = global.using_map
	setup_environmental_lighting()

/turf/simulated/open/exterior/proc/setup_environmental_lighting(var/ncolor = COLOR_COLD_SURFACE)
	if (is_outside())
		surface_turfs += src
		if (mapowner)
			set_ambient_light(ncolor, mapowner.lightlevel)
			return
	else if (ambient_light)
		clear_ambient_light()

/turf/simulated/open/exterior/proc/switch_cracks()
	return

/obj/effect/fake_fluid
	name = "liquid gas"
	icon = 'icons/effects/liquids.dmi'
	icon_state = "mid_still"
	anchored = 1
	simulated = 0
	opacity = 0
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	layer = FLY_LAYER
	alpha = 135
	color = "#72d3eb"

//TODO: More advanced drowning effects
/obj/effect/fake_fluid/Crossed(O)
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		H.dust()