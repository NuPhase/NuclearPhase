var/global/list/flooring_cache = list()

/turf/simulated/floor/on_update_icon(var/update_neighbors)

	. = ..()
	cut_overlays()
	if(lava)
		return

	var/has_smooth = 0 //This is just the has_border bitfield inverted for easier logic

	if(flooring)
		// Set initial icon and strings.
		SetName(flooring.name)
		desc = flooring.desc
		icon = flooring.icon
		color = flooring.color

		if(flooring_override)
			icon_state = flooring_override
		else
			icon_state = flooring.icon_base
			if(flooring.has_base_range)
				icon_state = "[icon_state][rand(0,flooring.has_base_range)]"
				flooring_override = icon_state

		// Apply edges, corners, and inner corners.
		var/has_border = 0
		//Check the cardinal turfs
		for(var/step_dir in global.cardinal)
			var/turf/simulated/floor/T = get_step_resolving_mimic(src, step_dir)
			if(!istype(T) || flooring.test_link(src, T))
				continue

			//Alright we've figured out whether or not we smooth with this turf
			has_border += step_dir // these are always powers of two which we loop over once, so no need for bitmath

			//Now, if we don't, then lets add a border
			if(check_state_in_icon("[flooring.icon_base]_edges", flooring.icon))
				add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-edge-[step_dir]", "[flooring.icon_base]_edges", step_dir, (flooring.flags & TURF_HAS_EDGES)))

		has_smooth = ~(has_border) & (NORTH | SOUTH | EAST | WEST)

		if(flooring.can_paint && LAZYLEN(decals))
			add_overlay(decals.Copy())

		//We can only have inner corners if we're smoothed with something
		if (has_smooth && flooring.flags & TURF_HAS_INNER_CORNERS)
			for(var/direction in global.cornerdirs)
				if((has_smooth & direction) == direction)
					if(!flooring.test_link(src, get_step_resolving_mimic(src, direction)) && check_state_in_icon("[flooring.icon_base]_corners", flooring.icon))
						add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-corner-[direction]", "[flooring.icon_base]_corners", direction))

		//Next up, outer corners
		if (has_border && flooring.flags & TURF_HAS_CORNERS)
			for(var/direction in global.cornerdirs)
				if((has_border & direction) == direction)
					if(!flooring.test_link(src, get_step_resolving_mimic(src, direction)) && check_state_in_icon("[flooring.icon_base]_edges", flooring.icon))
						add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-edge-[direction]", "[flooring.icon_base]_edges", direction,(flooring.flags & TURF_HAS_EDGES)))

	for(var/image/I in decals)
		if(I.layer != DECAL_PLATING_LAYER)
			continue
		add_overlay(I)

	if(is_plating() && !(isnull(broken) && isnull(burnt))) //temp, todo
		icon = 'icons/turf/flooring/plating.dmi'
		icon_state = "dmg[rand(1,4)]"
	else if(flooring)
		if(!isnull(broken) && (flooring.flags & TURF_CAN_BREAK))
			add_overlay(get_damage_overlay("broken[broken]", BLEND_MULTIPLY))
		if(!isnull(burnt) && (flooring.flags & TURF_CAN_BURN))
			add_overlay(get_damage_overlay("burned[burnt]"))

	if(update_neighbors)
		for(var/turf/simulated/floor/F in orange(src, 1))
			F.queue_ao(FALSE)
			F.update_icon()

/turf/simulated/floor/proc/get_flooring_overlay(var/cache_key, var/icon_base, var/icon_dir = 0, var/external = FALSE)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = flooring.icon, icon_state = icon_base, dir = icon_dir)

		//External overlays will be offset out of this tile
		if (external)
			if (icon_dir & NORTH)
				I.pixel_y = world.icon_size
			else if (icon_dir & SOUTH)
				I.pixel_y = -world.icon_size

			if (icon_dir & WEST)
				I.pixel_x = -world.icon_size
			else if (icon_dir & EAST)
				I.pixel_x = world.icon_size
		I.layer = flooring.decal_layer

		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]

/turf/proc/get_damage_overlay(var/overlay_state, var/blend, var/damage_overlay_icon = 'icons/turf/flooring/damage.dmi')
	var/cache_key = "[icon]-[overlay_state]"
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = damage_overlay_icon, icon_state = overlay_state)
		if(blend)
			I.blend_mode = blend
		I.layer = DECAL_LAYER
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]

/decl/flooring/proc/test_link(var/turf/opponent)
	if(omni_smooth) // override EVERYTHING
		return TRUE
	// Just a normal floor
	if (istype(opponent, /turf/simulated/floor))
		if (floor_smooth == SMOOTH_ALL)
			return TRUE
		var/turf/simulated/floor/floor_opponent = opponent
		var/decl/flooring/opponent_flooring = floor_opponent.flooring
		//If the floor is the same as us,then we're linked,
		if (istype(opponent_flooring, neighbour_type))
			return TRUE
		//If we get here it must be using a whitelist or blacklist
		if (floor_smooth == SMOOTH_WHITELIST)
			if (flooring_whitelist[opponent_flooring.type])
				//Found a match on the typecache
				return TRUE
		else if(floor_smooth == SMOOTH_BLACKLIST)
			if (flooring_blacklist[opponent_flooring.type]) {EMPTY_BLOCK_GUARD} else
				//No match on the typecache
				return TRUE
		//Check for window frames.
		if (wall_smooth == SMOOTH_ALL && locate(/obj/structure/wall_frame) in opponent)
			return TRUE
	// Wall turf
	else if(opponent.is_wall()) // don't combine these so that we don't check if a wall is space just because we don't smooth with walls
		if(wall_smooth == SMOOTH_ALL)
			return TRUE
	//If is_open is true, then it's space or openspace
	else if(opponent.is_open())
		if(space_smooth == SMOOTH_ALL)
			return TRUE
	return FALSE
