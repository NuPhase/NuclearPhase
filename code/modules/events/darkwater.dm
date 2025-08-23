/datum/event/darkwater	//NOTE: Times are measured in master controller ticks!
	announceWhen		= 1

/datum/event/darkwater/announce()
	command_announcement.Announce("Unknown biological signatures detected in the lower levels of the facility. Security intervention requested.", "Biohazard", new_sound = 'sound/misc/redalert1.ogg', zlevels = affecting_z)