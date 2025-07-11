/datum/gas_mixture
	//Associative list of gas moles.
	//Gases with 0 moles are not tracked and are pruned by update_values()
	var/list/gas = list()
	var/list/liquids = list()
	var/list/solids = list()

	//Temperature in Kelvin of this gas mix.
	var/temperature = T20C
	var/pressure = ONE_ATMOSPHERE
	var/heat_capacity = 0

	var/suction_moles = 0

	//Sum of all the gas moles in this mix.  Updated by update_values()
	var/total_moles = 0
	var/gas_moles = 0
	//Volume of this mix.
	var/volume = CELL_VOLUME
	var/available_volume = CELL_VOLUME
	//Size of the group this gas_mixture is representing.  1 for singletons.
	var/group_multiplier = 1

	//List of active tile overlays for this gas_mixture.  Updated by check_tile_graphic()
	var/list/graphic = list()
	//Cache of gas overlay objects
	var/list/tile_overlay_cache

	var/atom/holder = null //for chemistry
	var/net_flow_mass = 0 //kg/s, updated from networks

/datum/gas_mixture/New(_volume = CELL_VOLUME, _temperature = T20C, _group_multiplier = 1, initial_gas = null)
	volume = _volume
	available_volume = volume
	temperature = _temperature
	group_multiplier = _group_multiplier
	if(initial_gas)
		for(var/g in initial_gas)
			var/decl/material/mat = GET_DECL(g)
			if(temperature > mat.boiling_point)
				gas[g] = initial_gas[g]
			else if(temperature > mat.melting_point)
				liquids[g] = initial_gas[g]
			else
				solids[g] = initial_gas[g]
	update_values()

// Returns a list of specified fluid states.
// if gasid isn't specified, returns a list of all gases with specified states
// fluid_types can be a list or a single define.
/datum/gas_mixture/proc/get_fluid(gasid, list/fluid_types)
	var/list/returned_list = list()
	if(islist(fluid_types))
		for(var/ftype in fluid_types)
			if(gasid)
				switch(ftype)
					if(MAT_PHASE_GAS)
						returned_list[gasid] += gas[gasid]
					if(MAT_PHASE_LIQUID)
						returned_list[gasid] += liquids[gasid]
					if(MAT_PHASE_SOLID)
						returned_list[gasid] += solids[gasid]
			else
				switch(ftype)
					if(MAT_PHASE_GAS)
						for(var/g in gas)
							returned_list[g] += gas[g]
					if(MAT_PHASE_LIQUID)
						for(var/g in liquids)
							returned_list[g] += liquids[g]
					if(MAT_PHASE_SOLID)
						for(var/g in solids)
							returned_list[g] += solids[g]
	else if(fluid_types) // a single define
		if(gasid)
			switch(fluid_types)
				if(MAT_PHASE_GAS)
					returned_list[gasid] += gas[gasid]
				if(MAT_PHASE_LIQUID)
					returned_list[gasid] += liquids[gasid]
				if(MAT_PHASE_SOLID)
					returned_list[gasid] += solids[gasid]
		else
			switch(fluid_types)
				if(MAT_PHASE_GAS)
					for(var/g in gas)
						returned_list[g] += gas[g]
				if(MAT_PHASE_LIQUID)
					for(var/g in liquids)
						returned_list[g] += liquids[g]
				if(MAT_PHASE_SOLID)
					for(var/g in solids)
						returned_list[g] += solids[g]
	else // no specified filter, collect everything
		if(gasid)
			returned_list[gasid] += gas[gasid]
			returned_list[gasid] += liquids[gasid]
			returned_list[gasid] += solids[gasid]
		else
			for(var/g in gas)
				returned_list[g] += gas[g]
			for(var/g in liquids)
				returned_list[g] += liquids[g]
			for(var/g in solids)
				returned_list[g] += solids[g]
	return returned_list

/datum/gas_mixture/proc/get_gas(gasid)
	if(!length(gas))
		return 0 //if the list is empty BYOND treats it as a non-associative list, which runtimes
	return gas[gasid] * group_multiplier

/datum/gas_mixture/proc/get_total_moles()
	return total_moles * group_multiplier

