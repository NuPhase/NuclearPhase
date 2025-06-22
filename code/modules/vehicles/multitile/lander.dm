var/global/obj/abstract/landmark/typhos_tag/typhos_alt_tag
var/global/obj/abstract/landmark/icarus_tag/icarus_alt_tag
var/global/obj/abstract/landmark/sky_tag/sky_alt_tag

/obj/abstract/landmark/typhos_tag
	name = "height_tag"

/obj/abstract/landmark/typhos_tag/Initialize()
	. = ..()
	typhos_alt_tag = src

/obj/abstract/landmark/icarus_tag
	name = "height_tag"

/obj/abstract/landmark/icarus_tag/Initialize()
	. = ..()
	icarus_alt_tag = src

/obj/abstract/landmark/sky_tag
	name = "height_tag"

/obj/abstract/landmark/sky_tag/Initialize()
	. = ..()
	sky_alt_tag = src

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
	desc = "Right before you stands a giant, the same one that sent many souls to the stars. Bright 'UN' and 'CTS' logos shine all throughout its hull, which has yet to be ravaged by the elements. Four of its huge engine thrust structures stand tall, towering above you in their glory. It doesn't look space-worthy at all, but that's probably because of the old stigma and untold stories."
	icon = 'icons/obj/vehicle/cts.dmi'
	icon_state = "undamaged"
	uid = "CTS"
	weight = 21200 //dry mass //recalculated //gotta make optimisations
	drag_multiplier = 0.95
	interior_template = "Lander enterior"

	var/fuel_tank_volume = 9 //m3
	var/filled_tank_volume = 0 //m3
	var/has_updated_navigation = FALSE
	var/has_thrust_vanes = FALSE
	var/has_shielding = FALSE

	var/orbiting = FALSE
	var/busy = FALSE
	var/orbit_altitude = 0

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
	set name = "Start Propulsion"
	set category = "CTS Control"
	set src in view(0)
	if(!vehicle.active)
		var/obj/multitile_vehicle/aerial/lander/cur_vehicle = vehicle
		cur_vehicle.liftoff()

/obj/structure/bed/chair/comfy/vehicle/cts/verb/land()
	set name = "Stop Propulsion"
	set category = "CTS Control"
	set src in view(0)
	if(vehicle.active)
		var/obj/multitile_vehicle/aerial/lander/cur_vehicle = vehicle
		cur_vehicle.land()

/obj/structure/bed/chair/comfy/vehicle/cts/verb/methane_injection()
	set name = "Toggle Methane Injection"
	set category = "CTS Control"
	set src in view(0)
	var/obj/multitile_vehicle/aerial/lander/cur_vehicle = vehicle
	if(cur_vehicle.filled_tank_volume < 2)
		to_chat(usr, SPAN_WARNING("LCH2 levels low!"))

/obj/structure/bed/chair/comfy/vehicle/cts/verb/sonar()
	set name = "Toggle Sonar"
	set category = "CTS Control"
	set src in view(0)
	to_chat(usr, SPAN_WARNING("The sonar systems do not respond!"))

/obj/structure/bed/chair/comfy/vehicle/cts/verb/window_tint()
	set name = "Tint Windows"
	set category = "CTS Control"
	set src in view(0)

/obj/structure/bed/chair/comfy/vehicle/cts/verb/orbital_ascent()
	set name = "Ascent to Orbit"
	set category = "CTS Control"
	set src in view(0)
	var/obj/multitile_vehicle/aerial/lander/cur_vehicle = vehicle
	if(cur_vehicle.orbiting || cur_vehicle.busy)
		return
	if(!cur_vehicle.has_updated_navigation)
		to_chat(usr, SPAN_WARNING("Navigation systems are outdated!"))
		return
	if(cur_vehicle.filled_tank_volume < 8)
		to_chat(usr, SPAN_WARNING("Insufficient LCH2 levels!"))
		return
	var/altitude = input(usr, "Select desired ascent altitude in KM", "Orbital Ascent") as null|num
	if(altitude != 180)
		to_chat(usr, SPAN_WARNING("There's nothing of interest there."))
		return
	visible_message(SPAN_NOTICE("FNAV states: 'Received ascent request, awaiting confirmation...'."))
	var/confirmation = tgui_alert(usr, "Are you sure you want to perform an ascent to 'Icarus'?", "Ascent and Rendezvous", list("Blast it!", "I'm a pussy..."))
	if(!confirmation || confirmation == "I'm a pussy...")
		return
	cur_vehicle.acceleration = 0
	visible_message(SPAN_NOTICE("FNAV states: 'Confirmation received, beginning automatic orbital ascent."))
	cur_vehicle.orbiting = TRUE
	cur_vehicle.entrypoint.can_use = FALSE
	sleep(50)
	cur_vehicle.visible_message(SPAN_DANGER("\The [cur_vehicle] blasts off right in front of you!"))
	animate(cur_vehicle, alpha = 0, 20)
	spawn(20)
		QDEL_NULL(cur_vehicle.soundloop)
		cur_vehicle.forceMove(get_turf(sky_alt_tag))
	visible_message(SPAN_WARNING("The whole vehicle jolts as it fires up its nuclear engines!"))
	var/list/play_sound_to = list()
	for(var/mob/living/carbon/human/H in view(9, src))
		play_sound_to += H
		shake_camera(H, 2, 4)
		if(H != cur_vehicle.controlling && prob(10))
			H.vomit()
	ascent_loop = new(play_sound_to, TRUE, TRUE)
	spawn(20 SECONDS)
		for(var/mob/living/carbon/human/H in play_sound_to)
			H.playsound_local(get_turf(H), 'sound/vehicle/cts/lift_rattle_high.wav', 200, 0)
	spawn(40 SECONDS)
		ascent_loop.mid_sounds = list('sound/vehicle/cts/lift_low.wav')
		for(var/mob/living/carbon/human/H in play_sound_to)
			H.playsound_local(get_turf(H), 'sound/vehicle/cts/lift_rattle_medium.wav', 200, 0)
	spawn(60 SECONDS)
		for(var/mob/living/carbon/human/H in play_sound_to)
			H.playsound_local(get_turf(H), 'sound/vehicle/cts/lift_rattle_low.wav', 200, 0)
	sleep(10)
	for(var/mob/living/carbon/human/H in view(9, src))
		shake_camera(H, 1200, 0.2)
	sleep(30 SECONDS)
	QDEL_NULL(ascent_loop)
	visible_message(SPAN_WARNING("The main engines shut down, transitioning into idle mode."))
	cur_vehicle.acceleration = 0.1
	cur_vehicle.entrypoint.can_use = TRUE
	cur_vehicle.forceMove(get_turf(icarus_alt_tag))
	animate(cur_vehicle, alpha = 255, 20, easing = SINE_EASING)

