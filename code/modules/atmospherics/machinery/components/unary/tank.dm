/obj/machinery/atmospherics/unary/tank
	icon = 'icons/obj/atmospherics/stationary_canisters.dmi'
	icon_state = "air"

	name = "Pressure Tank"
	desc = "A large vessel containing pressurized gas."

	var/volume = 10000 //in liters, 1 meters by 1 meters by 2 meters ~tweaked it a little to simulate a pressure tank without needing to recode them yet
	var/start_pressure = 25*ONE_ATMOSPHERE
	var/filling // list of gas ratios to use.

	layer = STRUCTURE_LAYER
	level = 1
	dir = SOUTH
	initialize_directions = 2
	density = 1
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_WATER
	pipe_class = PIPE_CLASS_UNARY

	build_icon = 'icons/obj/atmospherics/stationary_canisters.dmi'
	build_icon_state = "air"

	construct_state = /decl/machine_construction/pipe
	uncreated_component_parts = null // don't use power
	frame_type = /obj/item/pipe/tank

/obj/machinery/atmospherics/unary/tank/Initialize()
	. = ..()
	if(filling)
		air_contents.volume = volume
		air_contents.temperature = T20C

		var/list/gases = list()
		for(var/gas in filling)
			gases += gas
			gases += start_pressure * filling[gas] * (air_contents.volume)/(R_IDEAL_GAS_EQUATION*air_contents.temperature)
		air_contents.adjust_multi(arglist(gases))
		update_icon()

/obj/machinery/atmospherics/unary/tank/set_initial_level()
	level = 1 // Always on top, apparently.

/obj/machinery/atmospherics/unary/tank/on_update_icon()
	build_device_underlays(FALSE)

/obj/machinery/atmospherics/unary/tank/hide()
	update_icon()

/obj/machinery/atmospherics/unary/tank/return_air()
	return air_contents

/obj/machinery/atmospherics/unary/tank/deconstruction_pressure_check()
	if (air_contents.return_pressure() > 2*ONE_ATMOSPHERE)
		return FALSE
	return TRUE

/obj/machinery/atmospherics/unary/tank/air
	name = "Pressure Tank (Air)"
	icon_state = "air"
	filling = list(/decl/material/gas/oxygen = O2STANDARD, /decl/material/gas/nitrogen = N2STANDARD)

/obj/machinery/atmospherics/unary/tank/oxygen
	name = "Pressure Tank (Oxygen)"
	icon_state = "o2"
	filling = list(/decl/material/gas/oxygen = 1)

/obj/machinery/atmospherics/unary/tank/nitrogen
	name = "Pressure Tank (Nitrogen)"
	icon_state = "n2"
	filling = list(/decl/material/gas/nitrogen = 1)

/obj/machinery/atmospherics/unary/tank/carbon_dioxide
	name = "Pressure Tank (Carbon Dioxide)"
	icon_state = "co2"
	filling = list(/decl/material/gas/carbon_dioxide = 1)

/obj/machinery/atmospherics/unary/tank/nitrous_oxide
	name = "Pressure Tank (Nitrous Oxide)"
	icon_state = "n2o"
	filling = list(/decl/material/gas/nitrous_oxide = 1)

/obj/machinery/atmospherics/unary/tank/hydrogen
	name = "Pressure Tank (Hydrogen)"
	icon_state = "h2"
	filling = list(/decl/material/gas/hydrogen = 1)

/obj/machinery/atmospherics/unary/tank/large
	name = "Large Tank"
	desc = "A large 150m3 tank for fluids and gases."
	icon = 'icons/obj/atmospherics/large_tanks.dmi'
	icon_state = "blank"
	volume = 150000
	pixel_x = -32

/obj/machinery/atmospherics/unary/tank/large/water
	name = "Large Tank (Water)"
	icon_state = "water"
	filling = list(/decl/material/gas/nitrogen = 0.01, /decl/material/liquid/water = 0.99)

/obj/machinery/atmospherics/unary/tank/large/nitrogen
	name = "Large Tank (Nitrogen)"
	icon_state = "nitrogen"
	filling = list(/decl/material/gas/nitrogen = 1)

/obj/machinery/atmospherics/unary/tank/large/diesel
	name = "Large Tank (Diesel)"
	icon_state = "diesel"
	filling = list(/decl/material/gas/nitrogen = 0.01, /decl/material/liquid/diesel = 0.99)

/obj/machinery/atmospherics/unary/tank/large/decontamination
	name = "Large Tank (Decontamination)"
	icon_state = "decontamination"
	filling = list(/decl/material/gas/nitrogen = 0.01, /decl/material/solid/metal/fission_byproduct = 0.03)

/obj/item/pipe/tank
	icon = 'icons/obj/atmospherics/stationary_canisters.dmi'
	icon_state = "air"
	name =  "Pressure Tank"
	desc = "A large vessel containing pressurized gas."
	color =  PIPE_COLOR_WHITE
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	w_class = ITEM_SIZE_STRUCTURE
	density = 1
	level = 1
	dir = SOUTH
	constructed_path = /obj/machinery/atmospherics/unary/tank
	pipe_class = PIPE_CLASS_UNARY