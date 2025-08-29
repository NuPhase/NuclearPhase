/obj/structure/decor
	icon = 'icons/obj/structures/decor.dmi'
	density = TRUE
	anchored = TRUE

// Can be cut with a welding torch
/obj/structure/decor/surface
	name = "surface decor"

/obj/structure/decor/surface/beam
	name = "support beam"
	desc = "A thick support beam, one of many once supporting New Tokyo's skyscrapers."
	icon_state = "beam"

/obj/structure/decor/beam_large_vertical
	name = "support beam"
	icon = 'icons/obj/structures/decor/support_beam_large_vertical.dmi'
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	layer = ABOVE_HUMAN_LAYER