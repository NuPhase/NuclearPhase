// Volume is not constant, and pressure actually decreases with rising temperature since we vent gas into space.
/datum/gas_mixture/surface/cache_pressure()
	pressure = total_moles * R_IDEAL_GAS_EQUATION / (temperature / T0C)

/datum/gas_mixture/surface/add_thermal_energy(thermal_energy, calculate_phase_change, forced, boiling_coef = BOILING_RATE_COEF)
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

/datum/gas_mixture/surface/share_ratio(datum/gas_mixture/other, connecting_tiles, share_size, one_way)
	var/list/cached_gas = gas.Copy()
	var/list/cached_liquids = liquids.Copy()
	var/list/cached_solids = solids.Copy()
	var/cached_temperature = temperature
	. = ..()
	gas = cached_gas
	liquids = cached_liquids
	solids = cached_solids
	temperature = cached_temperature

/datum/gas_mixture/surface/equalize(datum/gas_mixture/sharer)
	var/list/cached_gas = gas.Copy()
	var/list/cached_liquids = liquids.Copy()
	var/list/cached_solids = solids.Copy()
	var/cached_temperature = temperature
	. = ..()
	gas = cached_gas
	liquids = cached_liquids
	solids = cached_solids
	temperature = cached_temperature

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
			pressure_to_cache = gas_moles * R_IDEAL_GAS_EQUATION * temperature / available_volume
		else
			pressure_to_cache = total_moles * R_IDEAL_GAS_EQUATION * temperature / volume
		var/list/all_fluid = get_fluid()
		for(var/g in liquids)
			var/decl/material/mat = GET_DECL(g)
			var/temperature_factor = Clamp(((temperature - mat.melting_point) / (mat.boiling_point - mat.melting_point))**2, 0.1, 1)
			pressure_to_cache += ONE_ATMOSPHERE * temperature_factor * (liquids[g]/all_fluid[g])
	pressure = max(pressure_to_cache, 0)
	if(pressure_to_cache < 0)
		PRINT_STACK_TRACE("Negative pressure result in cache_pressure()")

// Doesn't update it's heat capacity on its own. Useful for reactor interiors with high specific heats, for example.
/datum/gas_mixture/constant_heat_capacity/heat_capacity()
	return heat_capacity

/datum/gas_mixture/constant_heat_capacity/cache_heat_capacity()
	return