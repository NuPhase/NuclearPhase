/datum/event/solar_storm
	startWhen				= 120
	announceWhen			= 1
	var/const/rad_interval 	= 5  	//Same interval period as radiation storms.
	var/const/temp_incr     = 100
	var/const/fire_loss     = 40
	var/base_solar_gen_rate


/datum/event/solar_storm/setup()
	endWhen = startWhen + rand(30,90) + rand(30,90) //2-6 minute duration

/datum/event/solar_storm/announce()
	command_announcement.Announce("DANGER: ABNORMAL CORONAL MASS EJECTION IN BINARY STAR #[round(rand(1,2))]. EXPECT SOLAR STORM ARRIVAL IN: 2 MINUTES.", zlevels = affecting_z)
	var/panicker_name = "[pick(first_names_male)] [pick(last_names)]"
	var/explainer_name = "[pick(first_names_female)] [pick(last_names)]"
	spawn(10 SECONDS)
		radio_announce("Damn...", panicker_name)
	spawn(20 SECONDS)
		radio_announce("How much radiation gets to whoever's outside?..", panicker_name)
	spawn(30 SECONDS)
		radio_announce("It varies... Density of the atmosphere, temperature, our distance to the star. But generally, anyone on the surface will get hit by about 2 hundred roentgen in a span of a minute.", explainer_name)
	spawn(45 SECONDS)
		radio_announce("So they're basically cooked alive...", panicker_name)
	spawn(1 MINUTE)
		command_announcement.Announce("Expect total communication blackout in: 40 seconds.", zlevels = affecting_z)
	spawn(80 SECONDS)
		radio_announce("Well, they'll be on their own. Let's hope for the best.", explainer_name)
	spawn(100 SECONDS)
		for(var/obj/machinery/telecomms/T in telecomms_list)
			if(T.z in affecting_z)
				if(prob(T.outage_probability))
					T.overloaded_for = max(severity * rand(90, 120), T.overloaded_for)

/datum/event/solar_storm/proc/adjust_solar_output(var/mult = 1)
	if(isnull(base_solar_gen_rate)) base_solar_gen_rate = solar_gen_rate
	solar_gen_rate = mult * base_solar_gen_rate


/datum/event/solar_storm/start() //They're almost certainly dead if they're outside, so make a show for them
	for(var/mob/living/carbon/human/H in surface_mobs)
		to_chat(H, "<span class=bigdanger>Everything around you suddenly lights up, like a million lights in a dark living room. It starts to grow hot, you see flashes in your eyes, it can't be good...</span>")
	adjust_solar_output(5)
	for(var/area/A in surface_areas)
		A.background_radiation = 473.9

/datum/event/solar_storm/tick()
	if(activeFor % rad_interval == 0)
		for(var/mob/living/carbon/human/H in surface_mobs)
			if(prob(60))
				H.flash_eyes(99)

/datum/event/solar_storm/end()
	adjust_solar_output()
	for(var/area/A in surface_areas)
		A.background_radiation = initial(A.background_radiation)

//For a false alarm scenario.
/datum/event/solar_storm/syndicate/adjust_solar_output()
	return
