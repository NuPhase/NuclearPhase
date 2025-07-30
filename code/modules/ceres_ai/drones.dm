/datum/facility_ai/proc/add_target(mob/new_target)
	for(var/mob/living/simple_animal/robot/drone)
		if(!drone.our_ai)
			continue
		drone.our_ai.target_list |= weakref(new_target)
	make_log("New target acquired: [new_target.real_name]", LOG_CLASS_DRONES, CREEPY_FLAG_COMBAT)

/datum/facility_ai/proc/remove_target(mob/new_target)
	for(var/mob/living/simple_animal/robot/drone)
		if(!drone.our_ai)
			continue
		drone.our_ai.target_list -= weakref(new_target)
	make_log("Target removed: [new_target.real_name]", LOG_CLASS_DRONES, CREEPY_FLAG_COMBAT)

/datum/facility_ai/proc/engage_drones()
	for(var/mob/living/simple_animal/robot/drone)
		drone.activate()

/datum/facility_ai/proc/disengage_drones()
	for(var/mob/living/simple_animal/robot/drone)
		drone.deactivate()


/datum/facility_ai/proc/add_drone(var/mob/living/simple_animal/robot/drone)
	combat_drones += drone

/datum/facility_ai/proc/remove_drone(var/mob/living/simple_animal/robot/drone)
	combat_drones -= drone
	make_log("Unit connection lost. Units left: [length(combat_drones)]", LOG_CLASS_DRONES, CREEPY_FLAG_DAMAGE)