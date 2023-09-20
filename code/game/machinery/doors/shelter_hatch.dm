/obj/machinery/shelter_hatch
	name = "shelter blast hatch"
	desc = "A massive blast door that keeps the nature at bay."
	anchored = TRUE
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	icon = 'icons/obj/doors/shelter_hatch.dmi'
	icon_state = "closed"

/obj/machinery/shelter_hatch/small
	name = "blast hatch"
	desc = "A smaller blast door for a human to fit through."
	anchored = TRUE
	icon = 'icons/obj/doors/shelter_hatch_small.dmi'
	icon_state = "open"

/obj/machinery/shelter_hatch/small/closed
	icon_state = "closed"
	density = 1