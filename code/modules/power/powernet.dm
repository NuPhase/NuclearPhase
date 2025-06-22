/datum/powernet
	var/list/cables = list()	// all cables & junctions
	var/list/nodes = list()		// all connected machines

	var/load = 0				// the current load on the powernet, increased by each machine at processing
	var/newavail = 0			// what available power was gathered last tick, then becomes...
	var/viewload = 0			// the load as it appears on the power console (gradually updated)
	var/number = 0				// Unused //TODEL

	var/smes_demand = 0			// Amount of power demanded by all SMESs from this network. Needed for load balancing.
	var/list/inputting = list()	// List of SMESs that are demanding power from this network. Needed for load balancing.

	var/smes_avail = 0			// Amount of power (lavailable) from SMESes. Used by SMES load balancing
	var/smes_newavail = 0		// As above, just for newavail

	var/perapc = 0			// per-apc avilability
	var/perapc_excess = 0
	var/netexcess = 0			// excess power on the powernet (typically lavailable-load)

	var/problem = 0				// If this is not 0 there is some sort of issue in the powernet. Monitors will display warnings.

	var/voltage = 0
	var/newvoltage = 0

	var/losses = 0
	var/last_losses = 0
	var/ldemand = 0
	var/demand = 0 // W
	var/lavailable = 0 // The sum of all power that generators currently provide
	var/available = 0 // W
	var/max_power = 0 // The sum of power that all generators on the network can provide
	var/battery_demand = 0 // How much power can batteries draw to charge

/datum/powernet/proc/add_power(a, v)
	if((voltage - 0.1) >= v)
		return
	newvoltage = v
	available += a * v

/datum/powernet/proc/add_power_w(w, v)
	if((voltage - 0.1) >= v)
		return
	newvoltage = v
	available += w

/datum/powernet/proc/load()
	return min(ldemand, lavailable)

/datum/powernet/New()
	START_PROCESSING_POWERNET(src)
	..()

/datum/powernet/Destroy()
	for(var/obj/structure/cable/C in cables)
		cables -= C
		C.powernet = null
	for(var/obj/machinery/power/M in nodes)
		nodes -= M
		M.powernet = null
	STOP_PROCESSING_POWERNET(src)
	return ..()

//Returns the amount of excess power (before refunding to SMESs) from last tick.
//This is for machines that might adjust their power consumption using this data.
/datum/powernet/proc/last_surplus()
	return max(max_power - ldemand, 0)

/datum/powernet/proc/draw_power(w)
	demand += w
	return min(w, last_surplus())

/datum/powernet/proc/is_empty()
	return !cables.len && !nodes.len

/datum/powernet/proc/handle_generators()
	var/list/generators = list()
	var/list/batteries = list()

	max_power = 0
	for(var/obj/machinery/power/generator/G in nodes)
		var/free_power = G.available_power()
		max_power += free_power
		if(istype(G, /obj/machinery/power/generator/battery))
			batteries[G] = free_power
			continue
		if(free_power)
			generators[G] = free_power

	for(var/obj/machinery/power/generator/transformer/transf in nodes)
		if(transf.should_transfer_demand)
			var/transferred_demand = demand + losses
			transf.connected.powernet.demand += transferred_demand

	var/projected_demand = (max(ldemand, demand) * 1.05) + battery_demand // 5% operational reserve

	if(length(generators) > 1)
		var/power_to_draw = projected_demand
		var/generators_to_draw = length(generators)
		var/power_per_generator = power_to_draw/generators_to_draw
		var/interp_coef = 1/generators_to_draw

		for(var/obj/machinery/power/generator/G in generators)
			generators_to_draw--
			var/power_available = G.available_power()
			var/actually_drawn = min(power_per_generator, power_available)
			G.on_power_drain(actually_drawn)
			var/power_debt = power_per_generator - actually_drawn
			if(generators_to_draw > 0) // We're not the last one
				power_per_generator += power_debt/generators_to_draw
			available += actually_drawn
			if(newvoltage == 0)
				newvoltage = G.get_voltage()
			else
				newvoltage = Interpolate(voltage, G.get_voltage(), interp_coef)
	else if(length(generators))
		var/obj/machinery/power/generator/G = generators[1]
		var/power_to_draw = projected_demand
		var/power_available = G.available_power()
		var/actually_drawn = min(power_to_draw, power_available)
		G.on_power_drain(actually_drawn)
		available += actually_drawn
		newvoltage = G.get_voltage()

	if(!length(batteries)) // NO BATTERIES??
		return
	if((projected_demand - battery_demand) > (available - battery_demand)) // We still don't have enough power, UNLEASH BATTERIES
		var/deficit = (projected_demand - battery_demand) - (available - battery_demand)
		var/actually_drawn = discharge_batteries(batteries, deficit)
		available += actually_drawn
	else // We've got excess
		var/excess = available - demand
		charge_batteries(batteries, excess)

