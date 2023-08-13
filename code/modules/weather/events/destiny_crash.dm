var/global/obj/abstract/landmark/heighttag/HHH

/obj/abstract/landmark/heighttag
	name = "height_tag"

/obj/abstract/landmark/heighttag/Initialize()
	. = ..()
	HHH = src

/datum/map_template/destiny
	name = "Destiny surface"
	width = 127
	height = 50
	mappaths = list("maps/overmap_locs/crashed_destiny.dmm")
	template_categories = list(MAP_TEMPLATE_CATEGORY_SURFACE)

/datum/map_template/destiny/preload()
	return TRUE

/datum/weather_event/destiny_crash
	auto_trigger = TRUE
	override_all = TRUE

/datum/weather_event/destiny_crash/start()
	..()
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
	radio_announce("TO ALL WHO'S NEARBY- w* a** comi** *own!", "UN Destiny")
	sleep(32 SECONDS)
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, SPAN_ERPBOLD("The plasma that once covered the approaching vessel is now gone, leaving only glowing heat exposure marks that can be clearly seen after its unexpected turn in your direction."))
	radio_announce("AIRING A*L STATIO*S, WE ARE AT*EMPTING * CONTROL*-ED DESCENT. CLEAR THE AREA IM--**DIATELY!", "UN Destiny")
	spawn(50)
		radio_announce("REPEAT, CLEAR *- AREA IMMEDIATE*!", "UN Destiny")
	//INSERT ATMOSPHERE MANEUVERING SOUNDS
	sleep(10 SECONDS)
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, "<span class=bigdanger>In what seems to be a controlled descent, the giant space faring vessel is coming down almost directly at the vast even ground where you stand. It's piloted, there are people on it! You are saved!</span>")
	//INSERT SUBTLE ATMOSPHERE GLOW
	sleep(9 SECONDS)
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, "<span class=bigdanger>The sky roars as a gigantic ship with glowing-red hull falls through the clouds right above you, you can notice large colored 'UN Destiny' logos and heat damage all over it. The engines on its underside blaze fire, it's heading for landing!</span>")
		H.playsound_local(H.loc, 'sound/effects/ignition.ogg', 100, 0)
	radio_announce("WE SUF-ERED S*V*RE DAMAGE, PREP-*RE RESCUE PERSONNEL.", "UN Destiny")
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

	var/list/nonsurface_mobs = human_mob_list
	for(var/mob/living/carbon/human/H in surface_mobs)
		nonsurface_mobs -= H
	for(var/mob/living/carbon/human/H in nonsurface_mobs)
		if(H.job == "Office Clerk")
			nonsurface_mobs -= H
			continue
		to_chat(H, "<span class=bigdanger>The whole shelter shook in place, like something massive exploded nearby!</span>")
		H.playsound_local(H.loc, 'sound/effects/explosionfar.ogg', 50, 0)
		shake_camera(H, 10, 2)

	var/datum/map_template/templ = SSmapping.get_template("Destiny surface")
	templ.load(locate(1, 1, HHH.z))

	end()