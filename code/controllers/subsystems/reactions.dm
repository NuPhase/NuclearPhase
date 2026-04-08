var/global/obj/reactions_reagents_holder = new

SUBSYSTEM_DEF(reactions)
	name = "Reactions"
	wait = 2 SECONDS
	priority = SS_PRIORITY_REACTIONS
	flags = SS_NO_INIT | SS_NO_FIRE

	var/list/fusion_reactions = list()

/datum/controller/subsystem/reactions/proc/process_gasmix(datum/gas_mixture/gasmix, firelevel)
	var/list/all_fluid = gasmix.get_fluid()
	if(!length(all_fluid))
		return

	var/list/react_list = process_reactions(all_fluid.Copy(), gasmix.temperature, gasmix.heat_capacity(), gasmix.pressure, gasmix.volume, firelevel)
	var/list/result_fluid = react_list[1]

	var/list/combined_list = result_fluid.Copy()

	for(var/f_type in all_fluid)
		if((f_type in combined_list))
			continue
		combined_list.Add(f_type)

	for(var/f_type in combined_list)
		if(result_fluid[f_type] == all_fluid[f_type]) // no change
			continue
		var/difference = result_fluid[f_type] - all_fluid[f_type]
		gasmix.adjust_gas(f_type, difference, FALSE)

	gasmix.temperature = react_list[2]
	gasmix.update_values()

	/*
	if(length(gasmix.gas))
		var/list/reacted_list = process_reactions(gasmix.gas, gasmix.temperature, null, gasmix.pressure, gasmix.volume)
		gasmix.gas = reacted_list[1]
		gasmix.temperature = reacted_list[2]
	if(length(gasmix.liquids))
		var/list/reacted_list = process_reactions(gasmix.liquids, gasmix.temperature, null, gasmix.pressure, gasmix.volume)
		gasmix.liquids = reacted_list[1]
		gasmix.temperature = reacted_list[2]
	if(length(gasmix.solids))
		var/list/reacted_list = process_reactions(gasmix.solids, gasmix.temperature, null, gasmix.pressure, gasmix.volume)
		gasmix.solids = reacted_list[1]
		gasmix.temperature = reacted_list[2]
	*/

/datum/controller/subsystem/reactions/proc/process_reactions(list/moles, temperature, heat_capacity, pressure = ONE_ATMOSPHERE, volume, firelevel)
	var/has_fuel = FALSE
	var/has_oxidizer = FALSE
	var/old_temperature = temperature
	for(var/g in moles)
		var/decl/material/mat = GET_DECL(g)
		if(mat.combustion_energy)
			has_fuel = TRUE
		if(mat.oxidizer_power)
			has_oxidizer = TRUE
	if(!heat_capacity)
		heat_capacity = 0
		for(var/g in moles)
			var/decl/material/mat = GET_DECL(g)
			heat_capacity += moles[g] * mat.gas_specific_heat

	var/list/chem_return_list = process_reaction_chem(moles, temperature, heat_capacity, pressure, volume)
	moles = chem_return_list[1]
	temperature = chem_return_list[2]

	// Process combustion
	if(has_fuel && has_oxidizer)
		var/list/return_list = process_reaction_oxidation(moles, temperature, heat_capacity, pressure, volume, firelevel)
		moles = return_list[1]
		temperature = return_list[2]
		heat_capacity = return_list[3]
		pressure = return_list[4]

	return list(moles, temperature, old_temperature)

#define PRE_EXPONENTIAL_FACTOR 10**7
// n = concentration * k
// concentration is in moles per liter
/datum/controller/subsystem/reactions/proc/get_reaction_rate(reactant_moles, activation_energy, temperature, volume, firelevel)
	var/firelevel_add = 0
	if(firelevel)
		firelevel_add = firelevel * 0.01
	return min(reactant_moles, ((reactant_moles/volume) * get_reaction_rate_constant(activation_energy, temperature)) + firelevel_add)

