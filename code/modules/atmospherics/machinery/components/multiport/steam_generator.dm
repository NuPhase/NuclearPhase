// Has three ports.
// Coolant IN
// Coolant OUT
// Tank
// Takes in coolant from the intake, exchanges it with TANK and spews it out.

/obj/machinery/multitile/steam_generator
	name = "steam generator"
	icon = 'icons/obj/atmospherics/multiport/cflow_exchanger.dmi'
	icon_state = "base"
	map_port_volume = 50000

	width = 2
	height = 0

	map_ports = list(
		list(0, 0, SOUTH, "Hot Salt IN"),
		list(1, 0, SOUTH, "Cold Salt OUT"),
		list(2, 1, NORTH, "Water IN"),
		list(1, 1, NORTH, "Water OUT"),
		list(0, 1, NORTH, "Steam OUT")
	)

	var/datum/gas_mixture/air_contents

	var/wanted_temperature = 550

/obj/machinery/multitile/steam_generator/Initialize()
	. = ..()
	var/datum/gas_mixture/air1 = port_gases["Hot Salt IN"]
	var/datum/gas_mixture/water_inlet = port_gases["Water IN"]
	var/datum/gas_mixture/water_outlet = port_gases["Water OUT"]
	air1.volume = 50000
	air1.suction_moles = 60000
	water_inlet.volume = 5000
	water_outlet.volume = 5000

	air_contents = new(300000)
	air_contents.adjust_gas(/decl/material/gas/nitrogen, 10)
	air_contents.adjust_gas(/decl/material/liquid/water, (300000 * 0.5) / 0.018)
	air_contents.temperature = 410
	reactor_components["steam_generator"] = src

/obj/machinery/multitile/steam_generator/Destroy()
	. = ..()
	reactor_components["steam_generator"] = null

/obj/machinery/multitile/steam_generator/Process()
	var/datum/gas_mixture/air1 = port_gases["Hot Salt IN"]
	var/datum/gas_mixture/air2 = port_gases["Cold Salt OUT"]
	var/datum/gas_mixture/water_inlet = port_gases["Water IN"]
	var/datum/gas_mixture/water_outlet = port_gases["Water OUT"]
	var/datum/gas_mixture/steam_outlet = port_gases["Steam OUT"]

	// Backpressure isn't influencing it atm since we don't simulate hydraulics
	// TODO: Simulate hydraulics
	air_contents.merge(water_inlet.remove_ratio(0.2))

	if(air_contents.pressure > water_outlet.pressure)
		water_outlet.merge(air_contents.remove_phase(8000, MAT_PHASE_LIQUID))

	if(air_contents.pressure > steam_outlet.pressure)
		var/obj/machinery/atmospherics/unary/multiport/outlet_port = port_refs["Steam OUT"]
		var/datum/pipe_network/output = outlet_port.network_in_dir(outlet_port.dir)
		var/pressure_delta = air_contents.pressure - steam_outlet.pressure
		var/target_moles = calculate_transfer_moles(air_contents, steam_outlet, pressure_delta, output?.volume)
		target_moles = min(target_moles, air_contents.gas_moles*0.5)
		steam_outlet.merge(air_contents.remove_phase(target_moles, MAT_PHASE_GAS))

	if(!air1.total_moles)
		return

	var/our_heat_capacity = air1.heat_capacity()
	var/their_heat_capacity = air_contents.heat_capacity()

	if(!their_heat_capacity || !our_heat_capacity)
		return FALSE

	// Account for latent heat
	var/latent_heat_energy = 0
	var/latent_heat_capacity = 0
	var/alist/all_fluid = air1.get_fluid()
	for(var/f_type, f_amt in all_fluid)
		var/decl/material/mat = GET_DECL(f_type)
		if(air1.temperature > mat.boiling_point && wanted_temperature < mat.boiling_point)
			latent_heat_energy -= f_amt * mat.latent_heat
	latent_heat_capacity = latent_heat_energy / air1.total_moles

	var/temperature_delta = wanted_temperature - air1.temperature
	var/required_energy_delta = (temperature_delta * our_heat_capacity) + latent_heat_energy

	var/available_energy_delta = (air_contents.temperature - wanted_temperature) * their_heat_capacity

	var/actual_energy_delta = max(available_energy_delta, required_energy_delta)

	var/energy_per_mole = ((our_heat_capacity/air1.total_moles) * temperature_delta) + latent_heat_capacity
	air2.merge(air1.remove(abs(actual_energy_delta/energy_per_mole)))
	air2.add_thermal_energy(actual_energy_delta, boiling_coef = 0.999)

	air_contents.add_thermal_energy(actual_energy_delta * -1, boiling_coef = 0.01)
	air_contents.update_values()