/datum/gas_mixture/proc/remove_gas(gasid, moles)
	moles = abs(moles) // we pass negative values too
	if(gas[gasid])
		var/removed_moles = min(moles, gas[gasid])
		gas[gasid] -= removed_moles
		moles -= removed_moles
	if(moles > 0)
		if(liquids[gasid])
			var/removed_moles = min(moles, liquids[gasid])
			liquids[gasid] -= removed_moles
			moles -= removed_moles
		if(moles > 0 && solids[gasid])
			solids[gasid] -= moles

//Takes a gas string and the amount of moles to adjust by.  Calls update_values() if update isn't 0.
/datum/gas_mixture/proc/adjust_gas(gasid, moles, update = TRUE, calculate_phase_change = TRUE)
	if(moles == 0)
		return

	var/decl/material/mat = GET_DECL(gasid)
	if(group_multiplier != 1)
		moles = moles/group_multiplier

	if(moles > 0)
		var/boiling_point
		if(calculate_phase_change && GAME_STATE >= RUNLEVEL_GAME)
			boiling_point = mat.get_boiling_temp(return_pressure())
		else
			boiling_point = mat.boiling_point
		if(temperature > boiling_point)
			gas[gasid] += moles
		else if(temperature > mat.melting_point)
			liquids[gasid] += moles
		else
			solids[gasid] += moles
	else
		remove_gas(gasid, moles)

	if(update)
		update_values()

//Same as adjust_gas(), but takes a temperature which is mixed in with the gas.
/datum/gas_mixture/proc/adjust_gas_temp(gasid, moles, temp, update = TRUE, calculate_phase_change = TRUE)
	if(moles == 0)
		return

	var/decl/material/mat = GET_DECL(gasid)
	if(moles > 0 && abs(temperature - temp) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()
		var/giver_heat_capacity = mat.gas_specific_heat * moles
		var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity != 0)
			temperature = (temp * giver_heat_capacity + temperature * self_heat_capacity) / combined_heat_capacity
			add_thermal_energy(0, TRUE, TRUE) // Allow for phase changes to happen

	if(group_multiplier != 1)
		moles = moles/group_multiplier

	if(moles > 0)
		var/boiling_point
		if(calculate_phase_change && GAME_STATE >= RUNLEVEL_GAME)
			boiling_point = mat.get_boiling_temp(return_pressure())
		else
			boiling_point = mat.boiling_point
		if(temp > boiling_point)
			gas[gasid] += moles
		else if(temp > mat.melting_point)
			liquids[gasid] += moles
		else
			solids[gasid] += moles
	else
		remove_gas(gasid, moles)

	if(update)
		update_values()

//Variadic version of adjust_gas().  Takes any number of gas and mole pairs and applies them.
/datum/gas_mixture/proc/adjust_multi()
	ASSERT(!(args.len % 2))

	for(var/i = 1; i < args.len; i += 2)
		adjust_gas(args[i], args[i+1], update = 0)

	update_values()


//Variadic version of adjust_gas_temp().  Takes any number of gas, mole and temperature associations and applies them.
/datum/gas_mixture/proc/adjust_multi_temp()
	ASSERT(!(args.len % 3))

	for(var/i = 1; i < args.len; i += 3)
		adjust_gas_temp(args[i], args[i + 1], args[i + 2], update = 0)

	update_values()


//Merges all the gas from another mixture into this one.  Respects group_multipliers and adjusts temperature correctly.
//Does not modify giver in any way.
/datum/gas_mixture/proc/merge(const/datum/gas_mixture/giver, update=TRUE)
	if(!giver)
		return

	if(abs(temperature-giver.temperature)>MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()
		var/giver_heat_capacity = giver.heat_capacity()
		var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity != 0)
			temperature = (giver.temperature*giver_heat_capacity + temperature*self_heat_capacity)/combined_heat_capacity

	if((group_multiplier != 1)||(giver.group_multiplier != 1))
		var/list/all_fluid = giver.get_fluid()
		for(var/g in all_fluid)
			adjust_gas(g, all_fluid[g] * giver.group_multiplier, update, update)
	else
		for(var/g in giver.gas)
			gas[g] += giver.gas[g]
		for(var/g in giver.liquids)
			liquids[g] += giver.liquids[g]
		for(var/g in giver.solids)
			solids[g] += giver.solids[g]

	add_thermal_energy(0, TRUE, TRUE) // Allow for phase changes to happen

	if(update)
		update_values()

