/obj/item/stock_parts/circuitboard/binary_atmos
	board_type = "machine"
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/binary_atmos/cryocooler
	name = "circuitboard (cryocooler)"
	build_path = /obj/machinery/atmospherics/binary/cryocooler
	req_components = list(
							/obj/item/stack/cable_coil = 20,
							/obj/item/stock_parts/engine = 3)