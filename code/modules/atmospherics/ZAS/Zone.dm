/*

Overview:
	Each zone is a self-contained area where gas values would be the same if tile-based equalization were run indefinitely.
	If you're unfamiliar with ZAS, FEA's air groups would have similar functionality if they didn't break in a stiff breeze.

Class Vars:
	name - A name of the format "Zone [#]", used for debugging.
	invalid - True if the zone has been erased and is no longer eligible for processing.
	needs_update - True if the zone has been added to the update list.
	edges - A list of edges that connect to this zone.
	air - The gas mixture that any turfs in this zone will return. Values are per-tile with a group multiplier.

Class Procs:
	add(turf/simulated/T)
		Adds a turf to the contents, sets its zone and merges its air.

	remove(turf/simulated/T)
		Removes a turf, sets its zone to null and erases any gas graphics.
		Invalidates the zone if it has no more tiles.

	c_merge(zone/into)
		Invalidates this zone and adds all its former contents to into.

	c_invalidate()
		Marks this zone as invalid and removes it from processing.

	rebuild()
		Invalidates the zone and marks all its former tiles for updates.

	add_tile_air(turf/simulated/T)
		Adds the air contained in T.air to the zone's air supply. Called when adding a turf.

	tick()
		Called only when the gas content is changed. Archives values and changes gas graphics.

	dbg_data(mob/M)
		Sends M a printout of important figures for the zone.

*/


/zone
	var/name
	var/invalid = 0
	var/list/contents = list()
	var/list/fire_tiles = list()
	var/needs_update = 0
	var/list/edges = list()
	var/datum/gas_mixture/air = new
	var/list/graphic_add = list()
	var/list/graphic_remove = list()
	var/last_air_temperature = TCMB
	var/condensing = TRUE

	var/last_movable_calc = 0 //last world.time of movables indexation
	var/list/movables = list()

/zone/New()
	SSair.add_zone(src)
	air.temperature = T20C
	air.group_multiplier = 1
	air.volume = CELL_VOLUME
	spawn(5 SECONDS)
		condensing = FALSE

/zone/proc/add(turf/simulated/T)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(!SSair.has_valid_zone(T))
#endif

	var/datum/gas_mixture/turf_air = T.return_air()
	add_tile_air(turf_air)
	T.zone = src
	contents.Add(T)
	if(T.fire)
		fire_tiles.Add(T)
		SSair.active_fire_zones |= src
	T.update_graphic(air.graphic)

/zone/proc/remove(turf/simulated/T)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(T.zone == src)
	soft_assert(T in contents, "Lists are weird broseph")
#endif
	contents.Remove(T)
	fire_tiles.Remove(T)
	T.zone = null
	T.update_graphic(graphic_remove = air.graphic)
	if(contents.len)
		air.group_multiplier = length(contents)
	else
		c_invalidate()

/zone/proc/c_merge(zone/into)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(into))
	ASSERT(into != src)
	ASSERT(!into.invalid)
#endif
	c_invalidate()
	for(var/turf/simulated/T in contents)
		into.add(T)
		T.update_graphic(graphic_remove = air.graphic)
		#ifdef ZASDBG
		T.dbg(merged)
		#endif

	//rebuild the old zone's edges so that they will be possessed by the new zone
	for(var/connection_edge/E in edges)
		if(E.contains_zone(into))
			continue //don't need to rebuild this edge
		for(var/turf/T in E.connecting_turfs)
			SSair.mark_for_update(T)

/zone/proc/c_invalidate()
	invalid = 1
	SSair.remove_zone(src)
	#ifdef ZASDBG
	for(var/turf/simulated/T in contents)
		T.dbg(invalid_zone)
	#endif

/zone/proc/rebuild()
	set waitfor = 0
	if(invalid) return //Short circuit for explosions where rebuild is called many times over.
	c_invalidate()
	for(var/turf/simulated/T in contents)
		T.update_graphic(graphic_remove = air.graphic) //we need to remove the overlays so they're not doubled when the zone is rebuilt
		//T.dbg(invalid_zone)
		T.needs_air_update = 0 //Reset the marker so that it will be added to the list.
		SSair.mark_for_update(T)
		CHECK_TICK

/zone/proc/add_tile_air(datum/gas_mixture/tile_air)
	//air.volume += CELL_VOLUME
	air.group_multiplier = 1
	air.multiply(length(contents), FALSE)
	air.merge(tile_air, FALSE)
	air.divide(length(contents)+1, FALSE)
	air.group_multiplier = length(contents)+1
	air.update_values()