// Used to equalize the mixture between two zones before sleeping an edge.
/datum/gas_mixture/proc/equalize(datum/gas_mixture/sharer)
	var/our_heatcap = heat_capacity()
	var/share_heatcap = sharer.heat_capacity()

	// Special exception: there isn't enough air around to be worth processing this edge next tick, zap both to zero.
	if(total_moles + sharer.total_moles <= MINIMUM_AIR_TO_SUSPEND)
		gas.Cut()
		sharer.gas.Cut()

	for(var/g in gas|sharer.gas)
		var/comb = gas[g] + sharer.gas[g]
		comb /= volume + sharer.volume
		gas[g] = comb * volume
		sharer.gas[g] = comb * sharer.volume

	if(our_heatcap + share_heatcap)
		temperature = ((temperature * our_heatcap) + (sharer.temperature * share_heatcap)) / (our_heatcap + share_heatcap)
	sharer.temperature = temperature

	update_values()
	sharer.update_values()

	return 1

//Returns the heat capacity of the gas mix based on the specific heat of the gases.
/datum/gas_mixture/proc/heat_capacity()
	if(!heat_capacity)
		cache_heat_capacity()
	return heat_capacity

/datum/gas_mixture/proc/cache_heat_capacity()
	heat_capacity = 0
	var/list/all_fluid = get_fluid()
	for(var/g in all_fluid)
		var/decl/material/mat = GET_DECL(g)
		if(!mat)
			return
		heat_capacity += mat.gas_specific_heat * all_fluid[g]
	heat_capacity *= max(1, group_multiplier)

//Adds or removes thermal energy. Returns the actual thermal energy change, as in the case of removing energy we can't go below TCMB.
/datum/gas_mixture/proc/add_thermal_energy(thermal_energy=0, calculate_phase_change=TRUE, forced=FALSE)

	if (total_moles == 0)
		return 0

	if(heat_capacity <= 0)
		return 0

	if(calculate_phase_change && GAME_STATE >= RUNLEVEL_GAME && (abs(thermal_energy) > 50 || forced))
		thermal_energy = make_phase_changes(thermal_energy)

	if (thermal_energy < 0)
		if (temperature < TCMB)
			return 0
		var/thermal_energy_limit = -(temperature - TCMB)*heat_capacity	//ensure temperature does not go below TCMB
		thermal_energy = max( thermal_energy, thermal_energy_limit )	//thermal_energy and thermal_energy_limit are negative here.
	temperature += thermal_energy/heat_capacity
	return thermal_energy

//Returns the thermal energy change required to get to a new temperature
/datum/gas_mixture/proc/get_thermal_energy_change(var/new_temperature)
	return heat_capacity()*(max(new_temperature, 0) - temperature)


//Technically vacuum doesn't have a specific entropy. Just use a really big number (infinity would be ideal) here so that it's easy to add gas to vacuum and hard to take gas out.
#define SPECIFIC_ENTROPY_VACUUM		150000


//Returns the ideal gas specific entropy of the whole mix. This is the entropy per mole of /mixed/ gas.
/datum/gas_mixture/proc/specific_entropy()
	if (!length(gas) || total_moles == 0)
		return SPECIFIC_ENTROPY_VACUUM

	. = 0
	var/list/all_fluid = get_fluid()
	for(var/g in all_fluid)
		. += all_fluid[g] * specific_entropy_gas(g, all_fluid)
	. /= total_moles


/*
	It's arguable whether this should even be called entropy anymore. It's more "based on" entropy than actually entropy now.

	Returns the ideal gas specific entropy of a specific gas in the mix. This is the entropy due to that gas per mole of /that/ gas in the mixture, not the entropy due to that gas per mole of gas mixture.

	For the purposes of SS13, the specific entropy is just a number that tells you how hard it is to move gas. You can replace this with whatever you want.
	Just remember that returning a SMALL number == adding gas to this gas mix is HARD, taking gas away is EASY, and that returning a LARGE number means the opposite (so a vacuum should approach infinity).

	So returning a constant/(partial pressure) would probably do what most players expect. Although the version I have implemented below is a bit more nuanced than simply 1/P in that it scales in a way
	which is bit more realistic (natural log), and returns a fairly accurate entropy around room temperatures and pressures.
*/
/datum/gas_mixture/proc/get_decl_for_rust(var/gasid) // shitty shit
	return GET_DECL(gasid)

