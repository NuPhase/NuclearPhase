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
	build_network()

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
	air_contents.add_thermal_energy(joules)
	temperature = air_contents.temperature

/obj/machinery/atmospherics/unary/furnace/proc/add_ore(var/obj/item/stack/ore/added_ore)
	var/decl/material/picked_mat = pick(added_ore.composition)
	picked_mat = GET_DECL(picked_mat)
	var/internal_heat_capacity = air_contents.heat_capacity()
	var/ore_heat_capacity = added_ore.amount * picked_mat.molar_mass * picked_mat.solid_specific_heat
	var/combined_heat_capacity = internal_heat_capacity + ore_heat_capacity
	var/datum/gas_mixture/environment = loc.return_air()
	var/combined_energy = environment.temperature * ore_heat_capacity + internal_heat_capacity * air_contents.temperature
	air_contents.temperature = combined_energy/combined_heat_capacity



//Electrodes lose integrity when used in an EBF
//Electrodes increase their coke content when used in an EBF
/obj/item/arc_electrode
	name = "arc electrode"
	desc = "A heavy graphite rod with a bolt on its end. It's designed for use in electric blast furnaces."
	var/integrity = 1 //0.01 - 1
	var/integrity_loss_per_cycle = 1 //how much integrity do we lose per one EBF cycle?
	var/coke_content = 0 //0-100
	matter = list(/decl/material/solid/graphite = 20000)

/obj/item/arc_electrode/high_quality
	name = "HQ arc electrode"
	desc = "A purified heavy graphite rod with a bolt on its end. It's designed for use in electric blast furnaces."
	integrity_loss_per_cycle = 0.75

/obj/item/arc_electrode/ultrahigh_quality
	name = "UHQ arc electrode"
	desc = "A heavily purified heavy graphite rod with a bolt on its end. It's designed for use in electric blast furnaces."
	integrity_loss_per_cycle = 0.5


#define MINIMUM_ARCING_CONDUCTIVITY 0.3
/obj/machinery/atmospherics/unary/furnace/arc
	name = "arc furnace"
	desc = "A giant electric furnace."
	icon = 'icons/obj/machines/arc_furnace.dmi'
	icon_state = "unloaded-offline"
	internal_volume = 3000
	var/list/inserted_electrodes = list()
	var/nominal_power_usage = 78 MWATT
	idle_power_usage = 50 KWATT
	active_power_usage = 78 MWATT
	pixel_x = -64
	pixel_y = -32
	bound_x = -64
	bound_y = -32
	bound_width = 160
	bound_height = 128
	layer = ABOVE_HUMAN_LAYER

/obj/machinery/atmospherics/unary/furnace/arc/proc/get_conductivity_coefficient()
	if(!inserted_electrodes)
		return 0
	var/coef_sum = 0
	for(var/obj/item/arc_electrode/cur_electrode in inserted_electrodes)
		if(cur_electrode.integrity == 0) //dead electrode
			continue
		coef_sum += 1 - cur_electrode.coke_content * 0.01
	return coef_sum / length(inserted_electrodes)

/obj/machinery/atmospherics/unary/furnace/arc/proc/get_stability()
	return 100

/obj/machinery/atmospherics/unary/furnace/arc/proc/lose_electrode_integrity(conduction_coefficient)
	for(var/obj/item/arc_electrode/cur_electrode in inserted_electrodes)
		cur_electrode.integrity = max(0, cur_electrode.integrity - cur_electrode.integrity_loss_per_cycle * conduction_coefficient)

/obj/machinery/atmospherics/unary/furnace/arc/proc/process_stability(stability)
	return

/obj/machinery/atmospherics/unary/furnace/arc/proc/start_arcing()
	if(!powered(EQUIP))
		return
	update_use_power(POWER_USE_ACTIVE)
	playsound(src, sound('sound/machines/arcing_start.ogg', channel = sound_channels.long_channel))

/obj/machinery/atmospherics/unary/furnace/arc/proc/stop_arcing()
	stop_client_sounds_on_channel(sound_channels.long_channel) //this is really dumb and stupid and expensive

/obj/machinery/atmospherics/unary/furnace/arc/Process()
	. = ..()
	var/conductivity_coefficient = get_conductivity_coefficient()
	var/arcing_stability = get_stability()

	if(powered(EQUIP) && conductivity_coefficient > MINIMUM_ARCING_CONDUCTIVITY && use_power == POWER_USE_ACTIVE)
		var/actually_used_power = nominal_power_usage * conductivity_coefficient
		heat_up(actually_used_power * CELLRATE)
		change_power_consumption(actually_used_power, POWER_USE_ACTIVE)
		lose_electrode_integrity(conductivity_coefficient)
		process_stability(arcing_stability)


#undef MINIMUM_ARCING_CONDUCTIVITY