/obj/structure/bed/chair/comfy/vehicle/cts
	var/datum/composite_sound/cts_ascent/ascent_loop = null

/datum/composite_sound/cts_ascent
	start_sound = 'sound/vehicle/cts/lift_burst.wav'
	start_length = 3
	mid_sounds = list('sound/vehicle/cts/lift_high.wav')
	mid_length = 99
	volume = 30
	sfalloff = 9

//Ascent takes 4 minutes. Average acceleration is 3G
/obj/structure/bed/chair/comfy/vehicle/cts/verb/ascent_to_altitude()
	set name = "Ascent to Altitude"
	set category = "CTS Control"
	set src in view(0)
	var/obj/multitile_vehicle/aerial/lander/cur_vehicle = vehicle
	if(cur_vehicle.orbiting || cur_vehicle.busy)
		return
	if(!cur_vehicle.has_updated_navigation)
		to_chat(usr, SPAN_WARNING("Navigation systems are outdated!"))
	if(cur_vehicle.filled_tank_volume < 8)
		to_chat(usr, SPAN_WARNING("Insufficient LCH2 levels!"))
	var/altitude = input(usr, "Select desired ascent altitude in KM", "Orbital Ascent") as null|num
	if(altitude != 170)
		to_chat(usr, SPAN_WARNING("There's nothing of interest there."))
		return
	visible_message(SPAN_NOTICE("FNAV states: 'Received ascent request, awaiting confirmation...'."))
	var/confirmation = tgui_alert(usr, "Are you sure you want to perform an ascent to 'Typhos'?", "Ascent and Rendezvous", list("Blast it!", "I'm a pussy..."))
	if(!confirmation || confirmation == "I'm a pussy...")
		return
	cur_vehicle.acceleration = 0
	visible_message(SPAN_NOTICE("FNAV states: 'Confirmation received, beginning automatic ascent to: 170KM ASL.'."))
	cur_vehicle.orbiting = TRUE
	cur_vehicle.entrypoint.can_use = FALSE
	sleep(50)
	cur_vehicle.visible_message(SPAN_DANGER("\The [cur_vehicle] blasts off right in front of you!"))
	animate(cur_vehicle, alpha = 0, 20)
	spawn(20)
		QDEL_NULL(cur_vehicle.soundloop)
		cur_vehicle.forceMove(get_turf(sky_alt_tag))
	visible_message(SPAN_WARNING("The whole vehicle jolts as it fires up its nuclear engines!"))
	var/list/play_sound_to = list()
	for(var/mob/living/carbon/human/H in view(9, src))
		play_sound_to += H
		shake_camera(H, 2, 4)
		if(H != cur_vehicle.controlling && prob(10))
			H.vomit()
	ascent_loop = new(play_sound_to, TRUE, TRUE)
	spawn(20 SECONDS)
		for(var/mob/living/carbon/human/H in play_sound_to)
			H.playsound_local(get_turf(H), 'sound/vehicle/cts/lift_rattle_high.wav', 200, 0)
	spawn(40 SECONDS)
		ascent_loop.mid_sounds = list('sound/vehicle/cts/lift_low.wav')
		for(var/mob/living/carbon/human/H in play_sound_to)
			H.playsound_local(get_turf(H), 'sound/vehicle/cts/lift_rattle_medium.wav', 200, 0)
	spawn(60 SECONDS)
		for(var/mob/living/carbon/human/H in play_sound_to)
			H.playsound_local(get_turf(H), 'sound/vehicle/cts/lift_rattle_low.wav', 200, 0)
	sleep(10)
	for(var/mob/living/carbon/human/H in view(9, src))
		shake_camera(H, 1200, 0.2)
	sleep(30 SECONDS)
	QDEL_NULL(ascent_loop)
	visible_message(SPAN_WARNING("The main engines shut down, transitioning into idle mode."))
	cur_vehicle.acceleration = 0.1
	cur_vehicle.entrypoint.can_use = TRUE
	cur_vehicle.forceMove(get_turf(typhos_alt_tag))
	animate(cur_vehicle, alpha = 255, 20, easing = SINE_EASING)