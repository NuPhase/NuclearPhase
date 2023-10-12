
//This gets called whenever we add/remove energy from a gasmix. Returns the energy change after phase transitions
/datum/gas_mixture/proc/make_phase_changes(thermal_energy_change)

	var/total_system_heat_capacity = heat_capacity()
	var/final_energy = thermal_energy_change

	//evaporation
	for(var/liquid in liquids)
		var/decl/material/liquid_mat = GET_DECL(liquid)
		var/liquid_boiling_temp = liquid_mat.get_boiling_temp(return_pressure())
		if(temperature > liquid_boiling_temp)
			var/temperature_delta = temperature - liquid_boiling_temp
			var/excess_energy = temperature_delta * total_system_heat_capacity
			var/liquid_moles_boiled = excess_energy / liquid_mat.latent_heat
			liquids[liquid] -= liquid_moles_boiled
			gas[liquid] += liquid_moles_boiled
			final_energy += excess_energy * -1

	//condensation
	for(var/g in gas)
		var/decl/material/gas_mat = GET_DECL(g)
		var/boiling_temp = gas_mat.get_boiling_temp(return_pressure())
		if(temperature < boiling_temp)
			var/temperature_delta = temperature - boiling_temp
			var/short_energy = temperature_delta * total_system_heat_capacity
			var/gas_moles_condensed = short_energy / gas_mat.latent_heat
			gas += gas_moles_condensed //it's negative so we're ok
			liquids += abs(gas_moles_condensed) //turning negative to positive
			final_energy += short_energy

	return final_energy