var/global/list/vehicle_entrypoints = list()
var/global/list/vehicles = list()

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
	var/obj/effect/vehicle_entrypoint/entrypoint = null
	var/interior_template = null
	var/mob/living/carbon/human/controlling = null
	var/active = 0

/obj/multitile_vehicle/proc/set_bound_box()
	if(active)
		density = 0
	else
		density = 1

/obj/multitile_vehicle/Initialize()
	. = ..()
	var/datum/map_template/templ = SSmapping.get_template(interior_template)
	var/turf/place = templ.load_interior_level()

	STOP_PROCESSING(SSobj, src)
	global.vehicles += src
	entrypoint = vehicle_entrypoints[uid][global.vehicles.Find(src)]
	entrypoint.vehicle = src
	if(!templ.pilot_seat_offset)
		return

	for(var/obj/structure/bed/chair/comfy/vehicle/pilotseat in view(2, locate(place.x-templ.width+templ.pilot_seat_offset["x"], place.y-templ.height+templ.pilot_seat_offset["y"], place.z)))
		if(pilotseat)
			pilotseat.vehicle = src

/obj/multitile_vehicle/attack_hand(mob/user)
	. = ..()
	if(entrypoint)
		user.forceMove(entrypoint.loc)

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

/obj/effect/vehicle_entrypoint
	var/uid
	var/obj/multitile_vehicle/vehicle = null

/obj/effect/vehicle_entrypoint/attack_hand(mob/user)
	. = ..()
	if(vehicle)
		user.forceMove(vehicle.loc)

/obj/effect/vehicle_entrypoint/New(loc, ...)
	. = ..()
	if(uid)
		check_and_place_if_list_dosnt_have_entry(vehicle_entrypoints, uid)
		vehicle_entrypoints[uid] += src

/obj/effect/vehicle_entrypoint/Destroy()
	if(uid)
		vehicle_entrypoints[uid].Remove(src)
	. = ..()



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