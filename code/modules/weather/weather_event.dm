/datum/weather_event
	var/auto_trigger = FALSE
	var/ongoing = FALSE
	var/override_all = FALSE

/datum/weather_event/proc/start()
	ongoing = TRUE

/datum/weather_event/proc/end()
	ongoing = FALSE
	qdel(src)

/datum/weather_event/sunrise
	override_all = TRUE

/datum/weather_event/sunrise/start()
	..()
	var/obj/abstract/weather_system/weather = using_map.weather_system
	weather.weather_system.set_state(/decl/state/weather/sunriseone)
	weather.icon_state = "snowfall_light"
	for(var/turf/T in surface_turfs)
		T.set_ambient_light(COLOR_SUNRISE_SURFACE1, 1)
	for(var/mob/living/carbon/human/H in surface_mobs)
		H.lastarea.do_ambience = FALSE
		H.lastarea.clear_ambience(H)
		sound_to(H, sound('sound/music/sunrise.ogg',0,50,sound_channels.lobby_channel))
		to_chat(H, "<span class=bigdanger>The sky erupts in bright crimson red, like you've never seen before. Slow streams of flame rush away from the approaching, scorching, death-bringing source of light. Clouds of once frozen gas will hold it back for a some time, but not for long. Infernal doom approaches.</span>")
	sleep(280)
	weather.icon_state = "hail"
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, "<span class=bigdanger>A slight vibration stops you for a moment, you notice small cracks forming in the ice right before your eyes, they seem to creep away from the light, creating beautiful patterns that almost distract you from your main goal: survival.</span>")
	for(var/turf/exterior/surface/T in surface_turfs)
		T.set_ambient_light(COLOR_SUNRISE_SURFACE2, 2)
		T.switch_cracks(FALSE)
	sleep(300)
	weather.icon_state = "storm"
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, "<span class=bigdanger>Your footwear is slowly getting wet as more and more ice melts under the sheer power of the rising star. If there's one thing you can do to survive, it's to get to a safe place as quickly as possible, against all odds and circumstances.</span>")
	for(var/turf/T in surface_turfs)
		T.set_ambient_light(COLOR_SUNRISE_SURFACE3, 2)
		T.footstep_type = /decl/footsteps/water
	sleep(250)
	weather.icon_state = "ashfall_light"
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, "<span class=bigdanger>You turn back to look at the source of the light, only to be dazzled and distracted. You open your eyes at the startling sight: a few rays of light breaking through the clouds and melting the stone that was beneath several layers of now non-existent ice...</span>")
		H.flash_eyes(99)
	for(var/turf/exterior/surface/T in surface_turfs)
		T.set_ambient_light(COLOR_SUNRISE_SURFACE4, 3)
		T.icon = 'icons/turf/exterior/volcanic.dmi'
		T.possible_states = 0
		T.icon_state = "[rand(0, T.possible_states)]"
		T.dirt_color = COLOR_GRAY20
		T.icon_edge_layer = EXT_EDGE_VOLCANIC
		T.update_icon()
		T.footstep_type = /decl/footsteps/asteroid
		T.switch_cracks(TRUE)
	sleep(470)
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, "<span class=bigdanger>The intense heat seems to have subsided a little, but that's only because a huge amount of gas burns up and explodes in the upper atmosphere, delaying your inescapable fate for another dozen seconds...</span>")
	spawn(0) //So we won't slow down
		for(var/turf/T in surface_turfs)
			T.set_ambient_light(COLOR_SUNRISE_SURFACE3, 2)
			if(prob(5))
				spawn(rand(1, 50))
					playsound(T, 'sound/effects/explosionfar.ogg', 200, 1, 50, 1)
	sleep(130)
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, "<span class=bigdanger>Just moments away from a terrifying demise, the repercussion of the dangerous adventure you've embarked on, comes the final realization: your fate is only slightly better than the one others will experience, vaporized by hypersonic winds and enormous temperatures, most will smile knowing their story has come to an end... And so will you?</span>")
	sleep(320)
	for(var/mob/living/carbon/human/H in surface_mobs)
		H.flash_eyes(99)
		spawn(10)
			H.dust()
	for(var/turf/T in surface_turfs)
		T.set_ambient_light(COLOR_HOT_SURFACE, 2)
	sleep(600)
	end()