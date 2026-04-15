/obj/machinery/multitile
	density = TRUE
	anchored = TRUE
	appearance_flags = PIXEL_SCALE | LONG_GLIDE

	var/width = 2 // Tiles to the right
	var/height = 2 // Tiles up

	// Alright, it gets a little complex here.
	// It's a list of ports. Each port is defined as a list:
	// list(offsetX, offsetY, direction, name)
	// Offsets are defined in tiles. Directions should be cardinal.
	var/list/map_ports
	var/map_port_volume = 2000

	// A list of port references.
	var/list/port_refs

	// A list of port air_contents datum references
	var/list/port_gases

	var/spawn_power_terminal = FALSE
	var/obj/machinery/power/generator/terminal/power_port

/obj/machinery/multitile/Initialize()
	. = ..()
	port_refs = list()
	port_gases = list()

	for(var/list/port_data in map_ports)
		var/obj/machinery/atmospherics/unary/multiport/nport = new(locate(x + port_data[1], y + port_data[2], z))
		nport.our_daddy = src
		nport.dir = port_data[3]
		nport.set_dir(port_data[3])
		nport.atmos_init()
		nport.air_contents.volume = map_port_volume
		nport.name = "fluid port([port_data[4]])"
		port_refs[port_data[4]] = nport
		port_gases[port_data[4]] = nport.air_contents

	if(spawn_power_terminal)
		power_port = new(loc)
		power_port.our_daddy = src

/obj/machinery/multitile/Destroy()
	. = ..()
	for(var/obj/port in port_refs)
		qdel(port)
	port_refs.Cut()
	port_gases.Cut()
	QDEL_NULL(power_port)

/obj/machinery/multitile/proc/available_power()
	return 0

/obj/machinery/multitile/proc/get_voltage()
	return 0

/obj/machinery/multitile/proc/on_power_drain(w)
	return

/obj/machinery/multitile/test
	map_ports = list(
		list(0, 1, NORTH, "1"),
		list(-1, 0, WEST, "2"),
		list(1, 0, EAST, "3"),
		list(0, -1, SOUTH, "4")
	)