#define MOOD_DIFFICULTY_EASY "easy"
#define MOOD_DIFFICULTY_MEDIUM "medium"
#define MOOD_DIFFICULTY_HARD "hard"
#define MOOD_DIFFICULTY_UNBELIVEABLE "unbeliveable"
SUBSYSTEM_DEF(moods)
	name = "Moods"
	init_order = SS_INIT_MISC_LATE
	wait = 10 SECONDS
	var/list/moods = list()
	var/list/moods_by_initializer = list()
	var/list/moods_by_events = list()
	var/list/random_given_moods = list()
	var/list/moods_by_difficulty = list()

/datum/controller/subsystem/moods/Initialize(start_timeofday)
	filter_moods()

/datum/controller/subsystem/moods/fire(resumed)
	check_timeout()
	process_moods()

/datum/controller/subsystem/moods/proc/filter_moods()
	var/gettenmoods = subtypesof(/datum/mood)
	for(var/moodtype in gettenmoods)
		var/datum/mood/mood = new moodtype(null)

		if(mood.initializer)
			moods_by_initializer = check_and_place_if_list_dosnt_have_entry(moods_by_initializer, mood.initializer)
			moods_by_initializer[mood.initializer] += mood.type
			moods_by_initializer[mood.initializer][mood.type] = mood.init_chance

		for(var/event in mood.eventnames)
			moods_by_events = check_and_place_if_list_dosnt_have_entry(moods_by_events, event)
			moods_by_events[event] += mood.type

		moods_by_difficulty = check_and_place_if_list_dosnt_have_entry(moods_by_difficulty, mood.difficulty)
		moods_by_difficulty[mood.difficulty] += mood.type

		if(mood.randomgive)
			random_given_moods = check_and_place_if_list_dosnt_have_entry(random_given_moods, mood.difficulty)
			random_given_moods[mood.difficulty] += mood.type

		qdel(mood)

/datum/controller/subsystem/moods/proc/check_timeout()
	var/checktime = world.time
	for(var/datum/mood/mood in moods)
		if(!mood.timeout)
			continue
		if(checktime > mood.timeout)
			mood.timeout_cb()

/datum/controller/subsystem/moods/proc/process_moods()
	for(var/datum/mood/mood in moods)
		if(prob(5)) // give some anarchy to it
			mood.affect()

/datum/controller/subsystem/moods/proc/call_mood_event(var/eventname, var/list/args_, var/list/HM)
	if(!initialized)
		return
	if(!moods_by_events.Find(eventname))
		return null
	for(var/datum/mood/mood in moods)
		if(!(mood.type in moods_by_events[eventname]))
			continue
		if(length(HM) && !(mood.holder in HM))
			continue
		mood.by_event(args_)

/datum/controller/subsystem/moods/proc/mass_mood_give(var/triggername, var/list/mob/living/carbon/human/mobs)
	if(!initialized)
		return
	if(!moods_by_initializer.Find(triggername))
		return null
	var/list/datum/mood/initmoods = moods_by_initializer[triggername]

	for(var/mob/living/carbon/human/H in mobs)
		for(var/mood in initmoods)
			if(prob(initmoods[mood]))
				H.add_mood(mood)

/datum/controller/subsystem/moods/proc/reset_all_moods()
	var/list/cached_moods = moods
	for(var/datum/mood/mood in cached_moods)
		mood.holder.remove_mood(mood.type)

/datum/controller/subsystem/moods/proc/make_initial_mood(var/mob/living/carbon/human/H)
	if(!initialized)
		return
	var/list/moods_to_give = list()
	switch(rand(1, 100))
		if(1 to 29)
			moods_to_give = null
		if(30 to 60)
			moods_to_give += pick(random_given_moods[MOOD_DIFFICULTY_EASY])
			if(prob(20))
				moods_to_give += pick(random_given_moods[MOOD_DIFFICULTY_EASY])
		if(61 to 90)
			moods_to_give += pick(random_given_moods[MOOD_DIFFICULTY_MEDIUM])
			if(prob(30))
				moods_to_give += pick(random_given_moods[MOOD_DIFFICULTY_MEDIUM])
			else if(prob(5))
				moods_to_give += pick(random_given_moods[MOOD_DIFFICULTY_HARD])
		if(91 to 100)
			moods_to_give += pick(random_given_moods[MOOD_DIFFICULTY_HARD])
			if(prob(5))
				moods_to_give += pick(random_given_moods[MOOD_DIFFICULTY_UNBELIVEABLE])

	if(!moods_to_give)
		return

	for(var/mood in moods_to_give)
		H.add_mood(mood)

/datum/mood
	var/name = "Basic mood"
	var/description = "You must not to see that"
	var/mob/living/carbon/human/holder = null
	var/initializer = null
	var/list/eventnames = list()
	var/init_chance = 0 // percents
	var/timeout = null // null if not deleted after the time spend, number of second after give if must delete
	var/randomgive = FALSE
	var/difficulty = MOOD_DIFFICULTY_MEDIUM

/datum/mood/New(var/mob/living/carbon/human/H)
	holder = H
	if(timeout)
		timeout = world.time + timeout

/datum/mood/proc/init()
	return

/datum/mood/proc/on_remove()
	return !isnull(holder)

/datum/mood/proc/by_event(var/list/args_)
	return !isnull(holder)

/datum/mood/proc/affect()
	return !isnull(holder)

/datum/mood/proc/timeout_cb() // on child must be called after you changes
	if(holder)
		holder.remove_mood(src.type)

/mob/proc/add_mood(var/datum/mood/moodtype)
	return

/mob/proc/remove_mood(var/datum/mood/moodtype)
	return

/mob/proc/get_mood(var/datum/mood/moodtype)
	return

/mob/living/carbon/human/proc/debug_roundstart_moods()
	SSmoods.make_initial_mood(src)

/mob/living/carbon/human/add_mood(var/datum/mood/moodtype)
	var/datum/mood/mood = get_mood(moodtype)
	if(!mood)
		moodtype = new moodtype(src)
		moodtype.init()
		moods += moodtype
		SSmoods.moods += moodtype
	else if (mood && mood.timeout)
		mood.timeout = initial(mood.timeout) + world.time

/mob/living/carbon/human/remove_mood(var/datum/mood/moodtype)
	var/datum/mood/mood = get_mood(moodtype)
	if(mood)
		mood.on_remove()
		moods -= mood
		SSmoods.moods -= mood
		qdel(mood)

/mob/living/carbon/human/get_mood(var/datum/mood/moodtype)
	for (var/datum/mood/mood in moods)
		if(mood.type != moodtype)
			continue
		return mood
	return null

