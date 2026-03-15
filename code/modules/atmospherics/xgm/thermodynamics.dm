
#define BOILING_RATE_COEF 0.2

//This gets called whenever we add/remove energy from a gasmix. Returns the energy change after phase transitions
/datum/gas_mixture/proc/make_phase_changes(thermal_energy_change, boiling_coef = BOILING_RATE_COEF)
	var/total_system_heat_capacity = heat_capacity()
	var/final_energy = thermal_energy_change
	var/due_temperature = temperature + (final_energy / total_system_heat_capacity)
	var/recalculate_due_temp = FALSE

	var/phase_damp = min(BOILING_RATE_COEF, 1.0 / (1 + abs(thermal_energy_change) / total_system_heat_capacity))

	//evaporation
	for(var/liquid in liquids)
		var/decl/material/liquid_mat = GET_DECL(liquid)
		var/liquid_boiling_temp = liquid_mat.get_boiling_temp(return_pressure())
		if(due_temperature > liquid_boiling_temp)
			var/temperature_delta = due_temperature - liquid_boiling_temp
			var/excess_energy = temperature_delta * total_system_heat_capacity
			var/liquid_moles_boiled = min(liquids[liquid], excess_energy / liquid_mat.latent_heat) * phase_damp
			liquids[liquid] -= liquid_moles_boiled
			gas[liquid] += liquid_moles_boiled
			final_energy -= liquid_moles_boiled * liquid_mat.latent_heat
			recalculate_due_temp = TRUE
	if(recalculate_due_temp)
		due_temperature = temperature + (final_energy / total_system_heat_capacity)

	//condensation
	recalculate_due_temp = FALSE
	for(var/g in gas)
		var/decl/material/gas_mat = GET_DECL(g)
		var/boiling_temp = gas_mat.get_boiling_temp(return_pressure())
		if(due_temperature < boiling_temp)
			var/temperature_delta = due_temperature - boiling_temp
			var/short_energy = temperature_delta * total_system_heat_capacity
			var/gas_moles_condensed = min(gas[g], abs(short_energy / gas_mat.latent_heat)) * phase_damp
			gas[g] -= gas_moles_condensed
			liquids[g] += gas_moles_condensed
			final_energy += gas_moles_condensed * gas_mat.latent_heat
			recalculate_due_temp = TRUE
	if(recalculate_due_temp)
		due_temperature = temperature + (final_energy / total_system_heat_capacity)

	//melting
	recalculate_due_temp = FALSE
	for(var/solid in solids)
		var/decl/material/solid_mat = GET_DECL(solid)
		var/melting_temp = solid_mat.melting_point
		if(due_temperature > melting_temp)
			var/temperature_delta = due_temperature - melting_temp
			var/excess_energy = temperature_delta * total_system_heat_capacity
			var/solid_moles_melted = min(solids[solid], excess_energy / solid_mat.fusion_enthalpy) * phase_damp
			solids[solid] -= solid_moles_melted
			liquids[solid] += solid_moles_melted
			final_energy -= solid_moles_melted * solid_mat.fusion_enthalpy
			recalculate_due_temp = TRUE
	if(recalculate_due_temp)
		due_temperature = temperature + (final_energy / total_system_heat_capacity)

	//freezing
	for(var/liquid in liquids)
		var/decl/material/liquid_mat = GET_DECL(liquid)
		var/melting_temp = liquid_mat.melting_point
		if(due_temperature < melting_temp)
			var/temperature_delta = due_temperature - melting_temp
			var/short_energy = temperature_delta * total_system_heat_capacity
			var/liquid_moles_freezed = min(liquids[liquid], abs(short_energy / liquid_mat.fusion_enthalpy)) * phase_damp
			liquids[liquid] -= liquid_moles_freezed
			solids[liquid] += liquid_moles_freezed
			final_energy += liquid_moles_freezed * liquid_mat.fusion_enthalpy

	return final_energy

// Splits heat equally between two gas mixtures.
/datum/gas_mixture/proc/exchange_heat(datum/gas_mixture/partner)
	if(!partner)
		return 0

	var/other_heat_capacity = partner.heat_capacity()
	var/combined_heat_capacity = other_heat_capacity + heat_capacity

	var/old_temperature = temperature
	var/other_old_temperature = partner.temperature

	if(combined_heat_capacity > 0)
		var/combined_energy = partner.temperature*other_heat_capacity + heat_capacity*temperature

		var/new_temperature = combined_energy/combined_heat_capacity
		temperature = new_temperature
		partner.temperature = new_temperature

	if(abs(old_temperature-temperature) > 1)
		update_values()

	if(abs(other_old_temperature-partner.temperature) > 1)
		partner.update_values()