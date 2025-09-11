/*
To add your own door, create a /obj/structure/door subtype and assign the following variables to it:
icon_state - preview icon state, stored in preview.dmi
frame_type - door frame icon state, stored in frame.dmi
door_type - door frame icon state, stored in door.dmi
handle_type - either 'null' or handle icon state, stored in handle.dmi
*/

/obj/structure/door/fire
	name = "fire door"
	icon_state = "fire"
	frame_type = "black_metal"
	door_type = "fire"
	handle_type = "fire"
	material = /decl/material/solid/metal/steel
	explosion_resistance = 300
	autoclose_time = 4 SECONDS

/obj/structure/door/highsec
	name = "secure door"
	icon_state = "highsec"
	frame_type = "black_metal_sec"
	door_type = "highsec"
	handle_type = "highsec"
	material = /decl/material/solid/metal/titanium
	explosion_resistance = 700
	autoclose_time = 4 SECONDS
	can_be_pried = FALSE

/obj/structure/door/sliding
	name = "sliding door"
	icon_state = "sliding"
	frame_type = "black_metal"
	door_type = "sliding"
	material = /decl/material/solid/glass
	open_sound = 'sound/machines/doors/sliding_door.ogg'
	sliding = TRUE
	has_window = TRUE
	opacity = 0
	explosion_resistance = 200
	autoclose_time = 10 SECONDS

/obj/structure/door/sliding/opaque
	icon_state = "sliding_opaque"
	door_type = "sliding_opaque"
	material = /decl/material/solid/metal/steel
	opacity = 1
	has_window = FALSE

/obj/structure/door/sliding/opaque/mirrored
	icon_state = "sliding_opaque_m"
	door_type = "sliding_opaque_m"
	sliding_direction = 23

/obj/structure/door/sliding/mirrored
	icon_state = "sliding_m"
	door_type = "sliding_m"
	sliding_direction = 23