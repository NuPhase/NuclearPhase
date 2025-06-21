// Volume is not constant, and pressure actually decreases with rising temperature since we vent gas into space.
/datum/gas_mixture/surface/cache_pressure()
	pressure = total_moles * R_IDEAL_GAS_EQUATION / (temperature / T0C)

/datum/gas_mixture/surface/add_thermal_energy(thermal_energy, calculate_phase_change, forced)
	return

/datum/gas_mixture/surface/adjust_gas(gasid, moles, update, calculate_phase_change)
	return

/datum/gas_mixture/surface/merge(datum/gas_mixture/giver, update)
	return

// For machinery utilizing suction_moles
/datum/gas_mixture/node/cache_pressure()
	var/pressure_to_cache = 0
	if(volume)
		if(gas_moles)
			pressure_to_cache = (gas_moles - suction_moles) * R_IDEAL_GAS_EQUATION * temperature / available_volume
		else
			pressure_to_cache = (total_moles - suction_moles) * R_IDEAL_GAS_EQUATION * temperature / volume
		for(var/g in liquids)
			var/decl/material/mat = GET_DECL(g)
			var/temperature_factor = (temperature - mat.melting_point) / mat.boiling_point //should be 1 at boiling point and 0 at melting point
			pressure_to_cache += liquids[g] * ONE_ATMOSPHERE * temperature_factor / volume
	pressure = max(pressure_to_cache, 0)
	if(pressure_to_cache < 0)
		PRINT_STACK_TRACE("Negative pressure result in cache_pressure()")