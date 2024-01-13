//base type for controllers of two-door systems
/obj/machinery/embedded_controller/radio/decontamination_airlock
	// Setup parameters only
	program = /datum/computer/file/embedded_program/decont_airlock
	base_type = /obj/machinery/embedded_controller/radio/decontamination_airlock
	var/tag_exterior_door
	var/tag_interior_door

/obj/machinery/embedded_controller/radio/decontamination_airlock/Initialize()
	. = ..()
	var/datum/computer/file/embedded_program/decont_airlock/cprogram = program
	cprogram.tag_exterior_door = tag_exterior_door
	cprogram.tag_interior_door = tag_interior_door

/obj/machinery/embedded_controller/radio/decontamination_airlock/physical_attack_hand(user)
	. = ..()
	var/datum/computer/file/embedded_program/decont_airlock/cprogram = program
	cprogram.decontaminate()