/zone/proc/tick()

	// Update fires.
	if(air.temperature >= FLAMMABLE_GAS_FLASHPOINT && !(src in SSair.active_fire_zones) && air.check_combustibility() && length(contents))
		var/turf/T = pick(contents)
		if(istype(T))
			T.create_fire(vsc.fire_firelevel_multiplier)

	// Update gas overlays.
	if(air.check_tile_graphic(graphic_add, graphic_remove))
		for(var/turf/simulated/T in contents)
			T.update_graphic(graphic_add, graphic_remove)
			CHECK_TICK
		graphic_add.len = 0
		graphic_remove.len = 0

	// Update connected edges.
	for(var/connection_edge/E in edges)
		if(E.sleeping)
			E.recheck()
			CHECK_TICK

	// Update movables list
	if(last_movable_calc < world.time + 6 SECONDS)
		INVOKE_ASYNC(src, PROC_REF(cache_movables))

	// Handle condensation from the air.
	if(!condensing && air.total_moles)
		handle_condensation()

	// Update atom temperature.
	if(abs(air.temperature - last_air_temperature) >= ATOM_TEMPERATURE_EQUILIBRIUM_THRESHOLD)
		last_air_temperature = air.temperature
		for(var/turf/T as anything in contents)
			for(var/atom/check_atom as anything in T.contents)
				QUEUE_TEMPERATURE_ATOM(check_atom)
			CHECK_TICK

//#define CONDENSATION_DEBUG

/zone/proc/handle_condensation()

	condensing = TRUE
	var/area/checking = get_area(pick(contents))
	if(!checking.should_condense)
		return //this will stop further condensation processing

	for(var/g in air.liquids)
		var/decl/material/mat = GET_DECL(g)
		var/condense_amt = air.liquids[g] * air.group_multiplier
		var/reagent_condense_amt = condense_amt * mat.molar_volume
		if(reagent_condense_amt < FLUID_PUDDLE)
			break
		var/condensing_iterations = reagent_condense_amt/FLUID_PUDDLE
		var/condense_amt_per_iteration = reagent_condense_amt/condensing_iterations
		for(var/i=0, i <= condensing_iterations, i++)
			var/turf/flooding = pick(contents)
			var/obj/effect/fluid/F = locate() in flooding
			if(!F) F = new(flooding)
			F.temperature = air.temperature-1
			F.reagents.add_reagent(g, condense_amt_per_iteration)
		#ifdef CONDENSATION_DEBUG
		to_world("******CONDENSATION DEBUG******")
		to_world("Condensed [mat.name]")
		to_world("Conditions: Temperature: ([air.temperature]) Pressure: ([air.return_pressure()]) Moles: ([air.total_moles])")
		#endif
		air.liquids[g] = 0
		CHECK_TICK
	for(var/g in air.solids)
		for(var/i=0, i < length(contents)*0.1, i++)
			if(!air.solids[g])
				break // no more gas to condense
			var/turf/T = pick(contents)
			var/obj/effect/decal/cleanable/dirt/spawned_dust = locate() in T
			if(!spawned_dust)
				spawned_dust = new(T)
			var/decl/material/mat = GET_DECL(g)
			var/condense_amt = min(air.gas[g], rand(min(air.gas[g], 255), 255))
			if(condense_amt < 1)
				break
			air.adjust_gas(g, -condense_amt)
			spawned_dust.alpha = min(spawned_dust.alpha + (condense_amt*5), 255)
			spawned_dust.color = mat.color
			var/area/A = get_area(T)
			A.background_radiation += mat.radioactivity * condense_amt * 0.01
		CHECK_TICK
		air.solids[g] = 0

	condensing = FALSE

/zone/proc/dbg_data(mob/M)
	to_chat(M, name)
	for(var/g in air.gas)
		var/decl/material/mat = GET_DECL(g)
		to_chat(M, "[capitalize(mat.gas_name)]: [air.gas[g]]")
	to_chat(M, "P: [air.return_pressure()] kPa V: [air.volume]L T: [air.temperature]°K ([air.temperature - T0C]°C)")
	to_chat(M, "O2 per N2: [(air.gas[/decl/material/gas/nitrogen] ? air.gas[/decl/material/gas/oxygen]/air.gas[/decl/material/gas/nitrogen] : "N/A")] Moles: [air.total_moles]")
	to_chat(M, "Simulated: [contents.len] ([air.group_multiplier])")
//	to_chat(M, "Unsimulated: [unsimulated_contents.len]")
//	to_chat(M, "Edges: [edges.len]")
	if(invalid) to_chat(M, "Invalid!")
	var/zone_edges = 0
	var/space_edges = 0
	var/space_coefficient = 0
	for(var/connection_edge/E in edges)
		if(E.type == /connection_edge/zone) zone_edges++
		else
			space_edges++
			space_coefficient += E.coefficient
			to_chat(M, "[E:air:return_pressure()]kPa")

	to_chat(M, "Zone Edges: [zone_edges]")
	to_chat(M, "Space Edges: [space_edges] ([space_coefficient] connections)")

	//for(var/turf/T in unsimulated_contents)
//		to_chat(M, "[T] at ([T.x],[T.y])")
