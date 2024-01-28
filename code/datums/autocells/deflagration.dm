/datum/automata_cell/explosion/deflagration
	var/shock_color = FIRE_COLOR_DEFAULT
	var/spread_fluid_type

// If you need to set vars on the new cell other than the basic ones
/datum/automata_cell/explosion/deflagration/setup_new_cell(datum/automata_cell/explosion/deflagration/E)
	if(E.shockwave)
		E.shockwave.alpha = E.power
		E.shockwave.color = E.shock_color
	if(E.spread_fluid_type)
		E.in_turf.add_fluid(spread_fluid_type, power*100)
	return

/datum/automata_cell/explosion/deflagration/update_state(list/turf/neighbors)
	if(delay > 0)
		delay--
		return
	// The resistance here will affect the damage taken and the falloff in the propagated explosion
	var/resistance = max(0, in_turf.explosion_resistance)
	for(var/atom/A in in_turf)
		resistance += max(0, A.explosion_resistance)

	// Blow stuff up
	for(var/mob/living/L in in_turf)
		L.apply_damage(power * 0.05, BURN)
		L.apply_damage(power * 0.01, BRUTE)
		var/turf/T = get_ranged_target_turf(L, get_dir(L, get_step_away(L, in_turf)), power_falloff)
		L.throw_at(T, power * 0.05, L.throw_speed)
		L.adjust_fire_stacks(10)
		L.IgniteMob()
	for(var/obj/item/item in in_turf)
		item.throw_at(get_step_away(item, in_turf), item.throw_range, item.throw_speed, in_turf)
	if(istype(in_turf, /turf/simulated/wall))
		ADJUST_ATOM_TEMPERATURE(in_turf, power * 5)
	else
		in_turf.create_fire(power / 100)

	var/reflected = FALSE

	// Epicenter is inside a wall if direction is null.
	// Prevent it from slurping the entire explosion
	if(!isnull(direction))
		// Bounce off the wall in the opposite direction, don't keep phasing through it
		// Notice that since we do this after the ex_act()s,
		// explosions will not bounce if they destroy a wall!
		if(power < resistance)
			reflected = TRUE
			power *= reflection_power_multiplier
		else
			power -= resistance

	if(power <= 0)
		qdel(src)
		return

	// Propagate the explosion
	var/list/to_spread = get_propagation_dirs(reflected)
	for(var/dir in to_spread)
		// Diagonals are longer, that should be reflected in the power falloff
		var/dir_falloff = 1
		if(dir in cornerdirs)
			dir_falloff = 1.414

		if(isnull(direction))
			dir_falloff = 0

		var/new_power = power - (power_falloff * dir_falloff)

		// Explosion is too weak to continue
		if(new_power <= 0)
			continue

		var/new_falloff = power_falloff
		// Handle our falloff function.
		switch(falloff_shape)
			if(EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL)
				new_falloff += new_falloff * dir_falloff
			if(EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_HALF)
				new_falloff += (new_falloff*0.5) * dir_falloff

		var/datum/automata_cell/explosion/deflagration/E = propagate(dir)
		if(E)
			E.power = new_power
			E.power_falloff = new_falloff
			E.falloff_shape = falloff_shape
			E.shock_color = shock_color
			E.spread_fluid_type = spread_fluid_type

			// Set the direction the explosion is traveling in
			E.direction = dir
			//Diagonal cells have a small delay when branching off the center. This helps the explosion look circular
			if(!direction && (dir in cornerdirs))
				E.delay = 1

			setup_new_cell(E)

	// We've done our duty, now die pls
	qdel(src)

// I'll admit most of the code from here on out is basically just copypasta from DOREC

// Spawns a cellular automaton of an explosion
/proc/deflagration(turf/epicenter, power, falloff=1, falloff_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR, direction, shock_color=FIRE_COLOR_DEFAULT, spread_fluid, z_transfer=UP|DOWN)
	if(!istype(epicenter))
		epicenter = get_turf(epicenter)

	if(!epicenter)
		return

	falloff = max(falloff, power/100)

	msg_admin_attack("Explosion with Power: [power], Falloff: [falloff], Shape: [falloff_shape] in [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]).", epicenter.x, epicenter.y, epicenter.z)

	if(power >= get_config_value(/decl/config/num/iterative_explosives_z_threshold))
		var/turf/above_T = GetAbove(epicenter)
		var/turf/below_T = GetBelow(epicenter)
		if((z_transfer & UP) && above_T)
			if(istype(above_T, /turf/simulated/open))
				deflagration(above_T, power * 0.5, falloff=falloff, z_transfer=UP)
			else
				deflagration(above_T, power * get_config_value(/decl/config/num/iterative_explosives_z_multiplier), falloff=falloff, z_transfer=UP)
		if((z_transfer & DOWN) && below_T)
			if(istype(below_T, /turf/simulated/open))
				deflagration(below_T, power * 0.5, falloff=falloff, z_transfer=DOWN)
			else
				deflagration(below_T, power * get_config_value(/decl/config/num/iterative_explosives_z_multiplier), falloff=falloff, z_transfer=DOWN)

	// Play sounds; we want sounds to be different depending on distance so we will manually do it ourselves.
	// Stereo users will also hear the direction of the explosion!
	// Calculate far explosion sound range. Only allow the sound effect for heavy/devastating explosions.

	var/far_dist = power * 0.45
	var/frequency = get_rand_frequency()
	for(var/mob/M in global.player_list)
		if(M.z == epicenter.z)
			var/turf/M_turf = get_turf(M)
			var/dist = get_dist(M_turf, epicenter)
			// If inside the blast radius + world.view - 2
			if(dist <= round(power * 0.2 + world.view - 2, 1))
				M.playsound_local(epicenter, get_sfx("explosion"), 100, 1, frequency, falloff = 5) // get_sfx() is so that everyone gets the same sound
			else if(dist <= far_dist)
				var/far_volume = Clamp(far_dist, 30, 50) // Volume is based on explosion size and dist
				far_volume += (dist <= far_dist * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
				M.playsound_local(epicenter, pick('sound/effects/explosionfar.ogg', 'sound/effects/explosionfar2.ogg', 'sound/effects/explosionfar3.ogg', 'sound/effects/explosionfar4.ogg', 'sound/effects/explosionfar5.ogg', 'sound/effects/explosionfar6.ogg'), far_volume, 1, frequency, falloff = 5)

	var/datum/automata_cell/explosion/deflagration/E = new /datum/automata_cell/explosion/deflagration(epicenter)
	if(power > EXPLOSION_MAX_POWER)
		log_debug("Deflagration with force of [power]. Overriding to capacity of [EXPLOSION_MAX_POWER].")
		power = EXPLOSION_MAX_POWER

	// something went wrong :(
	if(QDELETED(E))
		return

	E.power = power
	E.power_falloff = falloff
	E.falloff_shape = falloff_shape
	E.direction = direction
	E.shock_color = shock_color
	E.spread_fluid_type = spread_fluid