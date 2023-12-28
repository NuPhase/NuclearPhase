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
		L.throw_at(T, power * 0.5, L.throw_speed)
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
/proc/deflagration(turf/epicenter, power, falloff=1, falloff_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR, direction, shock_color=FIRE_COLOR_DEFAULT, spread_fluid)
	if(!istype(epicenter))
		epicenter = get_turf(epicenter)

	if(!epicenter)
		return

	falloff = max(falloff, power/100)

	msg_admin_attack("Explosion with Power: [power], Falloff: [falloff], Shape: [falloff_shape] in [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]).", epicenter.x, epicenter.y, epicenter.z)

	playsound(epicenter, 'sound/effects/explosionfar.ogg', 100, 1, round(power^2,1))

	if(power >= 300) //Make BIG BOOMS
		playsound(epicenter, "bigboom", 80, 1, max(round(power,1),7))
	else
		playsound(epicenter, "explosion", 90, 1, max(round(power,1),7))

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