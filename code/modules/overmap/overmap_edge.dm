var/global/list/overmap_edges = list()

/obj/effect/overmap_edge //SHOULD ALWAYS BE POINTED INWARDS TO THE MAP
	name = "sector edge"
	icon = 'icons/effects/static.dmi'
	icon_state = "2 moderate"
	density = 1
	opacity = 1
	anchored = 1
	var/edge_id = ""
	var/teleport_to_id = ""

/obj/effect/overmap_edge/Initialize()
	. = ..()
	overmap_edges[edge_id] = src

/obj/effect/overmap_edge/attack_hand(mob/M)
	. = ..()
	if(!teleport_to_id)
		return
	var/obj/effect/overmap_edge/ov_edge = overmap_edges[teleport_to_id]
	if(ov_edge)
		var/turf/T = ov_edge.loc
		M.forceMove(T)

/obj/effect/overmap_edge/Cross(A)
	. = ..()
	if(!teleport_to_id)
		return
	var/obj/effect/overmap_edge/ov_edge = overmap_edges[teleport_to_id]
	if(ov_edge)
		var/turf/T = ov_edge.loc
		if(ismob(A))
			var/mob/M = A
			M.forceMove(T)
		if(isobj(A))
			var/obj/O = A
			O.forceMove(T)
