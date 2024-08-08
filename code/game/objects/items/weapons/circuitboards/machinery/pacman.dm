/obj/item/stock_parts/circuitboard/pacman
	name = "circuitboard (portable generator)"
	build_path = /obj/machinery/power/generator/port_gen/pacman
	board_type = "machine"
	origin_tech = @'{"programming":3,"powerstorage":3,"exoticmatter":3,"engineering":3}'
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/cable_coil = 15,
		/obj/item/stock_parts/capacitor = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)