// k = PRE_EXPONENTIAL_FACTOR * EULER**-(activation_energy/8.314*temperature)
/datum/controller/subsystem/reactions/proc/get_reaction_rate_constant(activation_energy, temperature)
	return PRE_EXPONENTIAL_FACTOR * EULER**(-(activation_energy/(8.314*temperature)))

#undef PRE_EXPONENTIAL_FACTOR

/datum/controller/subsystem/reactions/proc/process_reaction_chem(list/moles, temperature, heat_capacity, pressure = ONE_ATMOSPHERE, volume)
	reactions_reagents_holder.temperature = temperature
	var/datum/reagents/pressurized/temp_holder = new(10000000000000, reactions_reagents_holder)
	temp_holder.pressure = pressure
	for(var/mat_type in moles)
		var/decl/material/mat = GET_DECL(mat_type)
		LAZYSET(temp_holder.reagent_volumes, mat_type, moles[mat_type] * mat.molar_volume)
	temp_holder.update_total()
	temp_holder.process_reactions()
	moles.Cut()
	for(var/mat_type in temp_holder.reagent_volumes)
		var/decl/material/mat = GET_DECL(mat_type)
		moles[mat_type] = temp_holder.reagent_volumes[mat_type] / mat.molar_volume
	return list(moles, reactions_reagents_holder.temperature)

/datum/controller/subsystem/reactions/proc/process_reaction_oxidation(list/moles, temperature, heat_capacity, pressure = ONE_ATMOSPHERE, volume, firelevel)
	var/list/oxidizers = list()
	var/list/oxidizers_by_power = list()
	var/list/fuels = list()
	var/thermal_energy = temperature * heat_capacity
	var/total_moles = 0
	for(var/g in moles)
		total_moles += moles[g]
		var/decl/material/mat = GET_DECL(g)
		if(mat.combustion_energy && mat.combustion_products)
			fuels[g] = moles[g]
		if(mat.oxidizer_power)
			oxidizers_by_power[g] = mat.oxidizer_power

	// Sort oxidizers and use the one with the lowest oxidizer_power first.
	oxidizers_by_power = sortTim(oxidizers_by_power, /proc/cmp_numeric_asc, TRUE)
	for(var/g in oxidizers_by_power)
		oxidizers[g] = moles[g]

	// Remove all reactants from the fuel list temporarily
	moles.Remove(oxidizers, fuels)

	for(var/g in oxidizers)
		for(var/f in fuels)
			var/decl/material/fuel_mat = GET_DECL(f)
			if((thermal_energy * fuels[f] < fuel_mat.combustion_activation_energy * total_moles) && !firelevel)
				continue
			var/need_fuel_moles = oxidizers[g] / fuel_mat.oxidizer_to_fuel_ratio
			var/actually_spent_fuel = min(fuels[f], need_fuel_moles, oxidizers_by_power[g] * get_reaction_rate(fuels[f], fuel_mat.combustion_activation_energy, temperature, volume, firelevel))
			var/actually_spent_oxidizer = actually_spent_fuel * fuel_mat.oxidizer_to_fuel_ratio
			var/product
			if(fuel_mat.combustion_products[g])
				product = fuel_mat.combustion_products[g]
			else
				product = fuel_mat.combustion_products[/decl/material/gas/oxygen]
			fuels[f] -= actually_spent_fuel
			oxidizers[g] -= actually_spent_oxidizer
			moles[product] += actually_spent_fuel
			thermal_energy += actually_spent_fuel * fuel_mat.combustion_energy
			if(!oxidizers[g])
				break

	for(var/g in oxidizers)
		moles[g] += oxidizers[g]
	for(var/g in fuels)
		moles[g] += fuels[g]
	temperature = thermal_energy / heat_capacity

	return list(moles, temperature, heat_capacity, pressure)

