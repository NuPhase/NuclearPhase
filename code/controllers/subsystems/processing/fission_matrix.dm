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
	var/rod_autocontrol = FALSE

	var/thermal_power = 0

	var/void_coefficient = 0.0005
	var/void_factor = 1
	var/temp_factor = 1
	var/recirc_flow = 10 // 10-100

	var/pressure_setpoint = 7100

	var/datum/gas_mixture/constant_heat_capacity/fuel
	var/datum/gas_mixture/constant_pressure/core
	var/datum/gas_mixture/vessel

/datum/fission_matrix/New()
	generate_matrix()
	assign_neighbors()

	fuel = new(15000, 615 CELSIUS)
	fuel.solids[/decl/material/solid/metal/depleted_uranium] = 300000 * 0.95
	fuel.solids[/decl/material/solid/metal/uranium] = 300000 * 0.05
	fuel.solids[/decl/material/solid/metal/rare_metals] = 300 // burnable poison
	fuel.gas[/decl/material/gas/helium] = 1000
	fuel.update_values()
	fuel.heat_capacity = 10000000 // 10MJ/K

	core = new(15000)
	core.liquids[/decl/material/liquid/water] = 250000
	core.gas[/decl/material/gas/oxygen] = 1
	core.update_values()

	vessel = new(800000, 315 CELSIUS)
	vessel.liquids[/decl/material/liquid/water] = 22222222 // almost exactly 400 tons of water
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

	temp_factor = fuel.temperature * 0.0001
	var/absorb_coef = Clamp(equiv_rod_position + temp_factor + void_factor, 0, 1)

	var/rod_thermal_coef = 1 - (absorb_coef*0.95) // very likely to catch thermals
	var/rod_fast_coef = 1 - (absorb_coef*0.7)

	slow_neutrons *= rod_thermal_coef
	fast_neutrons *= rod_fast_coef

	fast_neutrons += 0.00000000001

	var/scatter_add = Clamp((void_factor * -1) + (1-vessel.available_volume/vessel.volume), 0, 1)

	var/pre_temp = fuel.temperature
	var/list/returned_list = fuel.handle_nuclear_reactions(slow_neutrons, fast_neutrons, handle_escape = FALSE, add_scatter = scatter_add)
	slow_neutrons = max(returned_list["slow_neutrons_changed"], 0)
	fast_neutrons = max(returned_list["fast_neutrons_changed"], 0)
	thermal_power = ((fuel.temperature - pre_temp) * fuel.heat_capacity) / 10000000

	handle_thermal()
	handle_mixing()

	total_neutrons = fast_neutrons + slow_neutrons

	var/split_neutrons = total_neutrons / length(assemblies)
	for(var/datum/fission_assembly/A in assemblies)
		A.flux += split_neutrons

	to_world("[thermal_power]")
	if(vessel.pressure > pressure_setpoint)
		var/moles = vessel.gas[/decl/material/liquid/water] - ((pressure_setpoint * vessel.available_volume) / (R_IDEAL_GAS_EQUATION * vessel.temperature))
		vessel.gas[/decl/material/liquid/water] = max(1, vessel.gas[/decl/material/liquid/water] - moles)

	var/wanted_fluid_moles = vessel.volume * 0.5 / 0.018
	if(vessel.liquids[/decl/material/liquid/water] < wanted_fluid_moles)
		vessel.adjust_gas_temp(/decl/material/liquid/water, wanted_fluid_moles - vessel.liquids[/decl/material/liquid/water], 60 CELSIUS)

	if(rod_autocontrol)
		if(total_neutrons > target_flux)
			change_rod(equiv_rod_position + 0.0005)
		else
			change_rod(equiv_rod_position - 0.0005)

/datum/fission_matrix/proc/handle_mixing()
	core.pressure = vessel.pressure
	if(core.available_volume > 1000)
		var/fill_moles = (core.available_volume * 0.99) / 0.018 * (recirc_flow * 0.01)
		core.merge(vessel.remove_phase(fill_moles, MAT_PHASE_LIQUID))
	vessel.merge(core.remove_phase(core.gas[/decl/material/liquid/water], MAT_PHASE_GAS))
	var/moved_moles = recirc_flow * 100000
	core.merge(vessel.remove_phase(moved_moles, MAT_PHASE_LIQUID))
	vessel.merge(core.remove(moved_moles))

/datum/fission_matrix/proc/handle_thermal()
	handle_heat_transfer()
	void_factor = core.gas[/decl/material/liquid/water] * (void_coefficient / recirc_flow)

/datum/fission_matrix/proc/handle_heat_transfer()
	var/temp_diff = fuel.temperature - core.temperature
	if(temp_diff < 1)
		return
	var/heat_transfer = temp_diff * fuel.heat_capacity
	core.add_thermal_energy(heat_transfer)
	fuel.add_thermal_energy(heat_transfer * -1)

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

// Fast-forwards fuel decay a set amount of hours.
/datum/fission_matrix/proc/skip_decay(hours)
	if(!hours)
		return
	var/minute_flux = total_neutrons * 600
	for(var/i in 1 to hours * 60) // process irradiation
		var/pre_temp = fuel.temperature
		fuel.handle_nuclear_reactions(0, minute_flux, handle_escape = FALSE, add_scatter = 1)
		fuel.temperature = pre_temp
	for(var/i in 1 to hours * 60) // remove decay products
		var/pre_temp = fuel.temperature
		fuel.handle_nuclear_reactions(0, 0.00000000001)
		fuel.temperature = pre_temp
	fuel.adjust_gas(/decl/material/solid/metal/rare_metals, -hours)


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