/obj/item/stock_parts/circuitboard/mining_extractor
	name = "circuitboard (gas extractor)"
	build_path = /obj/machinery/atmospherics/unary/material/extractor
	board_type = "machine"
	origin_tech = "{'programming':2,'engineering':2}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/modernsuit_storage
	name = "circuitboard (exosuit storage)"
	build_path = /obj/machinery/modernsuit_storage
	board_type = "machine"
	origin_tech = "{'programming':2,'engineering':2}"
	req_components = list(
		/obj/item/stock_parts/engine = 6,
		/obj/item/stock_parts/micro_laser = 1,
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)