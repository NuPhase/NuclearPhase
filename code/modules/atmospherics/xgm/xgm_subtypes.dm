// Volume is not constant, and pressure actually decreases with rising temperature since we vent gas into space.
/datum/gas_mixture/surface/cache_pressure()
	pressure = total_moles * R_IDEAL_GAS_EQUATION / (temperature / T0C)

/datum/gas_mixture/surface/add_thermal_energy(thermal_energy, calculate_phase_change, forced)
	return

/datum/gas_mixture/surface/adjust_gas(gasid, moles, update, calculate_phase_change)
	return

/datum/gas_mixture/surface/adjust_gas_temp(gasid, moles, temp, update, calculate_phase_change)
	return

/datum/gas_mixture/surface/remove_ratio(ratio, out_group_multiplier)
	var/list/cached_gas = gas.Copy()
	var/list/cached_liquids = liquids.Copy()
	var/list/cached_solids = solids.Copy()
	. = ..()
	gas = cached_gas
	liquids = cached_liquids
	solids = cached_solids

/datum/gas_mixture/surface/merge(datum/gas_mixture/giver, update)
	return

/datum/gas_mixture/surface/remove(amount)
	var/list/cached_gas = gas.Copy()
	var/list/cached_liquids = liquids.Copy()
	var/list/cached_solids = solids.Copy()
	. = ..()
	gas = cached_gas
	liquids = cached_liquids
	solids = cached_solids

// For machinery utilizing suction_moles
/datum/gas_mixture/node/cache_pressure()
	var/pressure_to_cache = 0
	if(volume)
		if(gas_moles)
			var/actually_suctioned = gas_moles - min(suction_moles, gas_moles * 0.9)
			pressure_to_cache = actually_suctioned * R_IDEAL_GAS_EQUATION * temperature / available_volume
		else
			var/actually_suctioned = total_moles - min(suction_moles, total_moles * 0.9)
			pressure_to_cache = actually_suctioned * R_IDEAL_GAS_EQUATION * temperature / volume
		var/list/all_fluid = get_fluid()
		for(var/g in liquids)
			var/decl/material/mat = GET_DECL(g)
			var/temperature_factor = Clamp(((temperature - mat.melting_point) / (mat.boiling_point - mat.melting_point))**2, 0.1, 1)
			pressure_to_cache += ONE_ATMOSPHERE * temperature_factor * (liquids[g]/all_fluid[g])
	pressure = max(pressure_to_cache, 0)
	if(pressure_to_cache < 0)
		PRINT_STACK_TRACE("Negative pressure result in cache_pressure()")