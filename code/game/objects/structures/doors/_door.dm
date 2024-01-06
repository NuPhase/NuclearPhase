/obj/structure/door
	name = "door"
	icon = 'icons/obj/doors/thin/preview.dmi'
	icon_state = "NO_STATE"
	hitsound = 'sound/weapons/genhit.ogg'
	maxhealth = 240
	density =  TRUE
	anchored = TRUE
	opacity =  TRUE

	var/datum/lock/lock

	var/has_window = FALSE
	var/changing_state = FALSE
	var/sliding = FALSE //whether the door opens the classic way or slides into the frame
	var/open_sound = 'sound/machines/doors/default_door.ogg'
	var/icon_base
	var/door_sound_volume = 50

	var/frame_type = "default"
	var/door_type = "default"
	var/handle_type

/obj/structure/door/Initialize()
	. = ..()
	if(lock)
		lock = new /datum/lock(src, lock)
	icon_state = "NO_STATE"
	update_icon()
	update_nearby_tiles(need_rebuild = TRUE)
	if(material?.luminescence)
		set_light(material.luminescence, 0.5, material.color)

/obj/structure/door/Destroy()
	update_nearby_tiles()
	QDEL_NULL(lock)
	return ..()

/obj/structure/door/get_material_health_modifier()
	. = 10

/obj/structure/door/on_update_icon(var/animate_sliding = FALSE, var/sliding_direction) //sliding direction either takes -1 or 1
	..()
	cut_overlays()
	var/list/overlay_list = list()
	overlay_list += image('icons/obj/doors/thin/frame.dmi', icon_state = frame_type, dir = dir, layer = ABOVE_HUMAN_LAYER)
	if(!density || animate_sliding)
		if(dir == EAST || dir == WEST)
			if(!sliding)
				overlay_list += image('icons/obj/doors/thin/body.dmi', icon_state = "[door_type]", layer = CLOSED_DOOR_LAYER, pixel_x = -13, pixel_y = 8)
		else
			if(!sliding)
				overlay_list += image('icons/obj/doors/thin/body.dmi', icon_state = "[door_type]_open", layer = CLOSED_DOOR_LAYER)
			else
				overlay_list += image('icons/obj/doors/thin/body.dmi', icon_state = "[door_type]", layer = OPEN_DOOR_LAYER, pixel_x = -23)
	else
		if(!(dir == EAST || dir == WEST))
			overlay_list += image('icons/obj/doors/thin/body.dmi', icon_state = door_type, layer = CLOSED_DOOR_LAYER)
		if(handle_type)
			overlay_list += image('icons/obj/doors/thin/handle.dmi', icon_state = handle_type, dir = dir, layer = ABOVE_DOOR_LAYER)
	add_overlay(overlay_list)

/obj/structure/door/proc/post_change_state()
	update_nearby_tiles()
	update_icon()
	changing_state = FALSE

/obj/structure/door/attack_hand(mob/user)
	return density ? open() : close()

/obj/structure/door/proc/close()
	set waitfor = 0
	if(!can_close())
		return FALSE
	playsound(src, open_sound, door_sound_volume, 1)

	changing_state = TRUE
	sleep(0.4 SECOND)
	set_density(TRUE)
	set_opacity(!has_window && material.opacity > 0.5)
	post_change_state()
	return TRUE

/obj/structure/door/proc/open()
	set waitfor = 0
	if(!can_open())
		return FALSE
	playsound(src, open_sound, door_sound_volume, 1)

	changing_state = TRUE
	sleep(0.4 SECOND)
	set_density(FALSE)
	set_opacity(FALSE)
	post_change_state()
	return TRUE

/obj/structure/door/proc/can_open()
	if(lock && lock.isLocked())
		return FALSE
	return density && !changing_state

/obj/structure/door/proc/can_close()
	return !density && !changing_state

/obj/structure/door/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && lock)
		to_chat(user, SPAN_NOTICE("It appears to have a lock."))

/obj/structure/door/attack_ai(mob/living/silicon/ai/user)
	if(Adjacent(user) && isrobot(user))
		return attack_hand(user)

/obj/structure/door/explosion_act(severity)
	. = ..()
	if(!QDELETED(src))
		take_damage(100 - (severity * 3))

/obj/structure/door/can_repair(var/mob/user)
	. = ..()
	if(. && !density)
		to_chat(user, SPAN_WARNING("\The [src] must be closed before it can be repaired."))
		return FALSE

/obj/structure/door/attackby(obj/item/I, mob/user)
	add_fingerprint(user, 0, I)

	if((user.a_intent == I_HURT && I.force) || istype(I, /obj/item/stack/material))
		return ..()

	if(lock)
		if(istype(I, /obj/item/key))
			if(!lock.toggle(I))
				to_chat(user, SPAN_WARNING("\The [I] does not fit in the lock!"))
			return TRUE
		if(lock.pick_lock(I,user))
			return TRUE
		if(lock.isLocked())
			to_chat(user, SPAN_WARNING("\The [src] is locked!"))
		return TRUE

	if(istype(I,/obj/item/lock_construct))
		if(lock)
			to_chat(user, SPAN_WARNING("\The [src] already has a lock."))
		else
			var/obj/item/lock_construct/L = I
			lock = L.create_lock(src,user)
		return

	if(density)
		open()
	else
		close()

/obj/structure/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group)
		return !density
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/door/CanFluidPass(coming_from)
	return !density

/obj/structure/door/Bumped(atom/AM)
	if(!density || changing_state)
		return
	if(ismob(AM))
		var/mob/M = AM
		if(M.restrained() || issmall(M))
			return
	open()

/obj/structure/door/iron
	material = /decl/material/solid/metal/iron

/obj/structure/door/silver
	material = /decl/material/solid/metal/silver

/obj/structure/door/gold
	material = /decl/material/solid/metal/gold

/obj/structure/door/uranium
	material = /decl/material/solid/metal/uranium

/obj/structure/door/sandstone
	material = /decl/material/solid/stone/sandstone

/obj/structure/door/diamond
	material = /decl/material/solid/gemstone/diamond

/obj/structure/door/wood
	material = /decl/material/solid/wood

/obj/structure/door/mahogany
	material = /decl/material/solid/wood/mahogany

/obj/structure/door/maple
	material = /decl/material/solid/wood/maple

/obj/structure/door/ebony
	material = /decl/material/solid/wood/ebony

/obj/structure/door/walnut
	material = /decl/material/solid/wood/walnut

/obj/structure/door/cult
	material = /decl/material/solid/stone/cult

/obj/structure/door/wood/saloon
	material = /decl/material/solid/wood
	opacity = FALSE

/obj/structure/door/glass
	material = /decl/material/solid/glass

/obj/structure/door/plastic
	material = /decl/material/solid/plastic

/obj/structure/door/exotic_matter
	material = /decl/material/solid/exotic_matter

/obj/structure/door/shuttle
	material = /decl/material/solid/metal/steel
