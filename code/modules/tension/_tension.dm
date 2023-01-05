/mob/living/carbon/human
	var/local_tension = 0

/datum/tension_processor
	var/process_cooldown = 50
	var/thought_cooldown = 600
	var/process_thoughts = TRUE

/datum/tension_processor/New()
	. = ..()
	process()

/datum/tension_processor/proc/process()
	recalculate_tension()
	process_tension_events()
	spawn(50)
		process()

/datum/tension_processor/proc/recalculate_tension()
	var/tension_sum = 0
	var/tension_count = 0
	for(var/mob/living/carbon/human/H in human_mob_list)
		tension_sum += Clamp(H.local_tension, 0, 100)
		tension_count += 1
	tension = tension_sum / tension_count

/datum/tension_processor/proc/process_tension_events()
	if(process_thoughts)
		process_thoughts()
		process_thoughts = FALSE
		spawn(thought_cooldown)
			process_thoughts = TRUE
	return

/datum/tension_processor/proc/process_thoughts()
	var/thought = ""
	if(tension < 25)
		thought = "<span class='rose'>[pick(good_thoughts)]</span>"
	else
		if(tension > 75)
			thought = "<span class='warning'>[pick(bad_thoughts)]</span>"
	for(var/mob/living/carbon/human/H in human_mob_list)
		to_chat(H, thought)

/datum/tension_processor/proc/process_ambience()
	return