/datum/gas_mixture/proc/specific_entropy_gas(var/gasid, var/list/all_fluid)
	if (!(gasid in all_fluid) || all_fluid[gasid] == 0)
		return SPECIFIC_ENTROPY_VACUUM	//that gas isn't here

	//group_multiplier gets divided out in volume/gas[gasid] - also, V/(m*T) = R/(partial pressure)
	var/decl/material/mat = GET_DECL(gasid)
	var/specific_heat = mat.gas_specific_heat
	var/safe_temp = max(temperature, TCMB) // We're about to divide by this.
	return R_IDEAL_GAS_EQUATION * ( log( (IDEAL_GAS_ENTROPY_CONSTANT*volume/(all_fluid[gasid] * safe_temp)) * (mat.molar_mass*specific_heat*safe_temp)**(2/3) + 1 ) +  15 )

	//alternative, simpler equation
	//var/partial_pressure = gas[gasid] * R_IDEAL_GAS_EQUATION * temperature / volume
	//return R_IDEAL_GAS_EQUATION * ( log (1 + IDEAL_GAS_ENTROPY_CONSTANT/partial_pressure) + 20 )

//Updates the total_moles count and trims any empty gases.
/datum/gas_mixture/proc/update_values()
	total_moles = 0
	gas_moles = 0
	var/liquid_volume = 0
	var/solid_volume = 0
	prune_empty_values()
	var/list/all_fluid = get_fluid()
	for(var/g in all_fluid)
		total_moles += all_fluid[g]
	for(var/g in liquids)
		var/decl/material/mat = GET_DECL(g)
		liquid_volume += liquids[g] * mat.molar_mass / mat.liquid_density * 1000
	for(var/g in solids)
		var/decl/material/mat = GET_DECL(g)
		liquid_volume += solids[g] * mat.molar_mass / mat.solid_density * 1000
	for(var/g in gas)
		gas_moles += gas[g]
	available_volume = max(volume * 0.01, volume - liquid_volume - solid_volume)
	cache_heat_capacity()
	cache_pressure()
	if(temperature < 0)
		PRINT_STACK_TRACE("Negative temperature in update_values()")
		temperature = TCMB

/datum/gas_mixture/proc/prune_empty_values()
	for(var/g in gas)
		if(gas[g] <= 0 || isnull(g))
			gas -= g
	for(var/g in liquids)
		if(liquids[g] <= 0 || isnull(g))
			liquids -= g
	for(var/g in solids)
		if(solids[g] <= 0 || isnull(g))
			solids -= g

//Returns the pressure of the gas mix.
/datum/gas_mixture/proc/return_pressure()
	return pressure

//Only accurate if there have been no gas modifications since update_values() has been called.
/datum/gas_mixture/proc/cache_pressure()
	var/pressure_to_cache = 0
	if(volume)
		if(gas_moles)
			pressure_to_cache = gas_moles * R_IDEAL_GAS_EQUATION * temperature / available_volume
		else
			pressure_to_cache = total_moles * R_IDEAL_GAS_EQUATION * temperature / volume
		for(var/g in liquids)
			var/decl/material/mat = GET_DECL(g)
			var/temperature_factor = max((temperature - mat.melting_point) / mat.boiling_point, 0.1) //should be 1 at boiling point and 0 at melting point
			pressure_to_cache += liquids[g] * ONE_ATMOSPHERE * temperature_factor / volume
	pressure = max(pressure_to_cache, 0)
	if(pressure_to_cache < 0)
		PRINT_STACK_TRACE("Negative pressure result in cache_pressure()")

