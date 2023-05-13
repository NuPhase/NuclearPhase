/datum/composite_sound/wind_light
	mid_sounds = list('sound/ambience/weather/storm_outside.wav')
	mid_length = 100
	volume = 50
	direct = TRUE

/datum/composite_sound/wind_severe
	start_sound = 'sound/ambience/weather/sonic_boom.wav'
	start_length = 3
	mid_sounds = list('sound/ambience/weather/storm_outside2.wav')
	mid_length = 100
	volume = 50
	direct = TRUE

/obj/abstract/weather_system
	var/tmp/wind_direction =    0                        // Bitflag; current wind direction.
	var/tmp/wind_strength =     1                        // How string is the wind currently?
	var/tmp/wind_speed =		10						 // Wind speed in m/s
	var/tmp/weather_stability = 66						 // Used in handle_wind()
	var/const/base_wind_delay = 1                        // What is the base movement delay or increase applied by wind strength?
	var/datum/composite_sound/wind_light/windloop_light
	var/datum/composite_sound/wind_severe/windloop_severe
	var/list/windloop_play_atoms = list()
	var/favorable_wind_speed = 370

// Randomizes wind speed and direction sometimes.
/obj/abstract/weather_system/proc/handle_wind()
	// TODO: turbulence for chance of wind changes,
	// ferocity for strength of wind changes

	var/absolute_speed = abs(wind_speed)
	switch(absolute_speed)
		if(0 to 5)
			if(windloop_severe)
				QDEL_NULL(windloop_severe)
			if(windloop_light)
				QDEL_NULL(windloop_light)
		if(5 to 25)
			if(windloop_severe)
				QDEL_NULL(windloop_severe)
			if(!windloop_light)
				windloop_light = new(windloop_play_atoms)
			else
				windloop_light.output_atoms = windloop_play_atoms
			windloop_light.mid_sounds = list('sound/ambience/weather/wind_light.wav')
		if(25 to 250)
			if(windloop_severe)
				QDEL_NULL(windloop_severe)
			if(!windloop_light)
				windloop_light = new(windloop_play_atoms)
			else
				windloop_light.output_atoms = windloop_play_atoms
			windloop_light.mid_sounds = list('sound/ambience/weather/wind_heavy.wav')
		if(250 to 340)
			if(windloop_severe)
				QDEL_NULL(windloop_severe)
			if(!windloop_light)
				windloop_light = new(windloop_play_atoms)
			else
				windloop_light.output_atoms = windloop_play_atoms
			windloop_light.mid_sounds = list('sound/ambience/weather/wind_transonic.wav')
		if(340 to INFINITY)
			if(windloop_light)
				QDEL_NULL(windloop_light)
			if(!windloop_severe)
				windloop_severe = new(windloop_play_atoms)
			else
				windloop_severe.output_atoms = windloop_play_atoms

	if(prob(weather_stability))
		return
	if(prob(10))
		if(!wind_direction)
			wind_direction = pick(global.alldirs)
		else
			wind_direction = turn(wind_direction, pick(45, -45))
		mob_shown_wind.Cut()
	if(prob(10))
		var/old_strength = wind_strength
		wind_speed = Interpolate(wind_speed, favorable_wind_speed + rand(-15, 15), 0.2)
		wind_strength = Clamp(wind_strength + rand(-1, 1), 5, -5)
		if(old_strength != wind_strength)
			mob_shown_wind.Cut()

/obj/abstract/weather_system/proc/show_wind(var/mob/M, var/force = FALSE)
	var/mob_ref = weakref(M)
	if(mob_shown_wind[mob_ref] && !force)
		return FALSE
	mob_shown_wind[mob_ref] = TRUE
	. = TRUE
	var/turf/T = get_turf(M)
	if(istype(T))
		var/datum/gas_mixture/environment = T.return_air()
		if(environment && environment.return_pressure() >= MIN_WIND_PRESSURE) // Arbitrary low pressure bound.
			var/absolute_strength = abs(wind_speed)
			if(absolute_strength <= 5 || !wind_direction)
				to_chat(M, SPAN_NOTICE("The wind is calm."))
			else
				switch(absolute_strength)
					if(5 to 25)
						to_chat(M, SPAN_NOTICE("The wind is light and unprovoking. It's blowing towards the [dir2text(wind_direction)]."))
					if(25 to 50)
						to_chat(M, SPAN_WARNING("The wind is storming, it's dangerous around here. It's blowing towards the [dir2text(wind_direction)]."))
					if(50 to 250)
						to_chat(M, SPAN_WARNING("You feel the heavy wind banging and whistling all around your suit. It's blowing towards the [dir2text(wind_direction)]."))
					if(250 to 340)
						to_chat(M, SPAN_WARNING("The surrounding wind is borderline transonic, tiny shockwaves start forming on your suit. It's blowing towards the [dir2text(wind_direction)]."))
					if(340 to INFINITY)
						to_chat(M, SPAN_WARNING("Strong vibrations of the supersonic wind distract you. It's blowing towards the [dir2text(wind_direction)]."))