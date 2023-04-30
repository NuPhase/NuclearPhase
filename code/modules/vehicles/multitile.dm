#define ui_compass "RIGHT-1:28,CENTER:100"
#define INERTIA_DELAY 2

var/global/list/interior_entrypoints = list()
var/global/list/vehicles = list()

var/global/list/DIR2DEGREES = list(
	"[NORTH]" = 90,
	"[SOUTH]" = -90,
	"[EAST]" = 0,
	"[WEST]" = 180,
	"[NORTHEAST]" = 45,
	"[NORTHWEST]" = 135,
	"[SOUTHEAST]" = -45,
	"[SOUTHWEST]" = -135,
)

/datum/vector2/lerpdelayed/proc/lerpx(target, weight)
	x = Interpolate(x, target, weight)

/datum/vector2/lerpdelayed/proc/lerpy(target, weight)
	y = Interpolate(y, target, weight)

/obj/screen/compass_arrow
	icon = 'icons/hud/compass.dmi'
	icon_state = "arrow"

/obj/screen/compass
	name = "compass"
	icon = 'icons/hud/compass.dmi'
	icon_state = "plate"
	screen_loc = ui_compass
	var/obj/screen/compass_arrow/arrow
	var/lastspeed = 0
	var/numoffset = 6

/obj/screen/compass/New(loc, ...)
	. = ..()
	arrow = new()
	arrow.screen_loc = src.screen_loc

/obj/screen/compass/proc/draw_speed_num(var/speed)
	speed = round(speed/WORLD_ICON_SIZE*0.5, 0.1)
	lastspeed = speed
	overlays.Cut()
	if(speed > 99)
		overlays += icon(icon, "max")
		return
	var/ones = speed % 10
	var/tens = ((speed % 100) - (speed % 10)) / 10
	var/icon/onesimg = icon(icon, "[ones]")
	overlays += onesimg
	var/icon/tensimg
	if(tens)
		tensimg = icon(icon, "[tens]")
		tensimg.Shift(WEST, numoffset)
		overlays += tensimg

/obj/screen/compass/proc/update(var/degrees, var/maxspeed, var/speed = 0)
	degrees = -degrees
	var/matrix/M = matrix(between(0.4, speed/maxspeed, 1), 0, 0, 0, 1, 0)
	M.Turn(degrees)
	animate(arrow, transform = M, time = 1, easing = LINEAR_EASING)
	if(speed != lastspeed)
		draw_speed_num(speed)

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

	var/last_acceleration_time_x = 0
	var/last_acceleration_time_y = 0
	var/datum/vector2/lerpdelayed/move_vector

	var/maxspeed = 24 // max vector length
	var/acceleration = 0.3 // ppi - pixel per input
	var/movingZ = FALSE

	var/active = FALSE

	var/uid
	var/obj/effect/interior_entrypoint/vehicle/entrypoint = null
	var/interior_template = null
	var/mob/living/carbon/human/controlling = null
	var/obj/ignition_switch/ignition
	var/ignition_switch_offset
	var/obj/screen/compass/comp

/obj/multitile_vehicle/proc/set_bound_box()
	density = !active

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
			ignition.icon_rotation = 270 // насрал и мне даже не стыдно
			ignition.pixel_x = -6
			ignition.pixel_y = -4

		comp = new(null)
		move_vector = new()

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
	animate(src, pixel_y = pixel_y + 8, time = 20, easing = SINE_EASING)

/obj/multitile_vehicle/aerial/proc/land()
	STOP_PROCESSING(SSvehicles, src)
	active = FALSE
	set_bound_box()
	animate(src, pixel_y = pixel_y - 8, time = 20, easing = SINE_EASING)

/obj/multitile_vehicle/aerial/Process()
	spawn()
		process_inertia()

		var/xvel = move_vector.x
		var/yvel = move_vector.y
		var/new_step_x = round(step_x + xvel, 1)
		var/new_step_y = round(step_y + yvel, 1)

		if(!Move(get_turf(src), 0, new_step_x, new_step_y))
			move_vector.x = 0
			move_vector.y = 0

		if(controlling)
			animate(controlling.client, pixel_x = round(xvel), pixel_y = round(yvel), time = 1, easing = SINE_EASING)

