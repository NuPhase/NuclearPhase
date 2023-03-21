/obj/machinery/atmospherics/unary/furnace //THIS SHOULD NOT BE USED, USE SUBTYPES
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace"
	var/internal_volume = 20
	var/heat_capacity = 120000
	anchored = 1
	density = 1

/obj/machinery/atmospherics/unary/furnace/Initialize()
	. = ..()
	air_contents.volume = internal_volume

/obj/machinery/atmospherics/unary/furnace/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/ore))
		user.drop_from_inventory(I, src)
		add_ore(I)
	. = ..()


/obj/machinery/atmospherics/unary/furnace/Process()
	for(var/obj/item/stack/ore/cur_ore in contents)
		for(var/proc_metal in cur_ore.composition)
			var/decl/material/cur_mat = GET_DECL(proc_metal)
			switch(cur_mat.phase_at_temperature(air_contents.temperature, air_contents.return_pressure()))
				if(MAT_PHASE_GAS)
					if(length(cur_ore.composition) == 1)
						air_contents.adjust_gas_temp(proc_metal, cur_ore.amount * cur_mat.molar_mass * cur_ore.composition[proc_metal], air_contents.temperature)
						cur_ore.composition.Remove(proc_metal)
				if(MAT_PHASE_LIQUID)
					air_contents.adjust_gas_temp(proc_metal, cur_ore.amount * cur_mat.molar_mass * cur_ore.composition[proc_metal], air_contents.temperature)
					cur_ore.composition.Remove(proc_metal)
				if(MAT_PHASE_SOLID)
					if(length(cur_ore.composition) == 1)
						air_contents.adjust_gas_temp(proc_metal, cur_ore.amount * cur_mat.molar_mass * cur_ore.composition[proc_metal], air_contents.temperature)
						cur_ore.composition.Remove(proc_metal)
		if(!length(cur_ore.composition))
			qdel(cur_ore)
	air_contents.update_values()

/obj/machinery/atmospherics/unary/furnace/proc/heat_up(joules)
	temperature += heat_capacity / joules

/obj/machinery/atmospherics/unary/furnace/proc/add_ore(var/obj/item/stack/ore/added_ore)
	var/decl/material/picked_mat = pick(added_ore.composition)
	picked_mat = GET_DECL(picked_mat)
	var/internal_heat_capacity = air_contents.heat_capacity()
	var/ore_heat_capacity = added_ore.amount * picked_mat.molar_mass * picked_mat.solid_specific_heat
	var/combined_heat_capacity = internal_heat_capacity + ore_heat_capacity
	var/datum/gas_mixture/environment = loc.return_air()
	var/combined_energy = environment.temperature * ore_heat_capacity + internal_heat_capacity * air_contents.temperature
	air_contents.temperature = combined_energy/combined_heat_capacity