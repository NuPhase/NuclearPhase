/datum/map_template/lander
	name = "Lander enterior"
	width = 10
	height = 7
	mappaths = list("maps/interiors/lander_interior.dmm")
	template_categories = list(MAP_TEMPLATE_CATEGORY_INTERIORS)
	pilot_seat_offset = list("x"=7, "y"=2)

/obj/multitile_vehicle/aerial/lander
	name = "Cargo Transport System"
	uid = "CTS"
	weight = 14000 //dry mass
	acceleration = 0.3
	drag_multiplier = 0.95
	interior_template = "Lander enterior"

/obj/effect/vehicle_entrypoint/lander
	uid = "CTS"