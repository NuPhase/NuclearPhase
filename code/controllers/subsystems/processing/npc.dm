PROCESSING_SUBSYSTEM_DEF(npc)
	name = "Npcs"
	priority = SS_PRIORITY_AI
	wait = 3
	process_proc = TYPE_PROC_REF(/datum/npc_controller, trigger)
	init_order = SS_INIT_DEFAULT
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING

/datum/controller/subsystem/processing/npc/Initialize(timeofday)