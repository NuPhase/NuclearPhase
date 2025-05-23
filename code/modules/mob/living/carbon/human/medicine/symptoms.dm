/datum/health_condition
	var/name = "NULL CONDITION"
	var/description = "You shouldn't see this."

/datum/health_condition/dynamic // Has a severity variable, which influences the symptoms.
	var/severity = 50 //0-100