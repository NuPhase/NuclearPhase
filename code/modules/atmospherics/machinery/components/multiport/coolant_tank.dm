/obj/machinery/multitile/coolant_tank
	name = "main coolant tank"
	icon = 'icons/obj/atmospherics/multiport/coolant_tank.dmi'
	icon_state = "base"
	map_port_volume = 50000

	width = 4
	height = 4
	bound_width = 160
	bound_height = 160
	density = FALSE

	map_ports = list(
		list(1, 4, NORTH, "Outgas OUT"),
		list(0, 1, WEST, "Infill IN"),
		list(4, 1, EAST, "Drain OUT"),
		list(1, 0, SOUTH, "HX OUT"),
		list(3, 0, SOUTH, "HX IN")
	)

	var/datum/gas_mixture/air_contents
	var/wanted_temperature = 5 CELSIUS

	var/lerp_outgas_flow = 0 // ton/hour
	var/lerp_hx_flow = 0 // kg/s
	var/lerp_hx_thermal = 0 // MW

/obj/machinery/multitile/coolant_tank/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("It has [round(air_contents.get_mass() * 0.001, 0.1)]t of LCH left."))
	to_chat(user, SPAN_NOTICE("It loses LCH at a rate of [round(lerp_outgas_flow, 0.1)] tons/h."))
	to_chat(user, SPAN_NOTICE("The flow of coolant through it is [round(lerp_hx_flow)]kg/s."))
	to_chat(user, SPAN_NOTICE("It rejects [round(lerp_hx_thermal)]MW of heat from coolant."))

/obj/machinery/multitile/coolant_tank/Initialize()
	. = ..()
	air_contents = new(5000000)
	air_contents.liquids[/decl/material/gas/methane] = 125000000
	air_contents.gas[/decl/material/gas/methane] = 26500
	air_contents.temperature = 92
	air_contents.update_values()

/obj/machinery/multitile/coolant_tank/Process()
	var/datum/gas_mixture/outgas_out = port_gases["Outgas OUT"]
	var/datum/gas_mixture/infill_in =  port_gases["Infill IN"]
	var/datum/gas_mixture/drain_out =  port_gases["Drain OUT"]
	var/datum/gas_mixture/hx_out = 	   port_gases["HX OUT"]
	var/datum/gas_mixture/hx_in = 	   port_gases["HX IN"]

	air_contents.merge(infill_in.remove_ratio(0.1))

	var/cur_outgas_flow = 0
	if(air_contents.pressure > ONE_ATMOSPHERE && air_contents.pressure > outgas_out.pressure)
		var/obj/machinery/atmospherics/unary/multiport/outlet_port = port_refs["Outgas OUT"]
		var/datum/pipe_network/output = outlet_port.network_in_dir(outlet_port.dir)
		var/target_moles = calculate_equalize_moles(air_contents, outgas_out, output?.volume)
		outgas_out.merge(air_contents.remove_phase(target_moles, MAT_PHASE_GAS))
		cur_outgas_flow = target_moles * 0.016 * 3.6
	lerp_outgas_flow = Interpolate(lerp_outgas_flow, cur_outgas_flow, 0.1)

	if(air_contents.pressure > drain_out.pressure)
		drain_out.merge(air_contents.remove_phase(12000, MAT_PHASE_LIQUID))

	if(air_contents.temperature > wanted_temperature)
		return FALSE

	var/our_heat_capacity = hx_in.heat_capacity()
	var/their_heat_capacity = air_contents.heat_capacity()

	if(!their_heat_capacity || !our_heat_capacity)
		return FALSE

	// Account for latent heat
	var/latent_heat_energy = 0
	var/latent_heat_capacity = 0
	var/alist/all_fluid = hx_in.get_fluid()
	for(var/f_type, f_amt in all_fluid)
		var/decl/material/mat = GET_DECL(f_type)
		if(hx_in.temperature > mat.boiling_point && wanted_temperature < mat.boiling_point)
			latent_heat_energy -= f_amt * mat.latent_heat
	latent_heat_capacity = latent_heat_energy / hx_in.total_moles

	var/temperature_delta = wanted_temperature - hx_in.temperature
	var/required_energy_delta = (temperature_delta * our_heat_capacity) + latent_heat_energy

	var/available_energy_delta = (air_contents.temperature - wanted_temperature) * their_heat_capacity

	var/actual_energy_delta = max(available_energy_delta, required_energy_delta)

	var/energy_per_mole = ((our_heat_capacity/hx_in.total_moles) * temperature_delta) + latent_heat_capacity
	var/moles_transfered = abs(actual_energy_delta/energy_per_mole)
	hx_out.merge(hx_in.remove(moles_transfered))
	hx_out.add_thermal_energy(actual_energy_delta, boiling_coef = 0.999)

	lerp_hx_flow = Interpolate(lerp_hx_flow, moles_transfered * 0.016, 0.1)
	lerp_hx_thermal = abs(actual_energy_delta) / 1000000

	air_contents.add_thermal_energy(actual_energy_delta * -1)