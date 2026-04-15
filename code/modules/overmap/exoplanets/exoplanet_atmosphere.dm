/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_atmosphere()


	var/target_temp = get_target_temperature()
	var/target_pressure = get_target_pressure()

	//Make sure temperature can't damage people on casual planets
	if(habitability_class <= HABITABILITY_OKAY)
		var/decl/species/S = get_species_by_key(global.using_map.default_species)
		target_temp = clamp(target_temp, S.cold_level_1 + rand(1,5), S.heat_level_1 - rand(1,5))

	//Skip fun gas gen for perfect terran worlds
	if(habitability_class == HABITABILITY_IDEAL)
		for(var/datum/level_data/level_data in zlevels)
			level_data.exterior_atmos_temp = target_temp
			level_data.exterior_atmosphere = alist(
				/decl/material/gas/oxygen = MOLES_O2STANDARD,
				/decl/material/gas/nitrogen = MOLES_N2STANDARD
			)
			level_data.setup_level_data() //#FIXME: That's not very nice! Calling this again, when it should have been called before?
		return

	var/total_moles = MOLES_CELLSTANDARD

	//Add the non-negotiable gasses
	var/badflag = 0
	var/gas_list = get_mandatory_gasses()
	for(var/g in gas_list)
		total_moles = max(0, total_moles - gas_list[g])
		var/decl/material/mat = GET_DECL(g)
		if(mat.gas_flags & XGM_GAS_OXIDIZER)
			badflag |= XGM_GAS_FUEL
		if(mat.gas_flags & XGM_GAS_FUEL)
			badflag |= XGM_GAS_OXIDIZER

	//Breathable planet
	if(habitability_class == HABITABILITY_OKAY)
		badflag |= XGM_GAS_CONTAMINANT

	var/alist/newgases = alist()
	var/list/all_materials = decls_repository.get_decls_of_subtype(/decl/material)
	for(var/mat_type in all_materials)
		var/decl/material/mat = all_materials[mat_type]
		if(mat.exoplanet_rarity == MAT_RARITY_NOWHERE)
			continue
		// don't allow non-gaseous phases
		// this may be overly strict? in theory we could have vapor as long as it won't condense
		if(mat.phase_at_temperature(target_temp, target_pressure) != MAT_PHASE_GAS)
			continue
		if(!isnull(mat.gas_condensation_point) && mat.gas_condensation_point <= target_temp)
			continue
		if(mat.gas_flags & badflag)
			continue
		newgases[mat.type] = mat.exoplanet_rarity

	if(prob(50)) //alium gas should be slightly less common than mundane shit
		newgases -= /decl/material/gas/alien

	// Prune gases that won't stay gaseous
	for(var/g in newgases)
		var/decl/material/mat = GET_DECL(g)
		if(mat.gas_flags & badflag)
			newgases -= g

	if(length(newgases))
		var/gasnum = rand(1,4)
		var/i = 1
		// unrolling apickweight here to make it faster
		// plus adding a bit of pick_and_take
		var/sum = values_sum(newgases)
		while(i <= gasnum && total_moles && newgases.len)
			var/index_picked = rand(1, sum)
			var/chosen_gas = null
			for(var/newgas, amount in newgases)
				index_picked -= amount
				if(index_picked <= 0)
					sum -= amount // can't re-roll it
					chosen_gas = newgas
					break
			newgases -= chosen_gas

			// Make sure atmosphere is not flammable
			var/decl/material/chosen_mat = GET_DECL(chosen_gas)
			if(chosen_mat.gas_flags & XGM_GAS_OXIDIZER)
				for(var/g in newgases)
					var/decl/material/other_mat = GET_DECL(g)
					if(other_mat.gas_flags & XGM_GAS_FUEL)
						newgases -= g
			if(chosen_mat.gas_flags & XGM_GAS_FUEL)
				for(var/g in newgases)
					var/decl/material/other_mat = GET_DECL(g)
					if(other_mat.gas_flags & XGM_GAS_OXIDIZER)
						newgases -= g

			var/part = total_moles * rand(20,80)/100 //allocate percentage to it
			if(i == gasnum || !newgases.len) //if it's last gas, let it have all remaining moles
				part = total_moles
			gas_list[chosen_gas] += part
			total_moles = max(total_moles - part, 0)
			i++

	// Add all gasses, adjusted for target temperature and pressure
	var/target_moles = target_pressure * CELL_VOLUME / (target_temp * R_IDEAL_GAS_EQUATION)
	var/list/set_gasmix = list()
	for(var/g in gas_list)
		var/adjusted_moles = gas_list[g] * target_moles / MOLES_CELLSTANDARD
		set_gasmix[g] = adjusted_moles
	for(var/datum/level_data/level_data in zlevels)
		level_data.exterior_atmos_temp = target_temp
		level_data.exterior_atmosphere = set_gasmix.Copy()
		level_data.setup_level_data()

//List of gases that will be always present. Amounts are given assuming total of MOLES_CELLSTANDARD in atmosphere
/obj/effect/overmap/visitable/sector/exoplanet/proc/get_mandatory_gasses()
	if(habitability_class == HABITABILITY_OKAY)
		return list(/decl/material/gas/oxygen = MOLES_O2STANDARD)
	return list()

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_target_temperature()
	return T20C + rand(-5,5)

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_target_pressure()
	return ONE_ATMOSPHERE * rand(8, 12)/10

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_habitability()
	var/roll = rand(1,100)
	switch(roll)
		if(1 to 10)
			habitability_class = HABITABILITY_IDEAL
		if(11 to 50)
			habitability_class = HABITABILITY_OKAY
		else
			habitability_class = HABITABILITY_BAD