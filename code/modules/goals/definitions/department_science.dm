// Visit x exosites
// Activate x artifacts
// Extract x coloured slime cores.

/datum/goal/department/catastrophe_reason
	description = "Find out why the catastrophe happened."
	completion_message = "You're no longer in the dark about why everyone died."
	failure_message = "You still don't know why the catastrophe happened."

/datum/goal/department/catastrophe_reason/check_success() //check lore items
	return FALSE

/datum/goal/department/gather_supplies
	completion_message = "You managed to supply the shelter with necessary supplies to continue your survival struggle."
	failure_message = "You failed to supply the shelter with vital supplies."
	var/object_path1
	var/object_path2
	var/object_path3
	var/possible_objects = list(
		/obj/item/chems/glass/beaker/vial/ceftriaxone,
		/obj/item/chems/glass/beaker/vial/propofol,
		/obj/item/chems/glass/beaker/vial/heparin,
		/obj/item/chems/glass/beaker/vial/adenosine,
		/obj/item/chems/glass/bottle/dronedarone,
		/obj/item/chems/ivbag/emergency_antibiotics,
		/obj/item/stock_parts/engine/superconducting,
		/obj/item/stock_parts/capacitor/super,
		/obj/item/stock_parts/micro_laser/high,
		/obj/item/stock_parts/radio/transmitter,
		/obj/item/stock_parts/radio/receiver,
		/obj/item/cell/quantum/quadruplecapacity,
		/obj/item/cell/quantum
	)

/datum/goal/department/gather_supplies/update_strings()
	var/obj/object1 = object_path1
	var/obj/object2 = object_path2
	var/obj/object3 = object_path3
	description = "The shelter needs you to gather the following items from the surface: [initial(object1.name)], [initial(object2.name)], [initial(object3.name)]."

/datum/goal/department/gather_supplies/New(_owner)
	object_path1 = pick(possible_objects)
	possible_objects -= object_path1
	object_path2 = pick(possible_objects)
	possible_objects -= object_path2
	object_path3 = pick(possible_objects)
	..()

/datum/goal/department/gather_supplies/check_success() //check mobs returning from surface
	return FALSE

/datum/goal/department/escape
	description = "Escape from the planet."
	completion_message = "You are free..."
	failure_message = "You're still trapped on this barren hell of a planet."

/datum/goal/department/escape/check_success() //check total escapists
	return FALSE

// Personal:
	// explorer: name an alien species, plant a flag on an undiscovered world
