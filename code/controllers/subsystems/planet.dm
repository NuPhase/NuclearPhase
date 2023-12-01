//Here we handle weather, time, events, heat exchanging, etc.

SUBSYSTEM_DEF(planet)
	name = "Planet"
	wait = 1 MINUTE
	priority = SS_PRIORITY_PLANET
	init_order = SS_INIT_MISC_LATE

	var/list/interpolating_areas = list()
	var/surface_time = 0

/datum/controller/subsystem/planet/fire(resumed)
	. = ..()
	//first of all, handle the heating of areas
	for(var/area/avalon/A in interpolating_areas)
		var/turf/T = pick(A.contents)
		if(istype(T, /turf/simulated/wall))
			continue //yeah we'd like to not heat up a wall
		var/datum/gas_mixture/environment = T.return_air()
		var/temperature_delta = using_map.exterior_atmosphere.temperature - environment.temperature
		environment.temperature += temperature_delta * A.temperature_interpolation_coefficient
		environment.update_values()