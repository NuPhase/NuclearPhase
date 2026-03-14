// Has three ports.
// Coolant IN
// Coolant OUT
// Tank
// Takes in coolant from the intake, exchanges it with TANK and spews it out.

/obj/machinery/multitile/tray_heat_exchanger
	name = "tray heat exchanger"
	map_port_volume = 50000

	width = 2
	height = 0

	map_ports = list(
		list(2, 0, SOUTH, "Coolant IN"),
		list(1, 0, NORTH, "Tank"),
		list(0, 0, SOUTH, "Coolant OUT")
	)

	var/wanted_temperature = T20C

/obj/machinery/multitile/tray_heat_exchanger/Process()
	var/datum/gas_mixture/air1 = port_gases["Coolant IN"]
	var/datum/gas_mixture/air2 = port_gases["Coolant OUT"]
	var/datum/gas_mixture/air_contents = port_gases["Tank"]

	if(!air1.total_moles)
		return

	if(air_contents.temperature > wanted_temperature)
		return FALSE

	var/our_heat_capacity = air1.heat_capacity()
	var/their_heat_capacity = air_contents.heat_capacity()

	if(!their_heat_capacity || !our_heat_capacity)
		return FALSE

	// Account for latent heat
	var/latent_heat_energy = 0
	var/latent_heat_capacity = 0
	var/list/all_fluid = air1.get_fluid()
	for(var/f_type in all_fluid)
		var/decl/material/mat = GET_DECL(f_type)
		if(air1.temperature > mat.boiling_point && wanted_temperature < mat.boiling_point)
			latent_heat_energy -= all_fluid[f_type] * mat.latent_heat
	latent_heat_capacity = latent_heat_energy / air1.total_moles

	var/temperature_delta = wanted_temperature - air1.temperature
	var/required_energy_delta = (temperature_delta * our_heat_capacity) + latent_heat_energy

	var/available_energy_delta = (air_contents.temperature - wanted_temperature) * their_heat_capacity

	var/actual_energy_delta = max(available_energy_delta, required_energy_delta)

	var/energy_per_mole = ((our_heat_capacity/air1.total_moles) * temperature_delta) + latent_heat_capacity
	air2.merge(air1.remove(abs(actual_energy_delta/energy_per_mole)))
	air2.add_thermal_energy(actual_energy_delta, boiling_coef = 0.999)

	air_contents.add_thermal_energy(actual_energy_delta * -1, boiling_coef = 0.01)