/datum/reactor_control_system/proc/make_log(message, severity = 1) //1-3
	var/modified_message = "\[[time_stamp()]:\]: [message]"
	operation_log[modified_message] = severity