/datum/reactor_control_system/proc/switch_mode(newmode) //returns 1 if modes were switched succesfully, 0 if mode is unavailable and 2 if it is the same mode
	if(newmode == mode)
		return 2
	switch(newmode)
		if(REACTOR_CONTROL_MODE_MANUAL)
			mode = REACTOR_CONTROL_MODE_MANUAL
			do_message("MANUAL CONTROL ENGAGED", 1)
			make_log("MANUAL CONTROL ENGAGED.", 2)
			return 1
		if(REACTOR_CONTROL_MODE_SEMIAUTO)
			if(semiautocontrol_available)
				mode = REACTOR_CONTROL_MODE_SEMIAUTO
				do_message("SEMI-AUTO CONTROL ENGAGED", 1)
				make_log("SEMI-AUTO CONTROL ENGAGED.", 1)
				return 1
			else
				return 0
		if(REACTOR_CONTROL_MODE_AUTO)
			if(autocontrol_available)
				mode = REACTOR_CONTROL_MODE_AUTO
				do_message("FULL-AUTO CONTROL ENGAGED", 1)
				make_log("FULL-AUTO CONTROL ENGAGED.", 1)
				return 1
			else
				return 0

/datum/reactor_control_system/proc/switch_program(decl_path)
	if(current_running_program)
		current_running_program.end()
	var/decl/control_program/wanted_program = GET_DECL(decl_path)
	if(!wanted_program.can_initiate())
		return FALSE
	current_running_program = wanted_program
	current_running_program.initiated()
	return TRUE