//Removes moles from the gas mixture and returns a gas_mixture containing the removed air.
/datum/gas_mixture/proc/remove(amount)
	if(amount < 0)
		PRINT_STACK_TRACE("Negative value supplied to remove()")
		return
	amount = min(amount, total_moles * group_multiplier) //Can not take more air than the gas mixture has!
	if(amount <= 0)
		return null

	var/list/new_gas = list()
	var/list/new_liquids = list()
	var/list/new_solids = list()

	var/list/all_fluid = get_fluid()
	for(var/g in all_fluid)
		var/moles_left_to_remove = QUANTIZE((all_fluid[g] / total_moles) * amount)
		var/moles_taken
		if(solids[g])
			moles_taken = min(solids[g], moles_left_to_remove)
			solids[g] -= moles_taken/group_multiplier
			moles_left_to_remove -= moles_taken
			new_solids[g] = moles_taken
		if(0 >= moles_left_to_remove)
			continue
		if(liquids[g])
			moles_taken = min(liquids[g], moles_left_to_remove)
			liquids[g] -= moles_taken/group_multiplier
			moles_left_to_remove -= moles_taken
			new_liquids[g] = moles_taken
		if(0 >= moles_left_to_remove)
			continue
		moles_taken = min(gas[g], moles_left_to_remove)
		gas[g] -= moles_taken/group_multiplier
		moles_left_to_remove -= moles_taken
		new_gas[g] = moles_taken
		if(moles_left_to_remove >= ATMOS_PRECISION)
			PRINT_STACK_TRACE("Fluid loss in gas_mixture/remove()")

/*
	var/list/removed_gas_list = list()
	var/list/all_fluid = get_fluid()

	for(var/g in all_fluid)
		removed_gas_list[g] = QUANTIZE((all_fluid[g] / total_moles) * amount)
		adjust_gas(g, -removed_gas_list[g], FALSE)
*/
	var/datum/gas_mixture/removed = new(_volume = volume, _temperature = temperature)
	removed.gas = new_gas
	removed.liquids = new_liquids
	removed.solids = new_solids

	update_values()
	removed.update_values()

	return removed


//Removes a ratio of gas from the mixture and returns a gas_mixture containing the removed air.
/datum/gas_mixture/proc/remove_ratio(ratio, out_group_multiplier = 1)
	if(ratio <= 0)
		PRINT_STACK_TRACE("Negative value supplied to remove_ratio()")
		return null
	out_group_multiplier = between(1, out_group_multiplier, group_multiplier)

	ratio = min(ratio, 1)

	var/list/removed_gas_list = list()
	var/list/all_fluid = get_fluid()

	for(var/g in all_fluid)
		removed_gas_list[g] = (all_fluid[g] * ratio * group_multiplier / out_group_multiplier)
		adjust_gas(g, -removed_gas_list[g])

	var/datum/gas_mixture/removed = new(_volume = volume * group_multiplier / out_group_multiplier, _temperature = temperature, _group_multiplier = out_group_multiplier, initial_gas = removed_gas_list)

	update_values()
	removed.update_values()

	return removed

//Removes a volume of gas from the mixture and returns a gas_mixture containing the removed air with the given volume
/datum/gas_mixture/proc/remove_volume(removed_volume)
	var/datum/gas_mixture/removed = remove_ratio(removed_volume/(volume*group_multiplier), 1)
	removed.volume = removed_volume
	removed.available_volume = removed_volume
	removed.update_values()
	return removed

//Removes moles from the gas mixture, limited by a given flag.  Returns a gas_mixture containing the removed air.
/datum/gas_mixture/proc/remove_by_flag(flag, amount, mat_flag = FALSE)
	var/datum/gas_mixture/removed = new

	if(!flag || amount <= 0)
		if(amount < 0)
			PRINT_STACK_TRACE("Negative value supplied to remove_by_flag()")
		return removed

	var/sum = 0
	for(var/g in gas)
		var/decl/material/mat = GET_DECL(g)
		var/list/check = mat_flag ? mat.flags : mat.gas_flags
		if(check & flag)
			sum += gas[g]

	for(var/g in gas)
		var/decl/material/mat = GET_DECL(g)
		var/list/check = mat_flag ? mat.flags : mat.gas_flags
		if(check & flag)
			removed.gas[g] = QUANTIZE((gas[g] / sum) * amount)
			gas[g] -= removed.gas[g] / group_multiplier

	removed.temperature = temperature
	update_values()
	removed.update_values()

	return removed

//Returns the amount of gas that has the given flag, in moles
/datum/gas_mixture/proc/get_by_flag(flag)
	. = 0
	for(var/g in gas)
		var/decl/material/mat = GET_DECL(g)
		if(mat.gas_flags & flag)
			. += gas[g]

//Copies gas and temperature from another gas_mixture.
/datum/gas_mixture/proc/copy_from(const/datum/gas_mixture/sample)
	gas = sample.gas.Copy()
	graphic = sample.graphic.Copy()
	temperature = sample.temperature
	update_values()
	return 1

