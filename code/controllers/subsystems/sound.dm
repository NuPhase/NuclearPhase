SUBSYSTEM_DEF(zonesound)
	name = "Zone Sounds"
	wait = 5 SECONDS
	priority = SS_PRIORITY_SOUND
	flags = SS_BACKGROUND | SS_NO_INIT

/datum/controller/subsystem/zonesound/fire(resumed)
	for(var/zone/zone as anything in SSair.zones)
		zone.update_ambience()