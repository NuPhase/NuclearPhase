/datum/weather_event/sunset
	override_all = TRUE
	var/obj/abstract/weather_system/weather

/datum/weather_event/sunset/proc/interpolate_temperature(rand_min, rand_max, sleep_time, target)
	set waitfor = 0
	while(using_map.exterior_atmosphere.temperature > target)
		using_map.exterior_atmosphere.temperature -= rand(rand_min, rand_max)
		sleep(sleep_time)

/datum/weather_event/sunset/start()
	..()
	weather = using_map.weather_system
	weather.weather_system.set_state(/decl/state/weather/calm)
	weather.icon_state = "snowfall_light"
	interpolate_temperature(1, 1.5, 10, 34 CELSIUS)
	for(var/turf/T in surface_turfs)
		T.set_ambient_light(COLOR_SUNSET_SURFACE1, 1)
	for(var/area/A in surface_areas)
		A.do_ambience = FALSE
	for(var/mob/living/carbon/human/H in surface_mobs)
		H.lastarea.clear_ambience(H)
		to_chat(H, SPAN_ERPBOLD("The sun descends below the horizon, bathing the surface in twilight. The ground is still steaming hot."))
	weather.favorable_wind_speed = 20
	weather.wind_speed = 20
	weather.handle_wind()
	addtimer(CALLBACK(src, .proc/timer_one), 8 MINUTES, TIMER_CLIENT_TIME)
	addtimer(CALLBACK(src, .proc/timer_two), 15 MINUTES, TIMER_CLIENT_TIME)
	addtimer(CALLBACK(src, .proc/timer_three), 20 MINUTES, TIMER_CLIENT_TIME)

/datum/weather_event/sunset/proc/timer_one()
	for(var/turf/T in surface_turfs)
		T.set_ambient_light(COLOR_SUNSET_SURFACE2, 1)
	interpolate_temperature(0.1, 0.15, 10, -30 CELSIUS)

/datum/weather_event/sunset/proc/timer_two()
	for(var/turf/T in surface_turfs)
		T.set_ambient_light(COLOR_SUNSET_SURFACE3, 1)
	interpolate_temperature(0.3, 0.5, 10, -60 CELSIUS)
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, "<span class=bigdanger>A huge frozen cloud is approaching from the horizon. It's about to get really, really cold...</span>")

/datum/weather_event/sunset/proc/timer_three()
	weather.weather_system.set_state(/decl/state/weather/snow/heavy)
	weather.icon_state = "snowfall_heavy"
	for(var/turf/exterior/surface/T in surface_turfs)
		T.set_ambient_light(COLOR_COLD_SURFACE, 1)
		T.transition(FALSE)
	interpolate_temperature(2, 4, 10, 17)
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, "<span class=bigdanger>The frozen cloud hits you with relentless force, chilling the ground almost instantly.</span>")