//Checks if we are within acceptable range of another gas_mixture to suspend processing or merge.
/datum/gas_mixture/proc/compare(const/datum/gas_mixture/sample, var/vacuum_exception = 0)
	if(!sample) return 0

	if(vacuum_exception)
		// Special case - If one of the two is zero pressure, the other must also be zero.
		// This prevents suspending processing when an air-filled room is next to a vacuum,
		// an edge case which is particually obviously wrong to players
		if(total_moles == 0 && sample.total_moles != 0 || sample.total_moles == 0 && total_moles != 0)
			return 0

	var/list/marked = list()
	for(var/g in gas)
		if((abs(gas[g] - sample.gas[g]) > MINIMUM_AIR_TO_SUSPEND) && \
		((gas[g] < (1 - MINIMUM_AIR_RATIO_TO_SUSPEND) * sample.gas[g]) || \
		(gas[g] > (1 + MINIMUM_AIR_RATIO_TO_SUSPEND) * sample.gas[g])))
			return 0
		marked[g] = 1

	if(abs(return_pressure() - sample.return_pressure()) > MINIMUM_PRESSURE_DIFFERENCE_TO_SUSPEND)
		return 0

	for(var/g in sample.gas)
		if(!marked[g])
			if((abs(gas[g] - sample.gas[g]) > MINIMUM_AIR_TO_SUSPEND) && \
			((gas[g] < (1 - MINIMUM_AIR_RATIO_TO_SUSPEND) * sample.gas[g]) || \
			(gas[g] > (1 + MINIMUM_AIR_RATIO_TO_SUSPEND) * sample.gas[g])))
				return 0

	if(total_moles > MINIMUM_AIR_TO_SUSPEND)
		if((abs(temperature - sample.temperature) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) && \
		((temperature < (1 - MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND)*sample.temperature) || \
		(temperature > (1 + MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND)*sample.temperature)))
			return 0

	return 1

//Rechecks the gas_mixture and adjusts the graphic list if needed.
//Two lists can be passed by reference if you need know specifically which graphics were added and removed.
/datum/gas_mixture/proc/check_tile_graphic(list/graphic_add = null, list/graphic_remove = null)
	for(var/obj/effect/gas_overlay/O in graphic)
		if(gas[O.material.type] <= O.material.gas_overlay_limit)
			LAZYADD(graphic_remove, O)
	for(var/g in gas)
		//Overlay isn't applied for this gas, check if it's valid and needs to be added.
		var/decl/material/mat = GET_DECL(g)
		if(!isnull(mat.gas_overlay_limit) && gas[g] > mat.gas_overlay_limit)
			if(!LAZYACCESS(tile_overlay_cache, g))
				LAZYSET(tile_overlay_cache, g, new /obj/effect/gas_overlay(null, g))
			var/tile_overlay = tile_overlay_cache[g]
			if(!(tile_overlay in graphic))
				LAZYADD(graphic_add, tile_overlay)
	. = 0

	//Apply changes
	if(graphic_add && length(graphic_add))
		graphic |= graphic_add
		. = 1
	if(graphic_remove && length(graphic_remove))
		graphic -= graphic_remove
		. = 1
	if(length(graphic))
		var/pressure_mod = Clamp(return_pressure() / ONE_ATMOSPHERE, 0, 2)
		for(var/obj/effect/gas_overlay/O in graphic)
			var/concentration_mod = Clamp(gas[O.material.type] / total_moles, 0.1, 1)
			var/new_alpha = min(230, round(pressure_mod * concentration_mod * 180, 5))
			if(new_alpha != O.alpha)
				O.update_alpha_animation(new_alpha)

//Simpler version of merge(), adjusts gas amounts directly and doesn't account for temperature or group_multiplier.
/datum/gas_mixture/proc/add(datum/gas_mixture/right_side)
	var/list/all_fluid = right_side.get_fluid()
	for(var/g in all_fluid)
		gas[g] += all_fluid[g]

	update_values()
	return 1

//Simpler version of remove(), adjusts gas amounts directly and doesn't account for group_multiplier.
/datum/gas_mixture/proc/subtract(datum/gas_mixture/right_side)
	var/list/all_fluid = right_side.get_fluid()
	for(var/g in all_fluid)
		remove_gas(g, all_fluid[g])

	update_values()
	return 1


