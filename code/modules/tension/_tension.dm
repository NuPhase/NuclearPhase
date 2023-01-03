/mob/living/carbon/human
	var/local_tension = 0

/datum/tension_processor
	var/process_cooldown = 50

/datum/tension_processor/New()
	. = ..()
	process()

/datum/tension_processor/proc/process()
	recalculate_tension()
	spawn(50)
		process()

/datum/tension_processor/proc/recalculate_tension()
	var/tension_sum = 0
	var/tension_count = 0
	for(var/mob/living/carbon/human/H in human_mob_list)
		tension_sum += Clamp(H.local_tension, 0, 100)
		tension_count += 1
	tension = tension_sum / tension_count