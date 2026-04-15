
#define BOILING_RATE_COEF 0.2

//This gets called whenever we add/remove energy from a gasmix. Returns the energy change after phase transitions
/datum/gas_mixture/proc/make_phase_changes(thermal_energy_change, boiling_coef = BOILING_RATE_COEF)
	var/total_system_heat_capacity = heat_capacity()
	var/starting_energy = temperature * total_system_heat_capacity
	var/due_energy = starting_energy + thermal_energy_change

	var/phase_damp = boiling_coef
	if(boiling_coef <= BOILING_RATE_COEF)
		phase_damp = min(BOILING_RATE_COEF, 1.0 / (1 + abs(thermal_energy_change) / total_system_heat_capacity))

	var/current_pressure = return_pressure()
	var/alist/pre_gas = gas.Copy() // copied pre-vaporization to avoid wasting time trying to condense gas we just evaporated
	var/alist/pre_solids = solids.Copy() // ditto but for melting/freezing
	//evaporation + freezing
	//done together since they're mutually exclusive and all
	if(length(liquids))
		for(var/liquid, liquid_amount in liquids)
			var/decl/material/liquid_mat = GET_DECL(liquid)
			var/liquid_boiling_energy = liquid_mat.get_boiling_temp(current_pressure) * total_system_heat_capacity
			if(due_energy > liquid_boiling_energy)
				var/excess_energy = due_energy - liquid_boiling_energy
				var/liquid_moles_boiled = min(liquid_amount, excess_energy / liquid_mat.latent_heat) * phase_damp
				liquids[liquid] -= liquid_moles_boiled
				gas[liquid] += liquid_moles_boiled
				due_energy -= liquid_moles_boiled * liquid_mat.latent_heat
			else
				var/liquid_melting_energy = liquid_mat.melting_point * total_system_heat_capacity
				if(due_energy < liquid_melting_energy)
					var/short_energy = liquid_melting_energy - due_energy
					var/liquid_moles_frozen = min(liquid_amount, short_energy / liquid_mat.fusion_enthalpy) * phase_damp
					liquids[liquid] -= liquid_moles_frozen
					solids[liquid] += liquid_moles_frozen
					due_energy += liquid_moles_frozen * liquid_mat.fusion_enthalpy

	//condensation
	if(length(pre_gas))
		for(var/gasid, gas_amount in pre_gas)
			var/decl/material/gas_mat = GET_DECL(gasid)
			var/gas_boiling_energy = gas_mat.get_boiling_temp(current_pressure) * total_system_heat_capacity
			if(due_energy < gas_boiling_energy)
				var/short_energy = gas_boiling_energy - due_energy
				var/gas_moles_condensed = min(gas_amount, short_energy / gas_mat.latent_heat) * phase_damp
				gas[gasid] -= gas_moles_condensed
				liquids[gasid] += gas_moles_condensed
				due_energy += gas_moles_condensed * gas_mat.latent_heat

	//melting
	if(length(pre_solids))
		for(var/solid, solid_amount in pre_solids)
			var/decl/material/solid_mat = GET_DECL(solid)
			var/solid_melting_energy = solid_mat.melting_point * total_system_heat_capacity
			if(due_energy > solid_melting_energy)
				var/excess_energy = due_energy - solid_melting_energy
				var/solid_moles_melted = min(solid_amount, excess_energy / solid_mat.fusion_enthalpy) * phase_damp
				solids[solid] -= solid_moles_melted
				liquids[solid] += solid_moles_melted
				due_energy -= solid_moles_melted * solid_mat.fusion_enthalpy

	return due_energy - starting_energy

// Splits heat equally between two gas mixtures.
/datum/gas_mixture/proc/exchange_heat(datum/gas_mixture/partner)
	if(!partner)
		return 0

	var/other_heat_capacity = partner.heat_capacity()
	var/combined_heat_capacity = other_heat_capacity + heat_capacity() // make sure we calculate our own heat capacity here, then it's cached

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