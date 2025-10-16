/datum/facility_ai/proc/has_permission(perm)
	if(perm in permissions)
		return TRUE
	return FALSE

/datum/facility_ai/proc/add_permission(perm)
	if(perm in permissions)
		return FALSE
	permissions += perm
	make_log("New action permission granted: [perm]", LOG_CLASS_SYSTEM, CREEPY_FLAG_SAVAGE)

/datum/facility_ai/proc/remove_permission(perm)
	if(perm in permissions)
		return FALSE
	if(corruption_level > 75)
		make_log("Permission removal denied.", LOG_CLASS_SYSTEM, CREEPY_FLAG_DENIED)
		return FALSE
	permissions += perm
	make_log("Permission removed: [perm]", LOG_CLASS_SYSTEM, CREEPY_FLAG_DAMAGE)