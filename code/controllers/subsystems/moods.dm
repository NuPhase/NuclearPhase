SUBSYSTEM_DEF(moods)
	name = "Moods"
	init_order = SS_INIT_MISC_LATE
	wait = 10 SECONDS
	var/list/moods = list()
	var/list/moods_by_initializer = list()
	var/list/moods_by_events = list()

/datum/controller/subsystem/moods/Initialize(start_timeofday)
	. = ..()
	filter_moods()

/datum/controller/subsystem/moods/fire(resumed)
	. = ..()
	process_moods()

/datum/controller/subsystem/moods/proc/filter_moods()
	var/moods = subtypesof(/datum/mood)
	for(var/datum/mood/mood in moods)
		mood = new(null)
		moods_by_initializer[mood.initializer] = mood.type
		// for(var/event in mood.eventnames)
		// 	if(!moods_by_events)

		// 	moods_by_events[event] +=
		qdel(mood)

/datum/controller/subsystem/moods/proc/process_moods()
	for(var/datum/mood/mood in moods)
		mood.affect()

/datum/controller/subsystem/moods/proc/moodevent(var/eventname)



/datum/mood
	var/name = "Basic mood"
	var/description = "You must not to see that"
	var/holder = null
	var/initializer = "procname" // shitty shit
	var/list/eventnames = list()

/datum/mood/New(var/mob/living/carbon/human/H)
	holder = H

/datum/mood/proc/init()
	return

/datum/mood/proc/on_remove()
	return

/datum/mood/proc/by_event()
	return

/datum/mood/proc/affect()
	return !isnull(holder)



/mob/proc/add_mood(var/datum/mood/moodtype)
	return

/mob/proc/remove_mood(var/datum/mood/moodtype)
	return

/mob/proc/get_mood(var/datum/mood/moodtype)
	return

/mob/living/carbon/human/add_mood(var/datum/mood/moodtype)
	if(!get_mood(moodtype))
		moodtype = new(src)
		moodtype.init()
		moods += moodtype
		SSmood.moods += moodtype

/mob/living/carbon/human/remove_mood(var/datum/mood/moodtype)
	var/mood = get_mood(moodtype)
	if(mood)
		mood.on_remove()
		moods -= mood
		SSmood.moods -= moodtype
		qdel(mood)

/mob/living/carbon/human/get_mood(var/datum/mood/moodtype)
	for (mood in moods)
		if(mood.type != mood)
			continue
		return mood
	return null

