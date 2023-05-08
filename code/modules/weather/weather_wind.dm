/obj/abstract/weather_system
	var/tmp/wind_direction =    0                        // Bitflag; current wind direction.
	var/tmp/wind_strength =     1                        // How string is the wind currently?
	var/tmp/wind_speed =		10						 // Wind speed in m/s
	var/tmp/weather_stability = 66						 // Used in handle_wind()
	var/const/base_wind_delay = 1                        // What is the base movement delay or increase applied by wind strength?

// Randomizes wind speed and direction sometimes.
/obj/abstract/weather_system/proc/handle_wind()
	// TODO: turbulence for chance of wind changes,
	// ferocity for strength of wind changes
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
		wind_speed = Clamp(wind_speed + rand(-15, 15), 600, -600)
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
					if(5 to 15)
						to_chat(M, SPAN_NOTICE("The wind is light and unprovoking. It's blowing towards the [dir2text(wind_direction)]."))
					if(15 to 50)
						to_chat(M, SPAN_WARNING("The wind is storming, it's dangerous around here. It's blowing towards the [dir2text(wind_direction)]."))
					if(50 to 250)
						to_chat(M, SPAN_WARNING("You feel the heavy wind banging and whistling all around your suit. It's blowing towards the [dir2text(wind_direction)]."))
					if(250 to 340)
						to_chat(M, SPAN_WARNING("The surrounding wind is borderline transonic, tiny shockwaves start forming on your suit. It's blowing towards the [dir2text(wind_direction)]."))
					if(340 to 600)
						to_chat(M, SPAN_WARNING("Strong vibrations of the supersonic wind distract you. It's blowing towards the [dir2text(wind_direction)]."))