PROCESSING_SUBSYSTEM_DEF(cellauto)
	name  = "Cellular Automata"
	wait  = 0.05 SECONDS
	priority = SS_PRIORITY_CELLAUTO
	flags = SS_NO_INIT
	process_proc = TYPE_PROC_REF(/datum/automata_cell, update_state)