/datum/controller/subsystem/reactions/proc/test_combustion(mob/user)
	to_chat(user, "--------------------")
	for(var/i=1, i<20, i++)
		var/list/react_result = process_reactions(list(/decl/material/gas/hydrogen = 60, /decl/material/gas/oxygen = 30), 100*i, 6600, volume = 1000)
		to_chat(user, "T: [100*i] ===> T: [round(react_result[2], 0.1)] H: [round(react_result[1][/decl/material/gas/hydrogen], 0.1)] O: [round(react_result[1][/decl/material/gas/oxygen], 0.1)]")
	to_chat(user, "--------------------")
	for(var/i=1, i<20, i++)
		var/list/react_result = process_reactions(list(/decl/material/gas/hydrogen = 300/i, /decl/material/gas/oxygen = 30), 3500, 6600, volume = 1000)
		to_chat(user, "T: 3500 ===> T: [round(react_result[2], 0.1)] H: [round(react_result[1][/decl/material/gas/hydrogen], 0.1)] O: [round(react_result[1][/decl/material/gas/oxygen], 0.1)]")
	to_chat(user, "--------------------")



// Nuclear code starts here

/*
	ALL nuclear reactions should only be handled here.
	First, we calculate the reaction probability per cm, then apply length to get the probability of fission, capture or escape
	To get reaction probabilities, we first get the fraction of neutrons that get moderated
	s - scatter rate, u - fission rate, t - absorption rate, x - distance
	z_{moderated}=sx
	Then we interpolate the cross sections based on the moderated fraction
	After that, we can calculate the fractions of other reactions
	z_{fission}=\frac{u}{t+u}\cdot\left(1-e^{-\left(t+u\right)x}\right)
	z_{absorb}=\frac{t}{t+u}\cdot\left(1-e^{-\left(t+u\right)x}\right)
	z_{escape}=e^{-\left(t+u\right)x}
	The fission fraction generates more fast neutrons and energy
	The absorb fraction simply removes neutrons
	The escape fraction contributes to var/escaped_n which is used in some places
*/

/datum/controller/subsystem/reactions/proc/process_reaction_nuclear(list/moles, temperature, heat_capacity, volume, fast_neutrons, slow_neutrons)
	var/thermal_energy = temperature * heat_capacity
	var/radial_distance = sphere_radius_from_volume(volume)

	var/scatter_prob = get_average_cross_section(moles, INTERACTION_SCATTER, fast_neutrons, slow_neutrons, volume)
	var/z_scatter = min(scatter_prob * radial_distance, 1)

	var/scattered = fast_neutrons * z_scatter
	fast_neutrons -= scattered
	slow_neutrons += scattered

	var/fission_prob = get_average_cross_section(moles, INTERACTION_FISSION, fast_neutrons, slow_neutrons, volume)
	var/absorb_prob = get_average_cross_section(moles, INTERACTION_ABSORPTION, fast_neutrons, slow_neutrons, volume)

	var/euler_exp = EULER**(-(absorb_prob+fission_prob)*radial_distance)
	var/z_fission = (fission_prob/(absorb_prob+fission_prob)) * (1-euler_exp)
	var/z_absorb = (absorb_prob/(absorb_prob+fission_prob)) * (1-euler_exp)
	var/z_escape = euler_exp

	var/total_neutrons = fast_neutrons + slow_neutrons
	var/n_fission = z_fission * total_neutrons
	var/n_absorb = z_absorb * total_neutrons
	var/n_escape = z_escape * total_neutrons

	var/fast_absorb_fraction = fast_neutrons / (slow_neutrons + fast_neutrons)
	fast_neutrons -= fast_absorb_fraction * n_escape
	slow_neutrons -= (1 - fast_absorb_fraction) * n_escape

	var/list/fissile_moles = list()
	var/fissile_total = 0
	for(var/mat_type in moles)
		var/decl/material/mat = GET_DECL(mat_type)
		if(!mat.neutron_interactions || !mat.neutron_interactions["slow"][INTERACTION_FISSION])
			continue
		fissile_moles[mat_type] = moles[mat_type]
		fissile_total += moles[mat_type]

	for(var/mat_type in fissile_moles)
		var/decl/material/mat = GET_DECL(mat_type)
		var/fraction = fissile_moles[mat_type] / fissile_total
		var/fission_moles = n_fission * fraction
		var/fast_fraction = fast_neutrons / (slow_neutrons + fast_neutrons)
		fast_neutrons -= fast_fraction * fission_moles
		slow_neutrons -= (1 - fast_fraction) * fission_moles
		fast_neutrons += mat.fission_neutrons * fission_moles
		thermal_energy += mat.fission_energy * fission_moles
		if(mat.fission_products)
			for(var/waste_type in mat.fission_products)
				moles[waste_type] += mat.fission_products[waste_type] * fission_moles

	var/total_moles = 0
	for(var/mat_type in moles)
		total_moles += moles[mat_type]

	for(var/mat_type in moles)
		var/decl/material/mat = GET_DECL(mat_type)
		var/fraction = moles[mat_type] / total_moles
		var/absorb_moles = n_absorb * fraction
		fast_neutrons -= fast_absorb_fraction * absorb_moles
		slow_neutrons -= (1 - fast_absorb_fraction) * absorb_moles
		if(mat.absorption_products)
			for(var/waste_type in mat.absorption_products)
				moles[waste_type] += mat.absorption_products[waste_type] * absorb_moles

	temperature = thermal_energy / heat_capacity
	return list(moles, temperature, fast_neutrons, slow_neutrons)

