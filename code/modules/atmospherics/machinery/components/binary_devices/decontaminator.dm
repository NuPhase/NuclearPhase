/obj/machinery/atmospherics/binary/decontaminator
	name = "decontaminator"
	desc = "A large water atomizer. Atomized water dissolves contaminants on clothing and in air."
	icon = 'icons/obj/atmospherics/components/binary/decontaminator.dmi'
	icon_state = "static"
	anchored = TRUE
	layer = STRUCTURE_LAYER
	density = 1
	uncreated_component_parts = null
	construct_state = /decl/machine_construction/default/panel_closed
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_WATER

/obj/machinery/atmospherics/binary/decontaminator/proc/activate()
	var/turf/T = get_turf(src)
	playsound(T, 'sound/machines/decontaminator.ogg', 25)
	cell_smoke(T, 4, /obj/effect/effect/smoke/decontamination)
	var/datum/gas_mixture/environment = T.return_air()
	var/datum/gas_mixture/filtered = air1.remove(500)
	for(var/g in environment.gas)
		if(environment.phases[g] == MAT_PHASE_SOLID)
			filtered.adjust_gas(g, environment.gas[g], FALSE)
			environment.adjust_gas(g, environment.gas[g] * -1, FALSE)
		filtered.update_values()
		environment.update_values()
	air2.merge(filtered)