/datum/powernet/proc/discharge_batteries(list/batteries, power_demand)
	var/power_per_battery = power_demand/length(batteries)
	var/actually_drawn = 0
	for(var/obj/machinery/power/generator/battery/B in batteries)
		var/available_power = B.available_power()
		if(!available_power)
			continue
		B.on_power_drain(power_per_battery)
		actually_drawn += power_per_battery
	return actually_drawn

/datum/powernet/proc/charge_batteries(list/batteries, power_excess)
	var/divided_power = (power_excess / length(batteries)) * CELLRATE

	for(var/obj/machinery/power/generator/battery/cur_bat in batteries)
		cur_bat.capacity = min(cur_bat.max_capacity, cur_bat.capacity + divided_power)

/datum/powernet/proc/handle_batteries()
	battery_demand = 0
	for(var/obj/machinery/power/generator/battery/cur_bat in nodes)
		if(cur_bat.capacity >= cur_bat.max_capacity)
			continue // fully charged
		battery_demand += cur_bat.voltage * cur_bat.amperage

//remove a cable from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DON'T check if the cable exists
/datum/powernet/proc/remove_cable(var/obj/structure/cable/C)
	cables -= C
	C.powernet = null
	if(is_empty())//the powernet is now empty...
		qdel(src)///... delete it

//add a cable to the current powernet
//Warning : this proc DON'T check if the cable exists
/datum/powernet/proc/add_cable(var/obj/structure/cable/C)
	if(C.powernet)// if C already has a powernet...
		if(C.powernet == src)
			return
		else
			C.powernet.remove_cable(C) //..remove it
	C.powernet = src
	cables +=C

//remove a power machine from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DON'T check if the machine exists
/datum/powernet/proc/remove_machine(var/obj/machinery/power/M)
	nodes -=M
	M.powernet = null
	if(is_empty())//the powernet is now empty...
		qdel(src)///... delete it - qdel


//add a power machine to the current powernet
//Warning : this proc DON'T check if the machine exists
/datum/powernet/proc/add_machine(var/obj/machinery/power/M)
	if(M.powernet)// if M already has a powernet...
		if(M.powernet == src)
			return
		else
			M.disconnect_from_network()//..remove it
	M.powernet = src
	nodes[M] = M

// Triggers warning for certain amount of ticks
/datum/powernet/proc/trigger_warning(var/duration_ticks = 20)
	problem = max(duration_ticks, problem)

//handles the power changes in the powernet
//called every ticks by the powernet controller
/datum/powernet/proc/reset()
	//var/numapc = 0

	if(problem > 0)
		problem = max(problem - 1, 0)
	if(voltage)
		var/obj/structure/cable/C = pick(cables)
		var/turf/T = get_turf(C)
		var/datum/gas_mixture/environment = T.return_air()
		var/used = draw_power(0.0001 * POWERNET_HEAT(src, (C.resistance * cables.len)))
		environment.add_thermal_energy(used)
		losses += used

	handle_batteries()
	handle_generators()

	netexcess = lavailable - load()

	//updates the viewed load (as seen on power computers)
	viewload = round(load())

	//reset the powernet
	smes_avail = smes_newavail
	inputting.Cut()
	smes_demand = 0
	voltage = newvoltage
	newvoltage = 0
	ldemand = demand
	demand = 0
	lavailable = available
	available = 0
	last_losses = losses
	losses = 0

/datum/powernet/proc/get_percent_load(var/smes_only = 0)
	if(smes_only)
		var/smes_used = load() - (lavailable - smes_avail) 			// SMESs are always last to provide power
		if(!smes_used || smes_used < 0 || !smes_avail)			// SMES power isn't available or being used at all, SMES load is therefore 0%
			return 0
		return between(0, (smes_used / smes_avail) * 100, 100)	// Otherwise return percentage load of SMESs.
	else
		if(!load())
			return 0
		return between(0, (lavailable / load()) * 100, 100)

/datum/powernet/proc/get_electrocute_damage()
	return sqrt(lavailable * (voltage/1000))

////////////////////////////////////////////////
// Misc.
///////////////////////////////////////////////


// return a knot cable (O-X) if one is present in the turf
// null if there's none
/turf/proc/get_cable_node()
	for(var/obj/structure/cable/C in src)
		if(C.d1 == 0)
			return C

/area/proc/get_apc()
	return apc
