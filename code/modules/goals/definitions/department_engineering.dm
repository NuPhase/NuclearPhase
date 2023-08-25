/datum/goal/department/turbine_trips
	description = "Avoid damage to the turbines by not causing them to trip."
	completion_message = "You managed to avoid a turbine trip."
	failure_message = "The turbines tripped and suffered some damage."

/datum/goal/department/turbine_trips/check_success() //check SSstat
	return !SSstatistics.turbines_tripped

/datum/goal/department/electrical_deaths
	description = "Don't let anyone die because of electric shock."
	completion_message = "No one was stupid enough to touch uninsulated cables."
	failure_message = "Someone died in the honor of Nicola Tesla."

/datum/goal/department/electrical_deaths/check_success() //check SSstat
	return !SSstatistics.person_shocked

/datum/goal/department/malfunctions
	description = "Some equipment is malfunctioning. Find the issues and fix them."
	completion_message = "You found issues in NAME, NAME and NAME and fixed them."
	failure_message = "You failed to restore the technical integrity of the shelter."

/datum/goal/department/malfunctions/check_success() //check SSstat
	return FALSE