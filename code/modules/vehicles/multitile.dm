var/global/list/interior_entrypoints = list()
var/global/list/vehicles = list()

/obj/item/ignition_key
	name = "key"
	desc = "key from something..."
	icon = 'icons/obj/items/key.dmi'
	icon_state = "keys"
	w_class = ITEM_SIZE_TINY
	var/parent
	var/insert_sound = 'sound/items/key.ogg'

/obj/ignition_switch
	name = "ignition"
	anchored = 1
	icon = 'icons/obj/power.dmi'
	icon_state = "light0-flat"
	layer = ABOVE_WINDOW_LAYER
	var/obj/multitile_vehicle/aerial/vehicle
	var/delay = 2 SECONDS
	var/state = FALSE
	var/action_sounds = list(
	'sound/machines/button1.ogg',
	'sound/machines/button2.ogg',
	'sound/machines/button3.ogg',
	'sound/machines/button4.ogg'
	)
	var/ignition_sound = 'sound/items/ignition.ogg'
	var/obj/item/ignition_key/key

/obj/ignition_switch/New(loc, ...)
	. = ..()
	key = new(null)
	key.parent = src

/obj/ignition_switch/verb/eject_key()
	set name = "Eject ignition key"
	set category = "Object"
	set src in range(1)

	if(!key)
		to_chat(usr, SPAN_WARNING("There is no key!"))
		return

	if(vehicle.active)
		to_chat(usr, SPAN_WARNING("You must turn off the vehicle before eject a key!"))
		return

	if(isliving(usr))
		var/mob/living/M = usr
		M.put_in_hands(key)
		key = null

/obj/ignition_switch/attackby(obj/item/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/ignition_key))
		var/obj/item/ignition_key/K = O
		var/mob/living/M = user
		if(K.parent != src)
			to_chat(user, SPAN_WARNING("This key doesnt fit..."))
			return
		if(do_after(user, 5))
			playsound(loc, K.insert_sound, 100, 1)
			M.drop_from_inventory(K)
			K.forceMove(null)
			key = K

/obj/ignition_switch/attack_hand(user)
	. = ..()
	if(!key)
		to_chat(user, SPAN_WARNING("You need a key to inginte the motor!"))
		return
	if(!state)
		playsound(loc, ignition_sound, 50, 3)
	if(do_after(user, delay))
		state = !state
		do_action(user)
		if(action_sounds)
			playsound(loc, pick(action_sounds), 50, 1)

/obj/ignition_switch/proc/do_action(mob/user)
	if(state)
		vehicle.liftoff()
	else
		vehicle.land()

/obj/multitile_vehicle
	name = "vehicle"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "cargo_engine"
	layer = ABOVE_HUMAN_LAYER
	density = 1
	anchored = 1
	light_range = 3
	animate_movement = 1
	var/speed_x = 0
	var/speed_y = 0
	var/acceleration = 1 //pixels per input
	var/uid
	var/obj/effect/interior_entrypoint/vehicle/entrypoint = null
	var/interior_template = null
	var/mob/living/carbon/human/controlling = null
	var/active = FALSE
	var/movingZ = FALSE
	var/obj/ignition_switch/ignition
	var/ignition_switch_offset

/obj/multitile_vehicle/proc/set_bound_box()
	if(active)
		density = 0
	else
		density = 1

/obj/multitile_vehicle/Initialize()
	. = ..()
	spawn(0)
		var/datum/map_template/templ = SSmapping.get_template(interior_template)
		var/turf/place = templ.load_interior_level()

		STOP_PROCESSING(SSobj, src)
		global.vehicles += src
		entrypoint = interior_entrypoints[uid][global.vehicles.Find(src)]
		entrypoint.vehicle = src
		if(!templ.pilot_seat_offset)
			return

		for(var/obj/structure/bed/chair/comfy/vehicle/pilotseat in view(2, locate(place.x-templ.width+templ.pilot_seat_offset["x"], place.y-templ.height+templ.pilot_seat_offset["y"], place.z)))
			if(pilotseat)
				pilotseat.vehicle = src

		if(ignition_switch_offset)
			ignition = new(locate(place.x-templ.width+ignition_switch_offset["x"], place.y-templ.height+ignition_switch_offset["y"], place.z))
			ignition.vehicle = src
