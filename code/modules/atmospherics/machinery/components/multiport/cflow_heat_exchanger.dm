// weight - 600kg
/obj/machinery/multitile/cflow_heat_exchanger
	name = "counterflow heat exchanger"
	icon = 'icons/obj/atmospherics/multiport/cflow_exchanger.dmi'
	icon_state = "base"

	map_port_volume = 500
	temperature_sensitive = FALSE // we process temperature ourselves

	width = 2
	height = 0
	bound_width = 96
	bound_height = 32

	map_ports = list(
		list(0, 0, NORTH, "Primary IN"),
		list(2, 0, NORTH, "Primary OUT"),
		list(0, 0, SOUTH, "Secondary OUT"),
		list(2, 0, SOUTH, "Secondary IN")
	)

	var/heat_capacity = 300000
	var/conductivity = 70000
	var/last_overlay_state

/obj/machinery/multitile/cflow_heat_exchanger/on_update_icon()
	var/desired_state
	switch(temperature)
		if(0 to 273.15)
			desired_state = "frost"
		if(900 to INFINITY)
			desired_state = "glow"
	if(last_overlay_state == desired_state)
		return
	cut_overlays()
	last_overlay_state = desired_state
	if(desired_state == null)
		return
	if(desired_state == "glow")
		add_overlay(emissive_overlay(icon, desired_state))
	else
		add_overlay(overlay_image(icon, desired_state))

/obj/machinery/multitile/cflow_heat_exchanger/proc/process_gasmix(datum/gas_mixture/gasmix)
	var/temp_diff = gasmix.temperature - temperature
	var/heat_transfer = Clamp(temp_diff * conductivity, gasmix.heat_capacity*-500, gasmix.heat_capacity*500)
	gasmix.add_thermal_energy(heat_transfer * -1)
	temperature += heat_transfer / heat_capacity

/obj/machinery/multitile/cflow_heat_exchanger/proc/process_flow(datum/gas_mixture/source, datum/gas_mixture/sink, datum/pipe_network/sink_network)
	var/pressure_delta = source.pressure - sink.pressure
	if(pressure_delta < 0)
		return
	var/transfer_moles = 0
	if(source.gas_moles > source.total_moles * 0.1)
		transfer_moles = calculate_transfer_moles(source, sink, pressure_delta, sink_network?.volume)
	else
		transfer_moles = calculate_pressure_flow(pressure_delta, sink.volume)
	var/datum/gas_mixture/transferred_fluid = source.remove(transfer_moles)
	process_gasmix(transferred_fluid)
	sink.merge(transferred_fluid)

/obj/machinery/multitile/cflow_heat_exchanger/Process()
	var/datum/gas_mixture/primary_in = port_gases["Primary IN"]
	var/datum/gas_mixture/primary_out = port_gases["Primary OUT"]
	var/datum/gas_mixture/secondary_in = port_gases["Secondary IN"]
	var/datum/gas_mixture/secondary_out = port_gases["Secondary OUT"]
	var/obj/machinery/atmospherics/unary/multiport/primary_outlet_port = port_refs["Primary OUT"]
	var/obj/machinery/atmospherics/unary/multiport/secondary_outlet_port = port_refs["Secondary OUT"]

	process_flow(primary_in, primary_out, primary_outlet_port.network_in_dir(primary_outlet_port.dir))
	process_flow(secondary_in, secondary_out, secondary_outlet_port.network_in_dir(secondary_outlet_port.dir))
	update_icon()


// weight - 6 tons
/obj/machinery/multitile/cflow_heat_exchanger/large
	name = "steam superheater"
	icon = 'icons/obj/atmospherics/multiport/cflow_exchanger_large.dmi'
	width = 0
	height = 4
	bound_width = 32
	bound_height = 160
	map_ports = list(
		list(0, 0, WEST, "Primary IN"),
		list(0, 4, WEST, "Primary OUT"),
		list(0, 0, EAST, "Secondary OUT"),
		list(0, 4, EAST, "Secondary IN")
	)
	heat_capacity = 3000000
	conductivity = 700000
	map_port_volume = 50000