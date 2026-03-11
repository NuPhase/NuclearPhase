PROCESSING_SUBSYSTEM_DEF(fission)
	name = "Fission Matrices"
	priority = SS_PRIORITY_MOB
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 0.1 SECONDS



//var/datum/fission_matrix/test_matrix = new

/datum/fission_matrix
	var/list/assemblies = list()
	var/list/grid = list() // lookup: "x,y" -> assembly
	var/radius = 4

	var/fast_neutrons = 0
	var/slow_neutrons = 0
	var/total_neutrons = 0

	var/target_flux = 0.0001

	var/datum/gas_mixture/constant_heat_capacity/fuel
	var/datum/gas_mixture/vessel

/datum/fission_matrix/New()
	generate_matrix()
	assign_neighbors()

	fuel = new(15000, T20C)
	fuel.solids[/decl/material/solid/metal/depleted_uranium] = 300000 * 0.85
	fuel.solids[/decl/material/solid/metal/uranium] = 300000 * 0.15
	fuel.gas[/decl/material/gas/oxygen] = 1
	fuel.update_values()
	fuel.heat_capacity = 400000000 // 0.4GJ/K

	vessel = new(500000, T20C)
	vessel.liquids[/decl/material/liquid/water] = 11111111 // almost exactly 200 tons of water
	vessel.gas[/decl/material/gas/oxygen] = 1
	vessel.update_values()

	START_PROCESSING(SSfission, src)

/datum/fission_matrix/Process()
	for(var/datum/fission_assembly/A in assemblies)
		A.flux -= A.flux * (A.rod_position * 0.8) // rods aren't 100% effective
		var/flux_lost = A.flux * 0.5
		for(var/datum/fission_assembly/AA in A.neighbors)
			AA.flux += flux_lost / length(A.neighbors)

	var/rod_position_sum = 0
	for(var/datum/fission_assembly/A in assemblies)
		rod_position_sum += A.rod_position
	var/equiv_rod_position = rod_position_sum / length(assemblies)

	var/rod_thermal_coef = 1 - (equiv_rod_position*0.95) // very likely to catch thermals
	var/rod_fast_coef = 1 - (equiv_rod_position*0.7)

	slow_neutrons *= rod_thermal_coef
	fast_neutrons *= rod_fast_coef

	slow_neutrons += 0.00000000001

	var/list/returned_list = fuel.handle_nuclear_reactions(slow_neutrons, fast_neutrons)
	slow_neutrons = max(returned_list["slow_neutrons_changed"], 0)
	fast_neutrons = max(returned_list["fast_neutrons_changed"], 0)

	var/list/moderated_list = vessel.handle_nuclear_reactions(slow_neutrons, fast_neutrons)
	slow_neutrons = max(moderated_list["slow_neutrons_changed"], 0)
	fast_neutrons = max(moderated_list["fast_neutrons_changed"], 0)

	fuel.exchange_heat(vessel)

	total_neutrons = fast_neutrons + slow_neutrons
	//to_world("[total_neutrons]")

	if(total_neutrons > target_flux)
		change_rod(equiv_rod_position + 0.01)
	else
		change_rod(equiv_rod_position - 0.005)

/datum/fission_matrix/proc/change_rod(nrod)
	nrod = Clamp(nrod, 0, 1)
	for(var/datum/fission_assembly/A in assemblies)
		A.rod_position = nrod

/datum/fission_matrix/proc/generate_matrix()
	var/center = radius + 1
	for(var/x = 1 to radius*2+1)
		for(var/y = 1 to radius*2+1)
			var/dx = x - center
			var/dy = y - center
			// circular mask
			if(dx*dx + dy*dy > radius*radius)
				continue
			var/datum/fission_assembly/A = new(x,y)
			assemblies += A
			grid["[x],[y]"] = A

/datum/fission_matrix/proc/assign_neighbors()
	for(var/datum/fission_assembly/A in assemblies)
		var/list/directions = list(
			list( 1, 0),
			list(-1, 0),
			list( 0, 1),
			list( 0,-1)
		)
		for(var/d in directions)
			var/nx = A.x + d[1]
			var/ny = A.y + d[2]
			var/key = "[nx],[ny]"
			if(grid[key])
				A.neighbors += grid[key]
		if(length(A.neighbors) < 4)
			A.leakage = 0.2


/datum/fission_assembly
	var/x
	var/y
	var/list/datum/fission_assembly/neighbors = list()

	var/flux = 0
	var/leakage = 0.02 // 0.02 default, 0.2 for edge assemblies
	var/rod_position = 1 // fully in, 0 - fully out

/datum/fission_assembly/New(_x, _y)
	x = _x
	y = _y