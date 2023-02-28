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

	var/ldemand = 0
	var/demand = 0 // W
	var/lavailable = 0 //...the current available power in the powernet
	var/available = 0 // W

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
	return max(lavailable - ldemand, 0)

/datum/powernet/proc/draw_power(w)
	demand += w
	return min(w, last_surplus())

/datum/powernet/proc/is_empty()
	return !cables.len && !nodes.len

/datum/powernet/proc/handle_generators()
	var/list/sorted = list() // unperfomance shit
	for(var/obj/machinery/power/generator/G in nodes)
		sorted[G] = G.available_power()

	if(sorted.len > 1)
		sorted = sortAssoc(sorted)
		var/tcoef = (sorted.len / (sorted.len-1))

		var/tosuck = ldemand
		for(var/A in sorted)
			var/obj/machinery/power/generator/G = A
			var/np = tosuck / sorted.len
			var/ap = sorted[A]
			var/v = G.get_voltage()

			if((voltage - 0.1) >= v || ap < 1)
				tosuck += np * tcoef
				continue

			newvoltage = v
			if(ap >= np)
				G.on_power_drain(np)
			else
				tosuck += (np - ap) * tcoef
				if(ap)
					G.on_power_drain(ap)
			available += ap
	else if(sorted.len)
		var/obj/machinery/power/generator/G = sorted[1]
		var/ap = sorted[G]
		var/v = G.get_voltage()

		if((voltage - 0.1) >= v || ap < 1)
			return
		newvoltage = v
		available += ap
		G.on_power_drain(min(ap, ldemand))

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
	var/coef = min(1, 0.8 + cables.len * 0.045)
	if(voltage)
		var/obj/structure/cable/C = pick(cables)
		var/turf/T = get_turf(C)
		var/datum/gas_mixture/environment = T.return_air()
		var/used = draw_power(POWERNET_HEAT(src, C.resistance) / coef) * cables.len
		environment.add_thermal_energy(POWER2HEAT(used))

	handle_generators()

	/*if(nodes && nodes.len) // Added to fix a bad list bug -- TLE
		for(var/obj/machinery/power/terminal/term in nodes)
			if( istype( term.master_machine(), /obj/machinery/power/apc ) )
				numapc++

	netexcess = lavailable - load

	if(numapc)
		//very simple load balancing. If there was a net excess this tick then it must have been that some APCs used less than perapc, since perapc*numapc = lavailable
		//Therefore we can raise the amount of power rationed out to APCs on the assumption that those APCs that used less than perapc will continue to do so.
		//If that assumption fails, then some APCs will miss out on power next tick, however it will be rebalanced for the tick after.
		if (netexcess >= 0)
			perapc_excess += min(netexcess/numapc, (lavailable - perapc) - perapc_excess)
		else
			perapc_excess = 0

		perapc = lavailable/numapc + perapc_excess

	// At this point, all other machines have finished using power. Anything left over may be used up to charge SMESs.
	if(inputting.len && smes_demand)
		var/smes_input_percentage = between(0, (netexcess / smes_demand) * 100, 100)
		for(var/obj/machinery/power/smes/S in inputting)
			S.input_power(smes_input_percentage)

	netexcess = lavailable - load

	if(netexcess)
		var/perc = get_percent_load(1)
		for(var/obj/machinery/power/smes/S in nodes)
			S.restore(perc)

	//updates the viewed load (as seen on power computers)
	viewload = round(load)
*/

	//reset the powernet
	smes_avail = smes_newavail
	inputting.Cut()
	smes_demand = 0
	smes_newavail = 0
	voltage = newvoltage
	newvoltage = 0
	ldemand = demand
	demand = 0
	lavailable = available
	available = 0

	for(var/obj/machinery/power/generator/transformer/transf in nodes)
		transf.connected.powernet.demand += transf.powernet.ldemand
		transf.connected.powernet.ldemand += transf.powernet.ldemand

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
	switch(POWERNET_AMPERAGE(src))
		if (1000000 to INFINITY)
			return min(rand(50,160),rand(50,160))
		if (200000 to 1000000)
			return min(rand(25,80),rand(25,80))
		if (100000 to 200000)//Ave powernet
			return min(rand(20,60),rand(20,60))
		if (50000 to 100000)
			return min(rand(15,40),rand(15,40))
		if (1000 to 50000)
			return min(rand(10,20),rand(10,20))
		else
			return 0

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
