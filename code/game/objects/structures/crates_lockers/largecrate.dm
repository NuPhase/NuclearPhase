/obj/structure/largecrate
	name = "large crate"
	desc = "A hefty plastic panel crate."
	icon = 'icons/obj/storage/shipping_crates.dmi'
	icon_state = "densecrate"
	density = TRUE
	atom_flags = ATOM_FLAG_CLIMBABLE
	material = /decl/material/solid/plastic

/obj/structure/largecrate/Initialize()
	. = ..()
	for(var/obj/I in src.loc)
		if(I.density || I.anchored || I == src || !I.simulated)
			continue
		I.forceMove(src)

/obj/structure/largecrate/attack_hand(mob/user)
	to_chat(user, "<span class='notice'>You need a crowbar to pry this open!</span>")
	return

/obj/structure/largecrate/attackby(obj/item/W, mob/user)
	if(IS_CROWBAR(W))
		user.visible_message("<span class='notice'>[user] pries \the [src] open.</span>", \
							 "<span class='notice'>You pry open \the [src].</span>", \
							 "<span class='notice'>You hear dislodging plastic panels.</span>")
		physically_destroyed()
		return TRUE
	return ..()

/obj/structure/largecrate/mule
	name = "MULE crate"
	icon_state = "mulecrate"

/obj/structure/largecrate/indestructible
	color = COLOR_RED_GRAY