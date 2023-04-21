/datum/composite_sound/reactor
	mid_sounds = list('sound/machines/reactorloop.ogg'=1)
	mid_length = 20
	volume = 50
	sfalloff = 25

/obj/structure/reactor_superstructure
	name = "C.C-F.R-1900"
	desc = "Nuclear Fusion-Fission Reactor hanged on a giant support structure."
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	icon = 'icons/obj/machines/fusion_reactor.dmi'
	pixel_y = -208
	pixel_x = -208
	var/datum/composite_sound/reactor/soundloop

/obj/structure/reactor_superstructure/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	reactor_components["superstructure"] = src

/obj/structure/reactor_superstructure/proc/startsound()
	soundloop = new(list(src), TRUE)

var/list/global/reactor_ports = list()

/obj/machinery/atmospherics/unary/reactor_connector
	icon = 'icons/obj/atmospherics/components/unary/connector.dmi'
	icon_state = "map_connector"

	name = "reactor port"

	dir = SOUTH
	initialize_directions = SOUTH

	var/obj/machinery/portable_atmospherics/connected_device
	use_power = POWER_USE_OFF
	interact_offline = TRUE

	uncreated_component_parts = null
	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/pipe

	level = 1

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "connector"

	pipe_class = PIPE_CLASS_UNARY
	var/obj/machinery/atmospherics/unary/reactor_connector/linked = null

/obj/machinery/atmospherics/unary/reactor_connector/on_update_icon()
	icon_state = "connector"
	build_device_underlays(FALSE)

/obj/machinery/atmospherics/unary/reactor_connector/Initialize()
	. = ..()
	air_contents.volume = 2000

/obj/machinery/atmospherics/unary/reactor_connector/hide(var/i)
	update_icon()

/obj/machinery/atmospherics/unary/reactor_connector/ingoing
/obj/machinery/atmospherics/unary/reactor_connector/outgoing

/obj/machinery/atmospherics/unary/reactor_connector/ingoing/Initialize()
	. = ..()
	reactor_ports["[uid]-in"] = src
	spawn(100)
		linked = reactor_ports["[uid]-out"]

/obj/machinery/atmospherics/unary/reactor_connector/outgoing/Initialize()
	. = ..()
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	reactor_ports["[uid]-out"] = src
	spawn(100)
		linked = reactor_ports["[uid]-in"]
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/atmospherics/unary/reactor_connector/outgoing/Process()
	. = ..()
	if(linked)
		air_contents.merge(linked.air_contents)
		linked.air_contents.remove_ratio(1)

/obj/structure/reactor_table
	name = "large table"
	anchored = 1
	density = 1
	opacity = 0
	layer = STRUCTURE_LAYER
	icon = 'icons/obj/structures/reactor_panel.dmi'