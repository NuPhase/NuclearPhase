/datum/weather_event
	var/auto_trigger = FALSE
	var/ongoing = FALSE
	var/override_all = FALSE

/datum/weather_event/proc/start()
	ongoing = TRUE

/datum/weather_event/proc/end()
	ongoing = FALSE
	qdel(src)