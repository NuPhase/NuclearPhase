/obj/structure/reagent_dispensers/barrel
	name = "barrel"
	desc = "Can contain liquid, or... Humans?"
	icon = 'icons/obj/barrel.dmi'
	icon_state = "barrel_closed"
	initial_capacity = 200000
	atom_flags = ATOM_FLAG_CLIMBABLE
	color = COLOR_GRAY
	var/open = FALSE
	var/mob/contained = null
	var/funnel = FALSE

/obj/structure/reagent_dispensers/barrel/can_fill()
	return funnel

/obj/structure/reagent_dispensers/barrel/get_mechanics_info()
	return "You can toggle its cover and its funnel by right clicking it. It can only be filled when it has a funnel installed."

/obj/structure/reagent_dispensers/barrel/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/chems))
		var/obj/item/chems/R = O
		R.standard_pour_into(src,user)
		return
	..()

/obj/structure/reagent_dispensers/barrel/update_icon()
	. = ..()
	cut_overlays()
	if(open)
		if(!reagents.total_volume)
			if(contained)
				icon_state = "barrel_open_empty_human"
				return
			else
				icon_state = "barrel_open_empty"
			return
		var/overlay_state = "barrel_open"
		if(contained)
			overlay_state = "barrel_open_human"
		var/image/fluid_overlay = image(icon, icon_state = overlay_state)
		fluid_overlay.color = reagents.get_color()
		add_overlay(fluid_overlay)
	else
		icon_state = "barrel_closed"

/obj/structure/reagent_dispensers/barrel/grab_attack(obj/item/grab/G)
	if(!open)
		return
	if(contained)
		return
	var/mob/living/user = G.assailant
	var/mob/living/affecting_mob = G.get_affecting_mob()
	user.visible_message(SPAN_DANGER("[user] starts putting [affecting_mob] into \the [src]!"))
	if(!do_after(user, 50, src))
		return
	user.visible_message(SPAN_DANGER("[user] puts [affecting_mob] into \the [src]!"))
	affecting_mob.forceMove(src)
	contained = affecting_mob
	update_icon()
	START_PROCESSING(SSobj, src)

/obj/structure/reagent_dispensers/barrel/attack_hand(mob/user)
	. = ..()
	if(contained && open)
		user.visible_message(SPAN_DANGER("[user] starts pulling [contained] out of \the [src]!"))
		if(!do_after(user, 50, src))
			return
		user.visible_message(SPAN_DANGER("[user] pulls [contained] out of \the [src]!"))
		contained.forceMove(src.loc)
		contained = null
		update_icon()
		STOP_PROCESSING(SSobj, src)

/obj/structure/reagent_dispensers/barrel/Process()
	reagents.touch_mob(contained)

/obj/structure/reagent_dispensers/barrel/verb/toggle_cover()
	set name = "Toggle Cover"
	set category = "Object"
	set src in view(1)

	if(open)
		usr.visible_message(SPAN_NOTICE("[usr] puts a cover on [src]"))
		open = FALSE
	else
		usr.visible_message(SPAN_NOTICE("[usr] removes the cover from [src]"))
		open = TRUE
	update_icon()

/obj/structure/reagent_dispensers/barrel/verb/toggle_funnel()
	set name = "Toggle Funnel"
	set category = "Object"
	set src in view(1)

	if(funnel)
		usr.visible_message(SPAN_NOTICE("[usr] removes the funnel from [src]"))
		funnel = FALSE
	else
		usr.visible_message(SPAN_NOTICE("[usr] puts a funnel on [src]"))
		funnel = TRUE
	update_icon()

/obj/structure/reagent_dispensers/barrel/water
	initial_reagent_types = list(/decl/material/liquid/water = 0.8)
	color = COLOR_PALE_BLUE_GRAY

/obj/structure/reagent_dispensers/barrel/sulphuric_acid
	initial_reagent_types = list(/decl/material/liquid/acid = 0.8)
	color = COLOR_PALE_ORANGE

/obj/structure/reagent_dispensers/barrel/cornoil
	initial_reagent_types = list(/decl/material/liquid/nutriment/cornoil = 0.6)
	color = COLOR_PALE_GREEN_GRAY