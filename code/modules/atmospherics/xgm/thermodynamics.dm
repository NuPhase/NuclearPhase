
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
			var/liquid_moles_boiled = min(liquids[liquid], excess_energy / liquid_mat.latent_heat)
			liquids[liquid] -= liquid_moles_boiled
			gas[liquid] += liquid_moles_boiled
			final_energy -= liquid_moles_boiled * liquid_mat.latent_heat

	//condensation
	for(var/g in gas)
		var/decl/material/gas_mat = GET_DECL(g)
		var/boiling_temp = gas_mat.get_boiling_temp(return_pressure())
		if(temperature < boiling_temp)
			var/temperature_delta = temperature - boiling_temp
			var/short_energy = temperature_delta * total_system_heat_capacity
			var/gas_moles_condensed = min(gas[g], abs(short_energy / gas_mat.latent_heat))
			gas[g] -= gas_moles_condensed
			liquids[g] += gas_moles_condensed
			final_energy += gas_moles_condensed * gas_mat.latent_heat

	//melting
	for(var/solid in solids)
		var/decl/material/solid_mat = GET_DECL(solid)
		var/melting_temp = solid_mat.melting_point
		if(temperature > melting_temp)
			var/temperature_delta = temperature - melting_temp
			var/excess_energy = temperature_delta * total_system_heat_capacity
			var/solid_moles_melted = min(solids[solid], excess_energy / solid_mat.latent_heat)
			solids[solid] -= solid_moles_melted
			liquids[solid] += solid_moles_melted
			final_energy -= solid_moles_melted * solid_mat.latent_heat

	//freezing
	for(var/liquid in liquids)
		var/decl/material/liquid_mat = GET_DECL(liquid)
		var/melting_temp = liquid_mat.melting_point
		if(temperature < melting_temp)
			var/temperature_delta = temperature - melting_temp
			var/short_energy = temperature_delta * total_system_heat_capacity
			var/liquid_moles_freezed = min(liquids[liquid], abs(short_energy / liquid_mat.latent_heat))
			liquids[liquid] -= liquid_moles_freezed
			solids[liquid] += liquid_moles_freezed
			final_energy += liquid_moles_freezed * liquid_mat.latent_heat

	return final_energy