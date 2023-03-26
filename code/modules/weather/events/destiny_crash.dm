/datum/weather_event/destiny_crash
	auto_trigger = TRUE
	override_all = TRUE

/datum/weather_event/destiny_crash/start()
	..()
	var/obj/abstract/weather_system/weather = using_map.weather_system
	for(var/area/A in surface_areas)
		A.do_ambience = FALSE
	for(var/mob/living/carbon/human/H in surface_mobs)
		H.lastarea.clear_ambience(H)
		H.playsound_local(H.loc, 'sound/music/destiny.ogg', 50, 0)
		to_chat(H, SPAN_ERPBOLD("You notice a glowing object passing through the atmosphere at insane speeds in the distance. Is it just a meteor, or something far more valuable?.."))
	sleep(20 SECONDS)
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, SPAN_ERPBOLD("Giving the unidentified shining guest a bit more attention, you can clearly predict that it will crash into mountains if left uncontrolled. Looks like there will be nothing to salvage."))
	sleep(10 SECONDS)
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, SPAN_ERPBOLD("It looks like it somehow changes course, albeit very slowly... What the hell?"))
	sleep(32 SECONDS)
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, SPAN_ERPBOLD("The plasma that once covered the approaching vessel is now gone, leaving only glowing heat exposure marks that can be clearly seen after its unexpected turn in your direction."))
	//INSERT ATMOSPHERE MANEUVERING SOUNDS
	//INSERT DIRECT RADIO COMMS TO BUNKER MESSAGING SYSTEM
	sleep(9 SECONDS)
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, "<span class=bigdanger>In what seems to be a controlled descent, the giant space faring vessel is coming down almost directly at the vast even ground where you stand. It's piloted, there are people on it! You are saved!</span>")
	//INSERT SUBTLE ATMOSPHERE GLOW
	sleep(9 SECONDS)
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, "<span class=bigdanger>The sky roars as a gigantic ship with glowing-red hull falls through the clouds right above you, you can notice large colored 'UN Destiny' logos and heat damage all over it. The engines on its underside blaze fire, it's heading for landing!</span>")
		H.playsound_local(H.loc, 'sound/effects/ignition.ogg', 100, 0)
	//INSERT PARTICLE EFFECTS HERE
	sleep(9 SECONDS)
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, "<span class=bigdanger>It won't slow down in time!</span>")
	sleep(6 SECONDS)
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, "<span class=bigdanger>It's gone...</span>")
		H.playsound_local(H.loc, 'sound/effects/explosionfar.ogg', 50, 0)
	for(var/area/surface/A in surface_areas)
		A.do_ambience = TRUE
	//INSERT DEBRIS GENERATION HERE
	end()