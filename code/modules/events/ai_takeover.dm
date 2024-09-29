/datum/event/ai_takeover	//NOTE: Times are measured in master controller ticks!
	announceWhen		= 1

/datum/event/ai_takeover/start()
	spawn(20 SECONDS)
		for(var/mob/living/simple_animal/robot/our_robot)
			our_robot.activate()

/datum/event/ai_takeover/announce()
	command_announcement.Announce("Unknown AI presence detected in facility combat drones.", "AI Takeover", new_sound = 'sound/misc/redalert1.ogg', zlevels = affecting_z)