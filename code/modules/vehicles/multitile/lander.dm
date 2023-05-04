/datum/map_template/lander
	name = "Lander enterior"
	width = 7
	height = 12
	mappaths = list("maps/_interiors/lander_interior.dmm")
	template_categories = list(MAP_TEMPLATE_CATEGORY_INTERIORS)
	pilot_seat_offset = list("x"=2, "y"=9)

/obj/effect/interior_entrypoint/vehicle/lander
	uid = "CTS"
	icon = 'icons/obj/doors/doorint.dmi'
	icon_state = "pdoor1"
	pixel_y = -32

/datum/composite_sound/cts
	start_sound = 'sound/vehicle/cts/loopstart.ogg'
	start_length = 140
	mid_sounds = list('sound/vehicle/cts/loopmid.ogg')
	mid_length = 130
	volume = 30
	sfalloff = 3

/datum/composite_sound/cts_interior
	start_sound = 'sound/vehicle/cts/apu_start.ogg'
	start_length = 200
	mid_sounds = list('sound/vehicle/cts/apu_loop.ogg')
	mid_length = 55
	volume = 10
	sfalloff = 10

/obj/multitile_vehicle/aerial/lander
	name = "Cargo Transport System"
	desc = "Right before you stands a giant, the same one that sent many souls to the stars. The bright 'UN' and 'CTS' logos shine all throughout its hull, which has yet to be ravaged by the elements. Four of its huge engine thrust structures stand tall, towering above you in their glory. It doesn't look space-worthy at all, but that's probably because of the old stigma and untold stories."
	icon = 'icons/obj/vehicle/cts.dmi'
	icon_state = "undamaged"
	uid = "CTS"
	weight = 21200 //dry mass //recalculated //gotta make optimisations
	drag_multiplier = 0.95
	interior_template = "Lander enterior"

	var/fuel_tank_volume = 9 //m3
	var/has_updated_navigation = FALSE
	var/has_thrust_vanes = FALSE
	var/has_shielding = TRUE

	var/datum/composite_sound/cts/soundloop
	var/datum/composite_sound/cts_interior/soundloop_interior

	pixel_x = -100
	pixel_y = -100
	bound_x = -60
	bound_y = -60
	bound_width = 156
	bound_height = 156

	maxspeed = 48

/obj/multitile_vehicle/aerial/lander/Bump(atom/A)
	. = ..()
	if(istype(A, /mob/living/carbon/human))
		visible_message(SPAN_DANGER("[src] collides with [A]!"))
		var/mob/living/carbon/human/H = A
		H.handle_collision(src, move_vector.get_hipotynuse() / WORLD_ICON_SIZE)

/obj/multitile_vehicle/aerial/lander/liftoff()
	. = ..()
	playsound(src, 'sound/vehicle/cts/ignition.ogg', 100)
	soundloop_interior = new(list(entrypoint), TRUE)
	spawn(30)
		soundloop = new(list(src), TRUE)

/obj/multitile_vehicle/aerial/lander/land()
	. = ..()
	QDEL_NULL(soundloop)
	QDEL_NULL(soundloop_interior)

/obj/structure/bed/chair/comfy/vehicle/cts/verb/liftoff()
	set name = "Takeoff"
	set category = "CTS Control"
	set src in oview(1)
	if(!vehicle.active)
		var/obj/multitile_vehicle/aerial/lander/cur_vehicle = vehicle
		cur_vehicle.liftoff()

/obj/structure/bed/chair/comfy/vehicle/cts/verb/land()
	set name = "Land"
	set category = "CTS Control"
	set src in oview(1)
	if(vehicle.active)
		var/obj/multitile_vehicle/aerial/lander/cur_vehicle = vehicle
		cur_vehicle.land()

/obj/structure/bed/chair/comfy/vehicle/cts/verb/methane_injection()
	set name = "Toggle Methane Injection"
	set category = "CTS Control"
	set src in oview(1)

/obj/structure/bed/chair/comfy/vehicle/cts/verb/sonar()
	set name = "Toggle Sonar"
	set category = "CTS Control"
	set src in oview(1)

/obj/structure/bed/chair/comfy/vehicle/cts/verb/window_tint()
	set name = "Tint Windows"
	set category = "CTS Control"
	set src in oview(1)