/obj/multitile_vehicle/attack_hand(mob/user)
	. = ..()
	if(entrypoint)
		user.forceMove(entrypoint.loc)

/obj/multitile_vehicle/grab_attack(var/obj/item/grab/G)
	var/mob/user = G.assailant
	user.visible_message(SPAN_WARNING("[user] is trying to put [G.affecting] into [src]"))
	if(!do_after(user, 5 SECONDS))
		return
	G.affecting.forceMove(entrypoint.loc)
	G.current_grab.let_go(G)

/obj/multitile_vehicle/aerial
	dir = NORTH
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	pixel_step_size = 1
	var/drag_multiplier = 0.99

/obj/multitile_vehicle/aerial/proc/liftoff()
	START_PROCESSING(SSvehicles, src)
	active = TRUE
	set_bound_box()

/obj/multitile_vehicle/aerial/proc/land()
	STOP_PROCESSING(SSvehicles, src)
	active = FALSE
	speed_x = 0
	speed_y = 0
	set_bound_box()

/obj/multitile_vehicle/aerial/Process()
	if(speed_x < 3 && speed_x > -3)
		speed_x = 0
		Move(loc, 0, 0, round(speed_y))
	if(speed_y < 3 && speed_y > -3)
		speed_y = 0
		Move(loc, 0, round(speed_x), 0)
	process_inertia()
	var/new_step_x = step_x + round(speed_x)
	var/new_step_y = step_y + round(speed_y)
	var/turf/newloc

	if(new_step_x > 32)
		newloc = get_step(loc, EAST)
	else if(new_step_x < -32)
		newloc = get_step(loc, WEST)
	if(new_step_y > 32)
		newloc = get_step(loc, NORTH)
	else if(new_step_y < -32)
		newloc = get_step(loc, SOUTH)
	if(!newloc)
		newloc = get_turf(src)
		Move(newloc, 0, new_step_x, new_step_y)
		return
	Move(newloc, 0, 0, 0)
	if(controlling)
		animate(controlling.client, pixel_x = round(speed_x), pixel_y = round(speed_y), time = 1, easing = LINEAR_EASING)

/obj/multitile_vehicle/aerial/proc/process_inertia()
	speed_x *= drag_multiplier
	speed_y *= drag_multiplier

/obj/effect/interior_entrypoint
	var/uid

/obj/effect/interior_entrypoint/New(loc, ...)
	. = ..()
	if(uid)
		check_and_place_if_list_dosnt_have_entry(interior_entrypoints, uid)
		interior_entrypoints[uid] += src

/obj/effect/interior_entrypoint/Destroy()
	if(uid)
		interior_entrypoints[uid] -= src
	. = ..()

/obj/effect/interior_entrypoint/vehicle
	var/obj/multitile_vehicle/vehicle = null

/obj/effect/interior_entrypoint/vehicle/attack_hand(mob/user)
	. = ..()
	if(vehicle)
		user.forceMove(vehicle.loc)

/obj/effect/interior_entrypoint/vehicle/grab_attack(var/obj/item/grab/G)
	if(!vehicle)
		return

	var/mob/user = G.assailant
	user.visible_message(SPAN_WARNING("[user] is trying to eject [G.affecting] from [src]"))
	if(!do_after(user, 5 SECONDS))
		return
	G.affecting.forceMove(vehicle.loc)
	G.current_grab.let_go(G)

/obj/structure/bed/chair/comfy/vehicle
	name = "pilot seat"
	desc = "A comfortable, secure seat. It has a sturdy-looking buckling system for smoother flights."
	icon_state = "shuttle_chair"
	buckle_sound = 'sound/effects/metal_close.ogg'
	material = /decl/material/solid/metal/titanium
	has_special_overlay = TRUE
	var/obj/multitile_vehicle/vehicle = null

