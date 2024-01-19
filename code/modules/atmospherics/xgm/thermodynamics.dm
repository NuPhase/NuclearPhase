
/datum/gas_mixture/proc/update_phases()
	gas_moles = 0
	var/heat_capacity = heat_capacity()
	if(length(gas) && heat_capacity)
		var/new_energy = make_phase_changes(heat_capacity * temperature)
		temperature = new_energy / heat_capacity

//This gets called whenever we add/remove energy from a gasmix. Returns the energy change after phase transitions
/datum/gas_mixture/proc/make_phase_changes(thermal_energy_change)

	var/total_system_heat_capacity = heat_capacity()
	var/final_energy = thermal_energy_change

	var/list/gases = list()
	var/list/liquids = list()

	assemble_phase_list()

	for(var/g in gas)
		if(phases[g][MAT_PHASE_LIQUID] > 0)
			liquids[g] = gas[g]
		else if(phases[g][MAT_PHASE_GAS] > 0)
			gases[g] = gas[g]

	//evaporation
	for(var/liquid in liquids)
		var/decl/material/liquid_mat = GET_DECL(liquid)
		var/liquid_boiling_temp = liquid_mat.get_boiling_temp(return_pressure())
		if(temperature > liquid_boiling_temp)
			var/temperature_delta = temperature - liquid_boiling_temp
			var/excess_energy = temperature_delta * total_system_heat_capacity
			var/liquid_moles_boiled = min(liquids[liquid], excess_energy / liquid_mat.latent_heat)
			excess_energy = liquid_moles_boiled * liquid_mat.latent_heat
			liquids[liquid] -= liquid_moles_boiled
			gases[liquid] += liquid_moles_boiled
			final_energy += excess_energy * -1

	//condensation
	for(var/g in gases)
		var/decl/material/gas_mat = GET_DECL(g)
		var/boiling_temp = gas_mat.get_boiling_temp(return_pressure())
		if(temperature < boiling_temp)
			var/temperature_delta = temperature - boiling_temp
			var/short_energy = temperature_delta * total_system_heat_capacity
			var/gas_moles_condensed = min(gases[g], short_energy / gas_mat.latent_heat)
			short_energy = gas_moles_condensed * gas_mat.latent_heat
			gases[g] += gas_moles_condensed //it's negative so we're ok
			liquids[g] += abs(gas_moles_condensed) //turning negative to positive
			final_energy += abs(short_energy)

	var/liquid_volume = 0
	for(var/g in gases)
		var/adjusted_moles = max(0, gases[g])
		phases[g][MAT_PHASE_GAS] = adjusted_moles
		gas_moles += adjusted_moles
	for(var/l in liquids)
		phases[l][MAT_PHASE_LIQUID] = max(0, liquids[l])
		var/decl/material/mat = GET_DECL(l)
		liquid_volume += liquids[l] * mat.molar_mass / mat.liquid_density * 1000
	available_volume = volume - liquid_volume

	return final_energy

/datum/gas_mixture/proc/assemble_phase_list()
	for(var/g in gas)
		if(!phases[g])
			phases[g] = list()
			if(istype(g, /decl/material/gas))
				phases[g][MAT_PHASE_GAS] = gas[g]
			else
				phases[g][MAT_PHASE_GAS] = 0
			if(istype(g, /decl/material/liquid))
				phases[g][MAT_PHASE_LIQUID] = gas[g]
			else
				phases[g][MAT_PHASE_LIQUID] = 0
			if(istype(g, /decl/material/solid))
				phases[g][MAT_PHASE_SOLID] = gas[g]
			else
				phases[g][MAT_PHASE_SOLID] = 0