//Multiply all gas amounts by a factor.
/datum/gas_mixture/proc/multiply(factor, update=TRUE)
	for(var/g in gas)
		gas[g] *= factor
	for(var/g in liquids)
		liquids[g] *= factor
	for(var/g in solids)
		solids[g] *= factor

	if(update)
		update_values()
	return 1


//Divide all gas amounts by a factor.
/datum/gas_mixture/proc/divide(factor, update=TRUE)
	for(var/g in gas)
		gas[g] /= factor
	for(var/g in liquids)
		liquids[g] /= factor
	for(var/g in solids)
		solids[g] /= factor

	if(update)
		update_values()
	return 1

#define IN 1
#define OUT 2
#define RATIO_PER_SQRT_KPA_PRESSURE_DIFF 0.035
/datum/gas_mixture/proc/share_ratio(datum/gas_mixture/other, connecting_tiles=1, share_size = null, one_way = 0)
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
			var/datum/gas_mixture/taken_gas = other.remove(moles_to_transfer)
			merge(taken_gas)
			return compare(other)
		var/pressure_coeff = R_IDEAL_GAS_EQUATION * other.temperature / other.volume //Pressure per mole of gas
		var/minimum_moles_to_keep = our_pressure / pressure_coeff
		var/free_moles = (other.total_moles * other.group_multiplier) - minimum_moles_to_keep
		var/moles_to_transfer = free_moles * share_ratio
		var/datum/gas_mixture/taken_gas = other.remove(moles_to_transfer)
		merge(taken_gas)

	return compare(other)

#undef IN
#undef OUT
#undef RATIO_PER_SQRT_KPA_PRESSURE_DIFF

//A wrapper around share_ratio for spacing gas at the same rate as if it were going into a large airless room.
/datum/gas_mixture/proc/share_space(datum/gas_mixture/unsim_air)
	return share_ratio(unsim_air, unsim_air.group_multiplier, max(1, max(group_multiplier + 3, 1) + unsim_air.group_multiplier), one_way = 1)

//Equalizes a list of gas mixtures.  Used for pipe networks.
/proc/equalize_gases(list/datum/gas_mixture/gases)
	//Calculate totals from individual components
	var/total_volume = 0
	var/total_thermal_energy = 0
	var/total_heat_capacity = 0

	var/list/total_gas = list()
	var/list/total_liquids = list()
	var/list/total_solids = list()
	for(var/datum/gas_mixture/gasmix in gases)
		total_volume += gasmix.volume
		var/temp_heatcap = gasmix.heat_capacity()
		total_thermal_energy += gasmix.temperature * temp_heatcap
		total_heat_capacity += temp_heatcap
		for(var/g in gasmix.gas)
			total_gas[g] += gasmix.gas[g]
		for(var/g in gasmix.liquids)
			total_liquids[g] += gasmix.liquids[g]
		for(var/g in gasmix.solids)
			total_solids[g] += gasmix.solids[g]

	if(total_volume > 0)
		var/resulting_temperature = T20C
		if(total_heat_capacity > 0)
			resulting_temperature = total_thermal_energy / total_heat_capacity
		var/datum/gas_mixture/combined = new(total_volume, resulting_temperature)
		combined.gas = total_gas
		combined.liquids = total_liquids
		combined.solids = total_solids

		combined.update_values()

		//Allow for reactions
		combined.fire_react()

		combined.divide(total_volume)

		//Update individual gas_mixtures
		for(var/datum/gas_mixture/gasmix in gases)
			gasmix.gas = combined.gas.Copy()
			gasmix.liquids = combined.liquids.Copy()
			gasmix.solids = combined.solids.Copy()
			gasmix.temperature = combined.temperature
			gasmix.multiply(gasmix.volume)

	return 1

