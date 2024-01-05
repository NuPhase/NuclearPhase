/datum/automata_cell/smoke
	// Explosions only spread outwards and don't need to know their neighbors to propagate properly
	neighbor_type = NEIGHBORS_NONE

	//Diagonal cells have a small delay when branching off from a non-diagonal cell. This helps the explosion look circular
	var/delay = 0

	var/passed_distance = 0
	var/max_distance = 1

	// Which direction is the explosion traveling?
	// Note that this will be null for the epicenter
	var/direction = null

	var/smoke_type = /obj/effect/effect/smoke

/datum/automata_cell/smoke/birth()
	new smoke_type(in_turf)

/datum/automata_cell/smoke/proc/get_propagation_dirs(reflected)
	var/list/propagation_dirs = list()

	// If the cell is the epicenter, propagate in all directions
	if(isnull(direction))
		return alldirs

	var/dir = reflected ? reverse_dir[direction] : direction

	if(dir in cardinal)
		propagation_dirs += list(dir, turn(dir, 45), turn(dir, -45))
	else
		propagation_dirs += dir

	return propagation_dirs

/datum/automata_cell/smoke/update_state(list/turf/neighbors)
	if(delay > 0)
		delay--
		return

	if(istype(in_turf, /turf/simulated/wall))
		qdel(src)
		return

	var/list/to_spread = get_propagation_dirs(reflected)
	for(var/dir in to_spread)
		if(passed_distance >= max_distance)
			return
		var/datum/automata_cell/smoke/E = propagate(dir)
		if(E)
			E.direction = dir
			//Diagonal cells have a small delay when branching off the center. This helps the explosion look circular
			if(!direction && (dir in cornerdirs))
				E.delay = 1

			E.passed_distance = passed_distance + 1

	// We've done our duty, now die pls
	qdel(src)

// I'll admit most of the code from here on out is basically just copypasta from DOREC

// Spawns a cellular automaton of an explosion
/proc/cell_smoke(turf/epicenter, max_distance=1, smoke_type=/obj/effect/effect/smoke, direction)
	if(!istype(epicenter))
		epicenter = get_turf(epicenter)

	if(!epicenter)
		return

	var/datum/automata_cell/smoke/E = new /datum/automata_cell/smoke(epicenter)
	// something went wrong :(
	if(QDELETED(E))
		return

	E.max_distance = max_distance
	E.smoke_type = smoke_type
	E.direction = direction