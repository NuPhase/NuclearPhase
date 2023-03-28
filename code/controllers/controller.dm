/datum/controller
	var/name
	// The object used for the clickable stat() button.
	var/atom/movable/statclick/debug/statclick
	var/statNext = 0

/datum/controller/proc/Initialize()

//cleanup actions
/datum/controller/proc/Shutdown()

//when we enter dmm_suite.load_map
/datum/controller/proc/StartLoadingMap()

//when we exit dmm_suite.load_map
/datum/controller/proc/StopLoadingMap()

/datum/controller/proc/Recover()

/datum/controller/proc/stat_entry(text)
	if (!statclick)
		statclick = new (null, "Initializing...", src)
	if (istext(text))
		statclick.name = text
	stat(name, statclick)

/datum/controller/proc/PreventUpdateStat(time)
	if (!isnum(time))
		time = Uptime()
	if (time < statNext)
		return TRUE
	statNext = time + 2 SECONDS
	return FALSE