/obj/multitile_vehicle/aerial/proc/process_inertia()
	if(last_acceleration_time_x + INERTIA_DELAY <= world.time)
		if(abs(move_vector.x)/maxspeed < 1-drag_multiplier)
			move_vector.x = 0
		else
			move_vector.lerpx(0, 1 - drag_multiplier)

	if(last_acceleration_time_y + INERTIA_DELAY <= world.time)
		if(abs(move_vector.y)/maxspeed < 1-drag_multiplier)
			move_vector.y = 0
		else
			move_vector.lerpy(0, 1 - drag_multiplier)

	if(controlling)
		comp.update(move_vector.get_angle(), maxspeed, move_vector.get_hipotynuse())

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
		if(ishuman(user) && vehicle.active)
			var/mob/living/carbon/human/H = user
			H.apply_fall_damage(vehicle.loc)
			to_chat(H, SPAN_DANGER("You fall out of the [vehicle]!"))

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
			vehicle.controlling.client.screen -= vehicle.comp
			vehicle.controlling.client.screen -= vehicle.comp.arrow
			vehicle.controlling.reset_view(null)
		vehicle.controlling = null
	else
		if(buckled_mob.stat == DEAD)
			unbuckle_mob()
			return
		vehicle.controlling = buckled_mob
		if(buckled_mob && buckled_mob.client)
			vehicle.controlling.reset_view(vehicle)
			vehicle.controlling.client.screen += vehicle.comp
			vehicle.controlling.client.screen += vehicle.comp.arrow

/obj/structure/bed/chair/comfy/vehicle/handle_buckled_relaymove(var/datum/movement_handler/mh, var/mob/mob, var/direction, var/mover)
	. = MOVEMENT_HANDLED
	if(!vehicle.active)
		return
	if(!mob.has_held_item_slot())
		return // No hands to drive your vehicle? Tough luck!

	//drunk driving
	direction = mob.AdjustMovementDirection(direction, mover)
	switch(direction)
		if(UP)
			do_z_move(mob, UP)
		if(DOWN)
			do_z_move(mob, DOWN)

	var/datum/vector2/force_vector = new()
	force_vector.from_angle(DIR2DEGREES["[direction]"])
	vehicle.last_acceleration_time_x = round(force_vector.x, 1) ? world.time : vehicle.last_acceleration_time_x
	vehicle.last_acceleration_time_y = round(force_vector.y, 1) ? world.time : vehicle.last_acceleration_time_y
	force_vector.x *= vehicle.acceleration
	force_vector.y *= vehicle.acceleration
	force_vector.summ(vehicle.move_vector)
	var/hip = force_vector.get_hipotynuse()
	var/max_hip = between(-vehicle.maxspeed, hip, vehicle.maxspeed)
	if(hip)
		vehicle.move_vector.x = force_vector.x / hip * max_hip
		vehicle.move_vector.y = force_vector.y / hip * max_hip


/obj/structure/bed/chair/comfy/vehicle/proc/do_z_move(var/mob/mob, var/direction)
	if(vehicle.movingZ)
		to_chat(mob, SPAN_WARNING("You cant move that fast!"))
		return
	var/turf/T = get_turf(vehicle.loc)
	if(!T.CanZPass(vehicle, direction))
		to_chat(mob, SPAN_WARNING("You cant move in that direction!"))
		return
	var/turf/target = get_step(vehicle.loc, direction)
	vehicle.movingZ = TRUE
	vehicle.visible_message(SPAN_WARNING("[vehicle] prepares to maneuver!"))
	visible_message(SPAN_WARNING("[vehicle] prepares to maneuver!"))
	var/time = rand(1 SECOND, 3 SECONDS)
	spawn(time)
		if(target.Enter(vehicle))
			vehicle.forceMove(target)
		vehicle.movingZ = FALSE
