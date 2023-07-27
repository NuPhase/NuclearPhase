/datum/event/light_check	//NOTE: Times are measured in master controller ticks!
	announceWhen		= 5

/datum/event/light_check/start()
	for(var/obj/machinery/light/L in SSmachines.machinery)
		if(L.on)
			L.on = FALSE
			L.update_icon(0)
			spawn(1 MINUTE)
				L.on = TRUE
				L.update_icon(0)

	for(var/obj/machinery/door/airlock/D in SSmachines.machinery)
		D.close()
		if(!D.locked)
			D.lock()
			spawn(20 SECONDS)
				D.unlock()

/datum/event/light_check/announce()
	command_announcement.Announce(replacetext("Mandatory load spreading system reboot commenced..", "%STATION_NAME%", station_name()), "Lights Out", new_sound = global.using_map.grid_check_sound, zlevels = affecting_z)