// Goes through all moles and constructs an average probability per cm3
/datum/controller/subsystem/reactions/proc/get_average_cross_section(list/moles, reaction_type, fast_neutrons, slow_neutrons, volume)
	var/total_moles = 0
	for(var/mat_type in moles)
		total_moles += moles[mat_type]

	if(total_moles <= 0)
		return 0

	var/average_prob_per_cm = 0
	for(var/mat_type in moles)
		var/decl/material/mat = GET_DECL(mat_type)
		var/mat_prob_cm = mat.get_nuclear_cross_section(moles, reaction_type, fast_neutrons, slow_neutrons, volume)
		if(mat_prob_cm)
			var/fraction = moles[mat_type] / total_moles
			average_prob_per_cm += fraction * mat_prob_cm

	return average_prob_per_cm

/datum/controller/subsystem/reactions/proc/test_nuclear()
	to_chat(usr, "--------------------")
	var/fast_neutrons = 0.1
	var/slow_neutrons = 0
	var/temperature = T20C
	for(var/i=1, i<100, i++)
		var/list/moles = list(
			/decl/material/solid/metal/depleted_uranium = 85,
			/decl/material/solid/metal/uranium = 15
			)
		var/list/react_result = process_reaction_nuclear(moles, temperature, 10000000, 100, fast_neutrons, slow_neutrons)
		temperature = react_result[2]
		fast_neutrons = react_result[3]
		slow_neutrons = react_result[4]
		to_chat(usr, "T: [round(react_result[2])] | FN: [round(react_result[3], 0.0001)] | SN: [round(react_result[4], 0.0001)]")
	to_chat(usr, "--------------------")
	fast_neutrons = 0.1
	slow_neutrons = 0
	temperature = T20C
	var/list/moles = list(
			/decl/material/solid/metal/depleted_uranium = 85,
			/decl/material/solid/metal/uranium = 15
			)
	for(var/i=1, i<100, i++)
		var/list/react_result = process_reaction_nuclear(moles, temperature, 10000000, 100, fast_neutrons, slow_neutrons)
		moles = react_result[1]
		temperature = react_result[2]
		fast_neutrons = react_result[3]
		slow_neutrons = react_result[4]
		to_chat(usr, "T: [round(react_result[2])] | FN: [round(react_result[3], 0.0001)] | SN: [round(react_result[4], 0.0001)]")