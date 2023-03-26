/datum/map_template/lander
	name = "Lander enterior"
	width = 10
	height = 7
	mappaths = list("maps/_interiors/lander_interior.dmm")
	template_categories = list(MAP_TEMPLATE_CATEGORY_INTERIORS)
	pilot_seat_offset = list("x"=7, "y"=2)

/obj/multitile_vehicle/aerial/lander
	name = "Cargo Transport System"
	uid = "CTS"
	weight = 14000 //dry mass
	acceleration = 0.3
	drag_multiplier = 0.95
	interior_template = "Lander enterior"
	ignition_switch_offset = list("x"=8, "y"=1)

/obj/effect/interior_entrypoint/vehicle/lander
	uid = "CTS"
	icon = 'icons/obj/doors/doorint.dmi'
	icon_state = "pdoor1"
	pixel_y = -32