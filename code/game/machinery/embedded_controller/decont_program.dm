/datum/computer/file/embedded_program/decont_airlock
	var/tag_exterior_door
	var/tag_interior_door
	var/direction = FALSE // yep
	var/decontaminating = FALSE

/datum/computer/file/embedded_program/decont_airlock/proc/decontaminate()
	if(decontaminating)
		return
	decontaminating = TRUE
	var/list/range_list = range(7, get_turf(master))
	if(direction)
		close_doors(range_list, tag_exterior_door)
	else
		close_doors(range_list, tag_interior_door)
	sleep(2 SECONDS)
	for(var/obj/machinery/atmospherics/binary/decontaminator/cur_decont in range_list)
		cur_decont.activate()
	sleep(5 SECONDS)
	if(!direction)
		open_doors(range_list, tag_exterior_door)
	else
		open_doors(range_list, tag_interior_door)
	sleep(3 SECONDS)
	direction = !direction
	decontaminating = FALSE

/datum/computer/file/embedded_program/decont_airlock/proc/open_doors(range_list, door_tag)
	for(var/obj/machinery/door/D in range_list)
		if(D.id_tag == door_tag)
			spawn()
				D.open()

/datum/computer/file/embedded_program/decont_airlock/proc/close_doors(range_list, door_tag)
	for(var/obj/machinery/door/D in range_list)
		if(D.id_tag == door_tag)
			spawn()
				D.close()