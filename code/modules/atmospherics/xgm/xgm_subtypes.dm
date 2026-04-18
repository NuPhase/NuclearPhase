// Volume is not constant, and pressure actually decreases with rising temperature since we vent gas into space.
/datum/gas_mixture/surface/cache_pressure()
	pressure = total_moles * R_IDEAL_GAS_EQUATION / (temperature / T0C)

/datum/gas_mixture/surface/add_thermal_energy(thermal_energy, calculate_phase_change, forced, boiling_coef = BOILING_RATE_COEF)
	return

/datum/gas_mixture/surface/adjust_gas(gasid, moles, update, calculate_phase_change)
	return

/datum/gas_mixture/surface/adjust_gas_temp(gasid, moles, temp, update, calculate_phase_change)
	return

// Copied from parent, except we don't mutate src
/datum/gas_mixture/surface/remove_ratio(ratio, out_group_multiplier)
	if(ratio <= 0)
		PRINT_STACK_TRACE("Negative value supplied to remove_ratio()")
		return null
	out_group_multiplier = between(1, out_group_multiplier, group_multiplier)
	ratio = min(ratio, 1)
	var/datum/gas_mixture/removed = new(_volume = volume * group_multiplier / out_group_multiplier, _temperature = temperature, _group_multiplier = out_group_multiplier)
	var/alist/removed_gas_list = removed.gas
	var/list/all_fluid = get_fluid()
	for(var/gasid, amount in all_fluid)
		removed_gas_list[gasid] = (amount * ratio * group_multiplier / out_group_multiplier)
	removed.update_values()
	return removed

// Copied from parent, except we don't mutate src
#define IN 1
#define OUT 2
#define RATIO_PER_SQRT_KPA_PRESSURE_DIFF 0.035
/datum/gas_mixture/surface/share_ratio(datum/gas_mixture/other, connecting_tiles, share_size, one_way)
	var/our_pressure = return_pressure()
	var/other_pressure = other.return_pressure()
	var/pressure_diff = abs(our_pressure - other_pressure)

	var/flow_direction = IN //IN means air flows into this mixture, OUT means air flows into the 'other' mixture
	var/share_ratio = Clamp(sqrt(pressure_diff) * RATIO_PER_SQRT_KPA_PRESSURE_DIFF * min(4, connecting_tiles), 0.05, 0.7) //The ratio of the mixtures sharing.

	if(our_pressure > other_pressure)
		flow_direction = OUT

	// We calculate pressure_coeff, then look how many moles we need to leave in the donor mixture to keep the pressure from falling below the lowest
	// of the two. The rest goes into the recipient mixture, multiplied by share_ratio

	if(flow_direction == OUT)
		if(one_way) // Just bring the pressure to the required point to equalize
			var/pressure_per_mole = R_IDEAL_GAS_EQUATION * temperature / volume
			var/moles_to_transfer = pressure_diff / pressure_per_mole * share_ratio
			var/datum/gas_mixture/taken_gas = remove(moles_to_transfer)
			other.merge(taken_gas)
		var/pressure_coeff = R_IDEAL_GAS_EQUATION * temperature / volume //Pressure per mole of gas
		var/minimum_moles_to_keep = other_pressure / pressure_coeff
		var/free_moles = (total_moles * group_multiplier) - minimum_moles_to_keep
		var/moles_to_transfer = free_moles * share_ratio
		var/datum/gas_mixture/taken_gas = remove(moles_to_transfer)
		other.merge(taken_gas)
	else
		if(one_way) // Just bring the pressure to the required point to equalize
			var/pressure_per_mole = R_IDEAL_GAS_EQUATION * temperature / volume
			var/moles_to_transfer = pressure_diff / pressure_per_mole
			other.remove(moles_to_transfer)
			return compare(other)
		var/pressure_coeff = R_IDEAL_GAS_EQUATION * other.temperature / other.volume //Pressure per mole of gas
		var/minimum_moles_to_keep = our_pressure / pressure_coeff
		var/free_moles = (other.total_moles * other.group_multiplier) - minimum_moles_to_keep
		var/moles_to_transfer = free_moles * share_ratio
		other.remove(moles_to_transfer)

	return compare(other)
