/datum/computer/file/embedded_program/decont_airlock
	var/tag_exterior_door
	var/tag_interior_door
	var/direction = FALSE // yep
	var/decontaminating = FALSE

/datum/computer/file/embedded_program/decont_airlock/proc/decontaminate()
	if(decontaminating)
		return
	decontaminating = TRUE
	if(direction)
		signalDoor(tag_exterior_door, list("close"))
	else
		signalDoor(tag_interior_door, list("close"))
	sleep(2 SECONDS)
	for(var/obj/machinery/atmospherics/binary/decontaminator/cur_decont in view(6))
		cur_decont.activate()
	sleep(5 SECONDS)
	if(direction)
		signalDoor(tag_exterior_door, list("open"))
	else
		signalDoor(tag_interior_door, list("open"))
	sleep(3 SECONDS)
	direction = !direction
	decontaminating = FALSE