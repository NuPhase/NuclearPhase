/obj/machinery/atmospherics/unary/debug/infinite_outlet
	icon = 'icons/obj/atmospherics/components/unary/cold_sink.dmi'
	icon_state = "intact_off"

	name = "infinite fluid generator"
	uncreated_component_parts = null
	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/pipe
	interact_offline = TRUE
	var/fluid_type = /decl/material/gas/hydrogen
	var/fluid_pressure = ONE_ATMOSPHERE * 50
	var/fluid_temperature = T20C

/obj/machinery/atmospherics/unary/debug/infinite_outlet/on_update_icon()
	if(LAZYLEN(nodes_to_networks))
		icon_state = "intact_off"
	else
		icon_state = "exposed"

/obj/machinery/atmospherics/unary/debug/infinite_outlet/Process()
	..()
	if(air_contents.pressure < fluid_pressure)
		air_contents.adjust_gas_temp(fluid_type, (fluid_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * fluid_temperature), fluid_temperature)

/obj/machinery/atmospherics/unary/debug/infinite_outlet/water
	fluid_type = /decl/material/liquid/water

/obj/machinery/atmospherics/unary/debug/infinite_sink
	icon = 'icons/obj/atmospherics/components/unary/cold_sink.dmi'
	icon_state = "intact_on"

	name = "infinite gas sink"
	uncreated_component_parts = null
	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/pipe
	interact_offline = TRUE

/obj/machinery/atmospherics/unary/debug/infinite_sink/on_update_icon()
	if(LAZYLEN(nodes_to_networks))
		icon_state = "intact_on"
	else
		icon_state = "exposed"

/obj/machinery/atmospherics/unary/debug/infinite_sink/Process()
	..()
	air_contents.remove_ratio(1)