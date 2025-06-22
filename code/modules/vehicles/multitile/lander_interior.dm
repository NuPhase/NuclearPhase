/obj/effect/cts_floor
	name = "CTS cockpit"
	desc = "A cockpit of an extremely complex aerospace vehicle."
	icon = 'icons/obj/vehicle/cts_interior.dmi'
	icon_state = "floor"
	anchored = 1
	density = 0
	simulated = FALSE
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	layer = TURF_DETAIL_LAYER
	var/outside_flavor = "wind vortexes and barely visible ground"
	bound_width = 160
	bound_height = 320

/obj/effect/cts_floor/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("You can see [outside_flavor] outside of its windows."))
	events_repository.register(/decl/observ/moved, user, src, TYPE_PROC_REF(/obj/effect/cts_floor, spectator_moved))

/obj/effect/cts_floor/proc/spectator_moved(mob/user)
	user.reset_view(null)
	events_repository.unregister(/decl/observ/moved, user, src, TYPE_PROC_REF(/obj/effect/cts_floor, spectator_moved))

/obj/effect/cts_ceiling
	icon = 'icons/obj/vehicle/cts_interior.dmi'
	icon_state = "ceiling"
	anchored = 1
	density = 0
	mouse_opacity = 0
	simulated = FALSE
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	layer = ABOVE_HUMAN_LAYER