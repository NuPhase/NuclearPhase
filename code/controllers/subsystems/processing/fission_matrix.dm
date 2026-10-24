PROCESSING_SUBSYSTEM_DEF(fission)
	name = "Fission Matrices"
	priority = SS_PRIORITY_MOB
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 0.1 SECONDS



//var/datum/fission_matrix/test_matrix = new

/datum/fission_matrix
	var/list/assemblies = list()
	var/list/movable_assemblies = list()
	var/list/grid = list() // lookup: "x,y" -> assembly

	var/fast_neutrons = 0
	var/slow_neutrons = 0
	var/total_neutrons = 0
	var/last_neutrons = 0

	var/target_flux = 0.00001

	var/rod_autocontrol = FALSE
	var/reactor_period = 0
	var/target_period = 0
	var/equiv_rod_position = 1

	var/thermal_power = 0

	var/temp_factor = 1
	var/recirc_flow = 10 // 10-100

	var/datum/gas_mixture/fuel
	var/datum/gas_mixture/constant_pressure/core
	var/datum/gas_mixture/vessel

/datum/fission_matrix/New()
	generate_matrix()
	assign_neighbors()

	fuel = new(6000, 3500)
	fuel.solids[/decl/material/solid/metal/depleted_uranium] = 300000 * 0.9
	fuel.solids[/decl/material/solid/metal/plutonium] = 300000 * 0.1
	fuel.gas[/decl/material/gas/helium] = 100
	fuel.gas[/decl/material/gas/xenon] = 0.01
	fuel.gas[/decl/material/solid/iodine/isotope135] = 0.15
	fuel.update_values()
	fuel.temperature = 3500

	core = new(3000, 2700)
	core.liquids[/decl/material/solid/metal/tin] = 176000
	core.gas[/decl/material/gas/helium] = 1
	core.update_values()

	vessel = new(800000, 2700)
	vessel.liquids[/decl/material/solid/metal/tin] = 42400000
	vessel.gas[/decl/material/gas/helium] = 3500
	vessel.update_values()

	START_PROCESSING(SSfission, src)

/datum/fission_matrix/Process()
	var/rod_flux_sum = 0
	for(var/datum/fission_assembly/A in assemblies)
		A.flux -= A.flux * A.leakage
		var/diffusion_loss = A.flux * 0.1
		A.flux -= diffusion_loss
		for(var/datum/fission_assembly/AA in A.neighbors)
			AA.flux += (diffusion_loss / length(A.neighbors)) * AA.rod_position
		rod_flux_sum += A.flux
	var/rod_flux_average = rod_flux_sum / length(assemblies)

	if(rod_flux_average)
		var/core_temp = core.temperature
		var/temp_diff = fuel.temperature - core_temp
		for(var/datum/fission_assembly/A in assemblies)
			A.hotness = A.flux / rod_flux_average
			A.temperature = core_temp + (temp_diff * A.hotness)

	var/rod_position_sum = 0
	for(var/datum/fission_assembly/A in assemblies)
		rod_position_sum += A.rod_position
	equiv_rod_position = rod_position_sum / length(assemblies)

	if(fuel.temperature > 1500)
		temp_factor = (fuel.temperature - 1500) * 0.01
	else
		temp_factor = 0
	var/absorb_coef = Clamp(equiv_rod_position, 0, 1)

	var/rod_thermal_coef = 1 - (absorb_coef*0.95) // very likely to catch thermals
	var/rod_fast_coef = 1 - (absorb_coef*0.7)

	slow_neutrons *= rod_thermal_coef
	fast_neutrons *= rod_fast_coef

	fast_neutrons += 0.00000000001

	var/pre_temp = fuel.temperature
	var/list/returned_list = fuel.handle_nuclear_reactions(slow_neutrons, fast_neutrons, handle_escape = FALSE, add_absorbption = temp_factor + 1)
	slow_neutrons = max(returned_list["slow_neutrons_changed"], 0)
	fast_neutrons = max(returned_list["fast_neutrons_changed"], 0)
	thermal_power = ((fuel.temperature - pre_temp) * fuel.heat_capacity) / 100000

	handle_thermal()
	handle_mixing()

	last_neutrons = total_neutrons
	total_neutrons = fast_neutrons + slow_neutrons

	handle_period()
	handle_autocontrol()

	var/split_neutrons = total_neutrons / length(assemblies)
	for(var/datum/fission_assembly/A in assemblies)
		A.flux += split_neutrons * A.potency * (1 - A.rod_position)

	//to_world("[thermal_power]")

/datum/fission_matrix/proc/handle_mixing()
	core.pressure = vessel.pressure
	if(core.available_volume > 1000)
		var/fill_moles = (core.available_volume * 0.99) / 0.018 * (recirc_flow * 0.01)
		core.merge(vessel.remove_phase(fill_moles, MAT_PHASE_LIQUID))
	var/moved_moles = recirc_flow * 100000
	core.merge(vessel.remove_phase(moved_moles, MAT_PHASE_LIQUID))
	vessel.merge(core.remove_phase(core.gas[/decl/material/solid/metal/tin], MAT_PHASE_GAS))
	vessel.merge(core.remove(moved_moles))

/datum/fission_matrix/proc/handle_thermal()
	handle_heat_transfer()

/datum/fission_matrix/proc/handle_heat_transfer()
	var/temp_diff = fuel.temperature - core.temperature
	if(temp_diff < 1)
		return
	var/heat_transfer = temp_diff * (4000 * recirc_flow)
	core.add_thermal_energy(heat_transfer)
	fuel.add_thermal_energy(heat_transfer * -1)

