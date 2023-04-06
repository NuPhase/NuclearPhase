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

/obj/effect/cts_floor/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("You can see [outside_flavor] outside of its windows."))

/obj/effect/cts_ceiling
	icon = 'icons/obj/vehicle/cts_interior.dmi'
	icon_state = "ceiling"
	anchored = 1
	density = 0
	mouse_opacity = 0
	simulated = FALSE
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	layer = ABOVE_HUMAN_LAYER