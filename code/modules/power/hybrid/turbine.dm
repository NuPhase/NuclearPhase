/obj/machinery/atmospherics/binary/turbinestage
	name = "turbine stage"
	desc = "A steam turbine section. Converting pressure into energy since 1884."
	icon = 'icons/obj/machines/power/turbine.dmi'
	icon_state = "off"
	layer = STRUCTURE_LAYER
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	level = 1
	density = 1

	use_power = POWER_USE_OFF
	idle_power_usage = 150
	identifier = "TURBINE0"

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/noninteractive

	var/efficiency = 0.4
	var/kin_energy = 0
	var/volume_ratio = 0.5 //AKA expansion ratio. Higher means less steam is used, but results in better overall efficiency.
	var/kin_loss = 0.001

	var/dP = 0