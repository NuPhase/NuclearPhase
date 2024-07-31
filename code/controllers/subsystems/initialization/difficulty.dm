SUBSYSTEM_DEF(difficulty)
	name = "Difficulty"
	init_order = SS_INIT_DIFFICULTY
	flags = SS_NO_FIRE | SS_NO_INIT
	var/list/difficulty_affected_objs = list()

/datum/controller/subsystem/difficulty/Initialize()
	for(var/obj/O in difficulty_affected_objs)
		if(prob(SSticker.mode.difficulty * O.failure_chance))
			O.fail_roundstart()