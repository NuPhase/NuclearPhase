/obj/machinery/atmospherics/unary/multiport
	name = "machine port"
	icon = 'icons/obj/atmospherics/components/unary/connector.dmi'
	icon_state = "map_connector"
	layer = BELOW_TABLE_LAYER
	density = 1
	anchored = 1
	stat_immune = 0
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER
	var/obj/machinery/multitile/our_daddy

/obj/machinery/atmospherics/unary/multiport/Destroy()
	. = ..()
	qdel(our_daddy)
	our_daddy = null

/obj/machinery/atmospherics/unary/multiport/Process()
	. = ..()
	update_networks()


/obj/machinery/power/generator/terminal
	name = "terminal"
	icon_state = "term"
	level = 1
	layer = EXPOSED_WIRE_TERMINAL_LAYER
	anchored = 1

	stat_immune = NOINPUT | NOSCREEN | NOPOWER
	interact_offline = TRUE
	uncreated_component_parts = null
	construct_state = /decl/machine_construction/noninteractive/terminal // Auxiliary entity; all interactions pass through owner machine part instead.
	var/obj/machinery/multitile/our_daddy

/obj/machinery/power/generator/terminal/Initialize()
	. = ..()
	var/turf/T = src.loc
	if(level == 1 && isturf(T))
		hide(!T.is_plating())

/obj/machinery/power/generator/terminal/Destroy()
	. = ..()
	qdel(our_daddy)
	our_daddy = null

/obj/machinery/power/generator/terminal/available_power()
	return our_daddy.available_power()

/obj/machinery/power/generator/terminal/get_voltage()
	return our_daddy.get_voltage()

/obj/machinery/power/generator/terminal/on_power_drain(w)
	return our_daddy.on_power_drain(w)