/datum/fission_matrix/proc/change_rod(nrod)
	nrod = Clamp(nrod, 0, 1)
	for(var/datum/fission_assembly/A in movable_assemblies)
		A.rod_position = nrod

/datum/fission_matrix/proc/adjust_rod(nrod)
	for(var/datum/fission_assembly/A in movable_assemblies)
		A.rod_position = Clamp(A.rod_position + nrod, 0, 1)

/datum/fission_matrix/proc/handle_period()
	if(!last_neutrons)
		return
	var/neutron_ratio = total_neutrons / last_neutrons
	if(abs(neutron_ratio - 1) < 0.0001)
		reactor_period = 0 // meaning infinite
		return
	reactor_period = 0.0693147 / log(neutron_ratio)

/datum/fission_matrix/proc/handle_autocontrol()
	if(rod_autocontrol)
		var/delta_n = abs(total_neutrons - target_flux)
		var/permitted_rod_move_speed = min(0.02 * (delta_n/0.0001), 0.002)
		if(total_neutrons > target_flux)
			target_period = -0.0001 / (total_neutrons - target_flux)
		else
			target_period = 0.0001 / (target_flux - total_neutrons)
		if(reactor_period > 0 && target_period > 0)
			if(reactor_period > target_period)
				adjust_rod(-permitted_rod_move_speed)
			else
				adjust_rod(permitted_rod_move_speed)
		else if(reactor_period < 0 && target_period < 0)
			if(reactor_period > target_period)
				adjust_rod(-permitted_rod_move_speed)
			else
				adjust_rod(permitted_rod_move_speed)
		else if(reactor_period >= 0 && target_period < 0)
			adjust_rod(permitted_rod_move_speed)
		else
			adjust_rod(-permitted_rod_move_speed)

		for(var/datum/fission_assembly/A in movable_assemblies)
			if(A.hotness > 1.1)
				A.rod_position = Clamp(A.rod_position + (permitted_rod_move_speed * 0.1), 0, 1)
				continue
			if(A.hotness < 0.9)
				A.rod_position = Clamp(A.rod_position - (permitted_rod_move_speed * 0.1), 0, 1)

/*
x,y,type,group
type is 1-4
1 - normal
2 - binary
3 - probe
4 - breeder
*/

/datum/fission_matrix/proc/generate_matrix()
	if(fexists("data/reactor_layout.cfg"))
		var/list/entries = file2list("data/reactor_layout.cfg")
		for(var/entry in entries)
			if(!entry)
				continue
			entry = trim(entry)
			if(!length(entry))
				continue
			var/list/data = splittext(entry, ",")
			var/x_cord = text2num(data[1])
			var/y_cord = text2num(data[2])
			var/rod_type
			switch(text2num(data[3]))
				if(1)
					rod_type = /datum/fission_assembly
				if(2)
					rod_type = /datum/fission_assembly/binary
				if(3)
					rod_type = /datum/fission_assembly/probe
				if(4)
					rod_type = /datum/fission_assembly/breeder
			var/datum/fission_assembly/A = new rod_type(x_cord,y_cord)
			assemblies += A
			if(A.has_rod && !A.binary_rod)
				movable_assemblies += A
			grid["[x_cord],[y_cord]"] = A

/datum/fission_matrix/proc/assign_neighbors()
	for(var/datum/fission_assembly/A in assemblies)
		var/list/directions = list(
			list(-1, 1),
			list(-1, -1),
			list(0, 2),
			list(0, -2),
			list(1, 1),
			list(1, -1),
		)
		for(var/d in directions)
			var/nx = A.x + d[1]
			var/ny = A.y + d[2]
			var/key = "[nx],[ny]"
			if(grid[key])
				A.neighbors += grid[key]
		A.leakage -= length(A.neighbors) * 0.1

// Fast-forwards fuel decay a set amount of hours.
/datum/fission_matrix/proc/skip_decay(hours)
	if(!hours)
		return
	var/hour_fast_flux = fast_neutrons*36000
	var/hour_slow_flux = slow_neutrons*36000
	for(var/i in 1 to hours) // process irradiation
		var/pre_temp = fuel.temperature
		fuel.handle_nuclear_reactions(hour_slow_flux, hour_fast_flux, handle_escape = FALSE, add_absorbption = temp_factor)
		fuel.temperature = pre_temp
	for(var/i in 1 to hours*60) // remove decay products
		var/pre_temp = fuel.temperature
		fuel.handle_nuclear_reactions(0, 0.00000000001)
		fuel.temperature = pre_temp


/datum/fission_assembly
	var/x
	var/y
	var/list/datum/fission_assembly/neighbors = list()

	var/flux = 0
	var/leakage = 0.61 // 0.1 default, 0.7 for edge assemblies
	var/has_rod = TRUE
	var/binary_rod = FALSE
	var/rod_speed = 0.002 // max speed per cycle
	var/rod_position = 1 // fully in, 0 - fully out
	var/hotness = 1
	var/potency = 1 // coef of how much power the rod makes
	var/temperature = 2700

/datum/fission_assembly/binary // moves very fast, can be either fully in or fully out
	binary_rod = TRUE
	rod_speed = 0.08
	rod_position = 0

/datum/fission_assembly/probe // has NMS equipment
	has_rod = FALSE
	potency = 0
	rod_position = 0

/datum/fission_assembly/breeder
	potency = 0.25

/datum/fission_assembly/New(_x, _y)
	x = _x
	y = _y
	potency *= rand(105, 95) * 0.01