/obj/structure/bed/chair/comfy/vehicle/post_buckle_mob()
	if(buckled_mob)
		icon_state = "shuttle_chair-b"
	else
		icon_state = "shuttle_chair"

	. = ..()

	if(!vehicle)
		return

	if(!buckled_mob)
		if(vehicle.controlling.client)
			vehicle.controlling.client.pixel_x = 0
			vehicle.controlling.client.pixel_y = 0
			vehicle.controlling.reset_view(null)
		vehicle.controlling = null
	else
		if(buckled_mob.stat == DEAD)
			unbuckle_mob()
			return
		vehicle.controlling = buckled_mob
		if(buckled_mob && buckled_mob.client)
			vehicle.controlling.reset_view(vehicle)

/obj/structure/bed/chair/comfy/vehicle/handle_buckled_relaymove(var/datum/movement_handler/mh, var/mob/mob, var/direction, var/mover)
	. = MOVEMENT_HANDLED
	if(!vehicle.active)
		return
	if(!mob.has_held_item_slot())
		return // No hands to drive your vehicle? Tough luck!
	//drunk driving
	direction = mob.AdjustMovementDirection(direction, mover)
	switch(direction)
		if(NORTH)
			if(vehicle.speed_y < 4)
				vehicle.speed_y += 3
			vehicle.speed_y += vehicle.acceleration
		if(SOUTH)
			if(vehicle.speed_y > -4)
				vehicle.speed_y -= 3
			vehicle.speed_y -= vehicle.acceleration
		if(EAST)
			if(vehicle.speed_x < 4)
				vehicle.speed_x += 3
			vehicle.speed_x += vehicle.acceleration
		if(WEST)
			if(vehicle.speed_x > -4)
				vehicle.speed_x -= 3
			vehicle.speed_x -= vehicle.acceleration
		if(SOUTHWEST)
			vehicle.speed_x -= vehicle.acceleration
			vehicle.speed_y -= vehicle.acceleration
		if(SOUTHEAST)
			vehicle.speed_x += vehicle.acceleration
			vehicle.speed_y -= vehicle.acceleration
		if(NORTHWEST)
			vehicle.speed_x -= vehicle.acceleration
			vehicle.speed_y += vehicle.acceleration
		if(NORTHEAST)
			vehicle.speed_x += vehicle.acceleration
			vehicle.speed_y += vehicle.acceleration
		if(UP)
			if(vehicle.movingZ)
				to_chat(mob, SPAN_WARNING("You cant move that fast!"))
				return
			vehicle.movingZ = TRUE
			vehicle.visible_message(SPAN_WARNING("[vehicle] prepares to move upwards!"))
			src.visible_message(SPAN_WARNING("[vehicle] prepares to move upwards!"))
			var/time = rand(1 SECOND, 5 SECONDS)
			spawn(time)
				var/turf/T = get_turf(vehicle.loc)
				var/turf/target = get_step(GetAbove(T), dir)
				if(T.CanZPass(vehicle, UP) && target.Enter(vehicle))
					vehicle.forceMove(target)
				vehicle.movingZ = FALSE
		if(DOWN)
			if(vehicle.movingZ)
				to_chat(mob, SPAN_WARNING("You cant move that fast!"))
				return
			vehicle.movingZ = TRUE
			vehicle.visible_message(SPAN_WARNING("[vehicle] prepares to move downwards!"))
			src.visible_message(SPAN_WARNING("[vehicle] prepares to move downwards!"))
			var/time = rand(1 SECOND, 5 SECONDS)
			spawn(time)
				var/turf/T = get_turf(vehicle.loc)
				var/turf/target = get_step(GetBelow(T), dir)
				if(T.CanZPass(vehicle, DOWN) && target.Enter(vehicle))
					vehicle.forceMove(target)
				vehicle.movingZ = FALSE

/obj/Cross(O) // fuck that shit im out
	return TRUE