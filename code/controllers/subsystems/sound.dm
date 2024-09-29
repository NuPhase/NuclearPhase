PROCESSING_SUBSYSTEM_DEF(sound)
	name = "Sound"
	wait = 5 SECONDS
	priority = SS_PRIORITY_SOUND
	flags = SS_BACKGROUND
	flags = SS_NO_INIT
	process_proc = TYPE_PROC_REF(/area, process_ambience)