#undef IN
#undef OUT
#undef RATIO_PER_SQRT_KPA_PRESSURE_DIFF

// Copied from parent but we don't modify our own gases
/datum/gas_mixture/surface/equalize(datum/gas_mixture/sharer)
	var/our_heatcap = heat_capacity()
	var/share_heatcap = sharer.heat_capacity()

	// Special exception: there isn't enough air around to be worth processing this edge next tick, zap sharer to zero
	if(total_moles + sharer.total_moles <= MINIMUM_AIR_TO_SUSPEND)
		sharer.gas.Cut()

	var/sharer_scale_factor = sharer.volume / (volume + sharer.volume)
	for(var/gas_type in gas|sharer.gas) // we can only iterate keys here since merging alists doesn't combine values
		sharer.gas[gas_type] = (gas[gas_type] + sharer.gas[gas_type]) * sharer_scale_factor

	if(our_heatcap + share_heatcap)
		sharer.temperature = ((temperature * our_heatcap) + (sharer.temperature * share_heatcap)) / (our_heatcap + share_heatcap)
	else
		sharer.temperature = temperature
	sharer.update_values()
	return 1

/datum/gas_mixture/surface/merge(datum/gas_mixture/giver, update)
	return

// Copied from parent but without mutating current gases
/datum/gas_mixture/surface/remove(amount, update = TRUE)
	if(amount < 0)
		PRINT_STACK_TRACE("Negative value supplied to remove()")
		return
	amount = min(amount, total_moles * group_multiplier) //Can not take more air than the gas mixture has!
	if(amount <= 0)
		return null

	var/datum/gas_mixture/removed = new(_volume = volume, _temperature = temperature)
	var/alist/new_gas = removed.gas
	var/alist/new_liquids = removed.liquids
	var/alist/new_solids = removed.solids

	var/alist/all_fluid = get_fluid()
	for(var/g in all_fluid)
		var/moles_left_to_remove = QUANTIZE((all_fluid[g] / total_moles) * amount)
		var/moles_taken
		if(solids[g])
			moles_taken = min(solids[g], moles_left_to_remove)
			moles_left_to_remove -= moles_taken
			new_solids[g] = moles_taken
		if(0 >= moles_left_to_remove)
			continue
		if(liquids[g])
			moles_taken = min(liquids[g], moles_left_to_remove)
			moles_left_to_remove -= moles_taken
			new_liquids[g] = moles_taken
		if(0 >= moles_left_to_remove)
			continue
		moles_taken = min(gas[g], moles_left_to_remove)
		moles_left_to_remove -= moles_taken
		new_gas[g] = moles_taken
		if(moles_left_to_remove >= 0.01)
			PRINT_STACK_TRACE("Fluid loss in gas_mixture/surface/remove()")

	if(update)
		removed.update_values()

	return removed

// For machinery utilizing suction_moles
/datum/gas_mixture/node/cache_pressure()
	var/pressure_to_cache = 0
	if(volume)
		if(gas_moles)
			pressure_to_cache = gas_moles * R_IDEAL_GAS_EQUATION * temperature / available_volume
		else
			pressure_to_cache = total_moles * R_IDEAL_GAS_EQUATION * temperature / volume
		var/alist/ratios = get_liquid_ratios()
		for(var/gasid in liquids)
			var/decl/material/mat = GET_DECL(gasid)
			var/temperature_factor = Clamp(((temperature - mat.melting_point) / (mat.boiling_point - mat.melting_point))**2, 0.1, 1)
			pressure_to_cache += ONE_ATMOSPHERE * temperature_factor * ratios[gasid]
	pressure = max(pressure_to_cache, 0)
	if(pressure_to_cache < 0)
		PRINT_STACK_TRACE("Negative pressure result in cache_pressure()")

// Doesn't update it's heat capacity on its own. Useful for reactor interiors with high specific heats, for example.
/datum/gas_mixture/constant_heat_capacity/heat_capacity()
	return heat_capacity

/datum/gas_mixture/constant_heat_capacity/cache_heat_capacity()
	return