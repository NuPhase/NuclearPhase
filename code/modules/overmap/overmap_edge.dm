var/global/list/overmap_edges = list()
#define OVERMAP_MOVE_DELAY 2 SECONDS

/atom/movable
	var/overmap_lastmove = 0

/obj/effect/overmap_edge
	name = "sector edge"
	icon = 'icons/effects/static.dmi'
	icon_state = "2 moderate"
	color = COLOR_SKY_BLUE
	density = 0
	opacity = 1
	anchored = 1
	var/edge_id = ""
	var/teleport_to_id = ""
	var/lastmove = 0
	var/vehicle_only = FALSE

/obj/effect/overmap_edge/Initialize()
	. = ..()
	var/list/edge_list = overmap_edges[edge_id]
	if(edge_list)
		edge_list += src
	else
		overmap_edges[edge_id] = list(src)

/obj/effect/overmap_edge/attack_hand(mob/M)
	. = ..()
	if(vehicle_only)
		to_chat(M, SPAN_NOTICE("It's too far, you'll need a vehicle to travel there."))
		return
	if(!teleport_to_id)
		return
	if(M.overmap_lastmove + OVERMAP_MOVE_DELAY > world.time)
		return
	var/obj/effect/overmap_edge/ov_edge = pick(overmap_edges[teleport_to_id])
	if(ov_edge)
		M.overmap_lastmove = world.time
		var/turf/T = ov_edge.loc
		M.forceMove(T)
		return TRUE

/obj/effect/overmap_edge/Cross(var/atom/movable/A)
	. = ..()
	if(vehicle_only && !istype(A, /obj/multitile_vehicle))
		if(ismob(A))
			to_chat(A, SPAN_NOTICE("It's too far, you'll need a vehicle to travel there."))
		return
	if(!teleport_to_id)
		return
	if(A.overmap_lastmove + OVERMAP_MOVE_DELAY > world.time)
		return
	var/obj/effect/overmap_edge/ov_edge = pick(overmap_edges[teleport_to_id])
	if(ov_edge)
		var/turf/T = ov_edge.loc
		if(ismob(A))
			var/mob/M = A
			A.overmap_lastmove = world.time
			M.forceMove(T)
		if(isobj(A))
			var/obj/O = A
			A.overmap_lastmove = world.time
			O.forceMove(T)
		return TRUE
