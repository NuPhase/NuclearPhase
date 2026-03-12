/obj/machinery/atmospherics/unary/multiport
	name = "machine port"
	icon = 'icons/obj/atmospherics/components/unary/connector.dmi'
	icon_state = "map_connector"
	layer = STRUCTURE_LAYER
	density = 1
	anchored = 1
	stat_immune = 0
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_WATER|CONNECT_TYPE_FUEL
	var/obj/machinery/multitile/our_daddy

/obj/machinery/atmospherics/unary/multiport/Destroy()
	. = ..()
	qdel(our_daddy)
	our_daddy = null

/obj/machinery/atmospherics/unary/multiport/Process()
	. = ..()
	update_networks()