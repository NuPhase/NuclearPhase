/obj/structure/barrel
	name = "barrel"
	desc = "Can contain liquid, or... Humans?"
	icon_state = "barrel_open"
	var/datum/gas_mixture/internal = new
	var/volume = 115 //average barrel
	var/open = TRUE
	var/is_acidic = FALSE
	var/mob/contained = null

/obj/structure/barrel/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	internal.volume = volume

/obj/structure/barrel/update_icon()
	. = ..()
	if(open)
		if(!internal.gas)
			if(contained)
				icon_state = "barrel_open_empty_human"
				return
			icon_state = "barrel_open_empty"
			return
		if(contained)
			icon_state = "barrel_open_human"
			return
		icon_state = "barrel_open"
	else
		icon_state = "barrel_closed"

/obj/structure/barrel/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		var/mob/living/affecting_mob = G.get_affecting_mob()
		if(internal.volume < HUMAN_BODY_VOLUME)
			to_chat(user, SPAN_DANGER("[affecting_mob] won't fit inside of \the [src]!"))
			return
		user.visible_message(SPAN_DANGER("[user] starts putting [affecting_mob] into \the [src]!"))
		if(!do_after(user, 50, src))
			return
		user.visible_message(SPAN_DANGER("[user] puts [affecting_mob] into \the [src]!"))
		affecting_mob.forceMove(src)
		contained = affecting_mob
		START_PROCESSING(SSobj, src)
		is_acidic = internal.is_acidic()
		internal.volume = internal.volume - HUMAN_BODY_VOLUME
		internal.update_values()
	..()

/obj/structure/barrel/attack_hand(mob/user)
	. = ..()
	if(contained)
		user.visible_message(SPAN_DANGER("[user] starts pulling [contained] out of \the [src]!"))
		if(!do_after(user, 50, src))
			return
		user.visible_message(SPAN_DANGER("[user] pulls [contained] out of \the [src]!"))
		contained.forceMove(src.loc)
		contained = null
		STOP_PROCESSING(SSobj, src)
		internal.volume = volume
		internal.update_values()

/obj/structure/barrel/Process()
	internal.touch(contained)
	if(is_acidic)
		playsound(src, 'sound/effects/gurgle1.ogg', 50, 1)

/obj/structure/barrel/verb/toggle_cover()
	set name = "Toggle Cover"
	set category = "Object"
	set src in usr

	if(!istype(src.loc,/mob/living)) return

	if(open)
		usr.visible_message(SPAN_NOTICE("[usr] puts a cover on [src]"))
		open = FALSE
	else
		usr.visible_message(SPAN_NOTICE("[usr] removes the cover from [src]"))
		open = TRUE

