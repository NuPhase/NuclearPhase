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
	frame_type = "blue_metal"
	door_type = "fire"
	handle_type = "fire"
	material = /decl/material/solid/metal/steel
	explosion_resistance = 300

/obj/structure/door/sliding
	name = "sliding door"
	icon_state = "sliding"
	frame_type = "default"
	door_type = "sliding"
	material = /decl/material/solid/glass
	open_sound = 'sound/machines/doors/sliding_door.ogg'
	sliding = TRUE
	has_window = TRUE
	opacity = 0
	explosion_resistance = 200