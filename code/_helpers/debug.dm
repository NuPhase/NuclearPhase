#ifdef DEBUG_ENVIRONMENT

#define MAX_CYCLES 100
// Enrichment percentage is how much U-235 is in the mix.
/proc/debug_neutron_economy(var/enrichment_percentage = 0.15, var/initial_nmoles = 0.1, var/initial_fuel = 10000, var/moderator = 1, var/neutron_loss = 0.01)
	var/slow_moles = initial_nmoles * 0.5
	var/fast_moles = initial_nmoles * 0.5
	var/cycle_count = 1
	var/datum/gas_mixture/gasmix = new(CELL_VOLUME, 80)
	gasmix.solids[/decl/material/solid/metal/depleted_uranium] = initial_fuel * (1-enrichment_percentage)
	gasmix.solids[/decl/material/solid/metal/uranium] = initial_fuel * enrichment_percentage
	gasmix.solids[/decl/material/solid/graphite] = moderator
	while(((slow_moles + fast_moles) > 0.0000001 && cycle_count < MAX_CYCLES))
		sleep(0.1)
		cycle_count++
		var/list/returned_list = gasmix.handle_nuclear_reactions(slow_moles, fast_moles)
		slow_moles = max(returned_list["slow_neutrons_changed"], 0)
		fast_moles = max(returned_list["fast_neutrons_changed"], 0)
		fast_moles -= fast_moles * neutron_loss
		slow_moles -= slow_moles * neutron_loss
		to_world("N: [round(slow_moles + fast_moles, 0.0000001)] S+F: ([round(slow_moles, 0.0000001)]+[round(fast_moles, 0.0000001)])")
	to_world("Test ended.")

#undef MAX_CYCLES

#endif