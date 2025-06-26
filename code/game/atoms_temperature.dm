#define MAX_TEMPERATURE_COEFFICIENT  0.95
#define CLOTHING_TEMP_COEF_DEFAULT   0.8
#define CLOTHING_TEMP_COEF_ABOVE_AVG 0.6   // Slightly warm clothing, like jeans and hoodies
#define CLOTHING_TEMP_COEF_MEDIUM    0.4   // Dense clothing, like armor
#define CLOTHING_TEMP_COEF_HIGH      0.2   // Clothing like winter coats
#define CLOTHING_TEMP_COEF_INSULATED 0.05  // Fire suits, rescue suits
#define CLOTHING_TEMP_COEF_SPECIAL   0.02  // Surface exosuits
#define MIN_TEMPERATURE_COEFFICIENT  0.01

/atom
	/// What is this atom's current temperature?
	var/temperature = T20C
	/// How rapidly does this atom equalize with ambient temperature?
	var/temperature_coefficient = MAX_TEMPERATURE_COEFFICIENT
	var/failure_chance = FALSE // Can fail at roundstart, and if so, at which coefficient of probability?

/atom/movable/Entered(var/atom/movable/atom, var/atom/old_loc)
	. = ..()
	QUEUE_TEMPERATURE_ATOMS(atom)

/obj
	temperature_coefficient = null

/mob
	temperature_coefficient = null

/turf
	temperature_coefficient = MIN_TEMPERATURE_COEFFICIENT

/obj/Initialize(mapload)
	. = ..()
	temperature_coefficient = isnull(temperature_coefficient) ? Clamp(MAX_TEMPERATURE_COEFFICIENT - w_class, MIN_TEMPERATURE_COEFFICIENT, MAX_TEMPERATURE_COEFFICIENT) : temperature_coefficient
	create_matter()
	if(start_dirty)
		append_some_dirt()
	if(start_old)
		make_old(start_dirty)
	if(mapload && failure_chance)
		SSdifficulty.difficulty_affected_objs += src

/atom/proc/handle_external_heating(var/adjust_temp, var/obj/item/heated_by, var/mob/user)

	// Show a little message for people heating beakers with welding torches.
	if(user && heated_by)
		visible_message(SPAN_NOTICE("\The [user] carefully heats \the [src] with \the [heated_by]."))

	// If this is a simulated atom, adjust our temperature.
	// This will eventually propagate to our contents via ProcessAtomTemperature()
	if(ATOM_SHOULD_TEMPERATURE_ENQUEUE(src))
		// Update our own heat.
		var/diff_temp = (adjust_temp - temperature)
		if(diff_temp >= 0)
			var/altered_temp = temperature + (diff_temp * temperature_coefficient * ATOM_TEMPERATURE_EQUILIBRIUM_CONSTANT)
			ADJUST_ATOM_TEMPERATURE(src, min(adjust_temp, altered_temp))
			return TRUE

/mob/Initialize()
	. = ..()
	temperature_coefficient = isnull(temperature_coefficient) ? Clamp(MAX_TEMPERATURE_COEFFICIENT - FLOOR(mob_size/4), MIN_TEMPERATURE_COEFFICIENT, MAX_TEMPERATURE_COEFFICIENT) : temperature_coefficient

// TODO: move mob bodytemperature onto this proc.
/atom/proc/ProcessAtomTemperature()
	SHOULD_NOT_SLEEP(TRUE)

	// Get our location temperature if possible.
	// Nullspace is room temperature, clearly.
	var/adjust_temp
	if(loc)
		if(!istype(loc, /turf/simulated))
			adjust_temp = loc.temperature
		else
			var/turf/simulated/T = loc
			if(T.zone && T.zone.air)
				adjust_temp = T.zone.air.temperature
			else
				adjust_temp = T20C
	else
		adjust_temp = T20C

	// Determine if our temperature needs to change.
	var/old_temp = temperature
	var/diff_temp = adjust_temp - temperature
	if(abs(diff_temp) >= ATOM_TEMPERATURE_EQUILIBRIUM_THRESHOLD)
		var/altered_temp = temperature + (diff_temp * temperature_coefficient * ATOM_TEMPERATURE_EQUILIBRIUM_CONSTANT)
		ADJUST_ATOM_TEMPERATURE(src, (diff_temp > 0) ? min(adjust_temp, altered_temp) : max(adjust_temp, altered_temp))
	else
		temperature = adjust_temp
		. = PROCESS_KILL

	// If our temperature changed, our contents probably want to know about it.
	if(temperature != old_temp)
		queue_temperature_atoms(get_contained_temperature_sensitive_atoms())