// Combines and redistributes gas in a list.
/proc/equalize_gases_vacuum(list/datum/gas_mixture/gases)
	var/combined_volume = 0
	var/combined_energy = 0
	var/combined_heat_capacity = 0
	var/combined_moles = 0
	var/combined_suction = 0

	var/list/combined_gas = list()
	var/list/combined_liquids = list()
	var/list/combined_solids = list()

	for(var/datum/gas_mixture/gasmix in gases)
		var/temp_heatcap = gasmix.heat_capacity()
		combined_volume += gasmix.volume
		combined_energy += temp_heatcap * gasmix.temperature
		combined_heat_capacity += temp_heatcap
		combined_moles += gasmix.total_moles
		combined_suction += gasmix.suction_moles
		for(var/g in gasmix.gas)
			combined_gas[g] += gasmix.gas[g]
		for(var/g in gasmix.liquids)
			combined_liquids[g] += gasmix.liquids[g]
		for(var/g in gasmix.solids)
			combined_solids[g] += gasmix.solids[g]

	if(combined_volume <= 0)
		return

	if(combined_suction >= combined_moles)
		combined_suction = combined_moles * 0.5

	var/resulting_temperature = T20C
	if(combined_heat_capacity > 0)
		resulting_temperature = combined_energy / combined_heat_capacity
	var/average_pressure = (combined_moles - combined_suction) * R_IDEAL_GAS_EQUATION * resulting_temperature / combined_volume

	var/datum/gas_mixture/combined = new(combined_volume, resulting_temperature)
	combined.gas = combined_gas
	combined.liquids = combined_liquids
	combined.solids = combined_solids

	combined.update_values()
	combined.fire_react()

	for(var/datum/gas_mixture/gasmix in gases)
		var/moles_for_pressure = (average_pressure * gasmix.volume) / (R_IDEAL_GAS_EQUATION * resulting_temperature)
		var/moles_to_transfer = moles_for_pressure + gasmix.suction_moles
		gasmix.gas = list()
		gasmix.liquids = list()
		gasmix.solids = list()
		gasmix.heat_capacity = 0
		gasmix.total_moles = 0
		gasmix.gas_moles = 0
		gasmix.merge(combined.remove(moles_to_transfer))
	return 1

/datum/gas_mixture/proc/get_mass()
	var/list/all_fluid = get_fluid()
	for(var/g in all_fluid)
		var/decl/material/mat = GET_DECL(g)
		. += all_fluid[g] * mat.molar_mass * group_multiplier

// Returns the average density of all materials in this fluidmix in kg/m^3
/datum/gas_mixture/proc/get_density()
	var/total_mass = 0
	var/total_volume = 0
	for(var/g in gas)
		var/decl/material/mat = GET_DECL(g)
		var/ind_mass = gas[g] * mat.molar_mass
		var/ind_volume = ind_mass / 1
		total_mass += ind_mass
		total_volume += ind_volume
	for(var/g in liquids)
		var/decl/material/mat = GET_DECL(g)
		var/ind_mass = liquids[g] * mat.molar_mass
		var/ind_volume = ind_mass / mat.liquid_density
		total_mass += ind_mass
		total_volume += ind_volume
	for(var/g in solids)
		var/decl/material/mat = GET_DECL(g)
		var/ind_mass = solids[g] * mat.molar_mass
		var/ind_volume = ind_mass / mat.solid_density
		total_mass += ind_mass
		total_volume += ind_volume
	if(!total_volume)
		return 0
	return total_mass/total_volume

/datum/gas_mixture/proc/specific_mass()
	var/M = get_total_moles()
	if(M)
		return get_mass()/M

/datum/gas_mixture/proc/remove_air_volume(volume_to_return)
	var/datum/gas_mixture/removed = remove(return_pressure()*volume_to_return*((R_IDEAL_GAS_EQUATION*temperature)**-1))
	if(removed)
		removed.volume = volume_to_return
		removed.available_volume = volume_to_return
		removed.update_values()
	return removed

/datum/gas_mixture/proc/get_taken_volume()
	return volume - available_volume

/datum/gas_mixture/proc/handle_nuclear_reactions(slow_neutrons, fast_neutrons)
	var/energy_delta = 0
	var/list/all_fluid = get_fluid()
	for(var/g in all_fluid)
		var/decl/material/mat = GET_DECL(g)
		if(!mat.neutron_interactions)
			continue
		var/list/returned_list = mat.handle_nuclear_fission(src, slow_neutrons, fast_neutrons)
		slow_neutrons = returned_list["slow_neutrons_changed"]
		fast_neutrons = returned_list["fast_neutrons_changed"]
		energy_delta += returned_list["thermal_energy_released"]
	add_thermal_energy(energy_delta)
	update_values()
	return list(
		"slow_neutrons_changed" = slow_neutrons,
		"fast_neutrons_changed" = fast_neutrons
	)

// catherine was here
// CGM v1
// 07.08.24 - 16.08.24