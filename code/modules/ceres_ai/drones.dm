/datum/facility_ai/proc/add_target(mob/new_target)
	for(var/mob/living/simple_animal/robot/drone)
		if(!drone.our_ai)
			continue
		drone.our_ai.target_list |= weakref(new_target)

/datum/facility_ai/proc/remove_target(mob/new_target)
	for(var/mob/living/simple_animal/robot/drone)
		if(!drone.our_ai)
			continue
		drone.our_ai.target_list -= weakref(new_target)

/datum/facility_ai/proc/engage_drones()
	for(var/mob/living/simple_animal/robot/drone)
		drone.activate()

/datum/facility_ai/proc/disengage_drones()
	for(var/mob/living/simple_animal/robot/drone)
		drone.deactivate()