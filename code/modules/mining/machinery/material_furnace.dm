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
		visible_message(SPAN_NOTICE("[user] loads some ore into \the [src]."))
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
	update_networks()

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
	icon = 'icons/obj/items/arc_electrode.dmi'
	icon_state = ICON_STATE_WORLD
	var/integrity = 100 //0-100
	var/integrity_loss_per_cycle = 0.2 //how much integrity do we lose per one EBF cycle?
	var/coke_content = 0 //0-100
	matter = list(/decl/material/solid/graphite = 20000)
	weight = 20

/obj/item/arc_electrode/high_quality //a previous electrode tempered in an inert atmosphere furnace. TODO.
	name = "HQ arc electrode"
	desc = "A purified heavy graphite rod with a bolt on its end. It's designed for use in electric blast furnaces."
	integrity_loss_per_cycle = 0.1
	weight = 18

/obj/item/arc_electrode/ultrahigh_quality //treatment in a chemical reactor. TODO.
	name = "UHQ arc electrode"
	desc = "A heavily purified heavy graphite rod with a bolt on its end. It's designed for use in electric blast furnaces. This one is considerably lighter because of its purity."
	integrity_loss_per_cycle = 0.05
	weight = 15

/obj/item/arc_electrode/examine(mob/user, distance, infix, suffix)
	. = ..()
	var/electrode_integrity_message
	switch(integrity)
		if(0 to 25)
			electrode_integrity_message = "It's already well-eaten, it won't last any longer."
		if(25 to 75)
			electrode_integrity_message = "It's quite beaten-up, but it's still holding."
		if(75 to 100)
			electrode_integrity_message = "It's in excellent condition."
	to_chat(user, SPAN_NOTICE(electrode_integrity_message))
	if(coke_content > 25)
		to_chat(user, SPAN_NOTICE("It has considerable amounts of gray dust accumulated on it. It can probably be burned off."))

/obj/item/arc_electrode/attackby(obj/item/I, mob/user)
	if(IS_WELDER(I))
		if(coke_content)
			var/obj/item/weldingtool/WT = I
			if(!WT.isOn())
				to_chat(user, "<span class='notice'>The welding tool needs to be on to be of any use here.</span>")
				return
			visible_message(SPAN_NOTICE("[user] starts burning off excess coke on the [src] with \the [I]."))
			playsound(src, 'sound/items/Welder.ogg', 50, 1)
			if(!do_after(user, 5 SECONDS, src))
				return
			visible_message(SPAN_NOTICE("[user] burns off excess coke dust on the [src]."))
			coke_content = 0
			playsound(src, 'sound/items/Welder2.ogg', 50, 1)
	. = ..()


#define MINIMUM_ARCING_CONDUCTIVITY 0.3
#define HEAT_LEAK_COEF 0.0001
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
	power_channel = EQUIP
	pixel_x = -64
	pixel_y = -32
	layer = ABOVE_HUMAN_LAYER

/obj/machinery/atmospherics/unary/furnace/arc/attackby(obj/item/I, mob/user)
	. = ..()
	if(use_power == POWER_USE_ACTIVE)
		electrocute_mob(user, get_area(src), src)
		return
	if(IS_WRENCH(I))
		if(!length(inserted_electrodes))
			to_chat(user, SPAN_NOTICE("\The [src] doesn't have any electrodes installed."))
			return
		var/obj/item/electrode = pick(inserted_electrodes)
		user.put_in_hands(electrode)
		inserted_electrodes -= electrode
		visible_message(SPAN_NOTICE("[user] removes an electrode from \the [src]."))
		return
	if(istype(I, /obj/item/arc_electrode))
		if(length(inserted_electrodes) >= 3)
			to_chat(user, SPAN_NOTICE("\The [src] already has 3 electrodes installed."))
			return
		if(!user.do_skilled(100, SKILL_DEVICES, src))
			return
		user.drop_from_inventory(I, src)
		inserted_electrodes += I
		visible_message(SPAN_NOTICE("[user] inserts an electrode into \the [src]."))

/obj/machinery/atmospherics/unary/furnace/arc/examine(mob/user)
	. = ..()
	if(length(inserted_electrodes))
		to_chat(user, SPAN_NOTICE("It has [length(inserted_electrodes)] electrodes installed."))
	else
		to_chat(user, SPAN_WARNING("It doesn't have any electrodes installed."))

/obj/machinery/atmospherics/unary/furnace/arc/proc/get_conductivity_coefficient()
	if(!length(inserted_electrodes))
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
		cur_electrode.coke_content = min(100, cur_electrode.coke_content + 0.5)

/obj/machinery/atmospherics/unary/furnace/arc/proc/process_stability(stability)
	return

/obj/machinery/atmospherics/unary/furnace/arc/proc/start_arcing()
	if(!powered(EQUIP) || get_conductivity_coefficient() < MINIMUM_ARCING_CONDUCTIVITY)
		return
	update_use_power(POWER_USE_ACTIVE)
	playsound(src, sound('sound/machines/arcing_start.ogg', channel = sound_channels.long_channel))

/obj/machinery/atmospherics/unary/furnace/arc/proc/stop_arcing()
	stop_client_sounds_on_channel(sound_channels.long_channel) //this is really dumb and stupid and expensive
	update_use_power(POWER_USE_IDLE)

/obj/machinery/atmospherics/unary/furnace/arc/Process()
	if(use_power == POWER_USE_IDLE)
		return
	. = ..()
	var/conductivity_coefficient = get_conductivity_coefficient()
	var/arcing_stability = get_stability()

	if(!powered(EQUIP) || get_conductivity_coefficient() < MINIMUM_ARCING_CONDUCTIVITY)
		stop_arcing()

	var/actually_used_power = nominal_power_usage * conductivity_coefficient
	heat_up(actually_used_power * CELLRATE)
	change_power_consumption(actually_used_power, POWER_USE_ACTIVE)
	lose_electrode_integrity(conductivity_coefficient)
	process_stability(arcing_stability)

/obj/machinery/atmospherics/unary/furnace/arc/heat_up(joules)
	. = ..()
	var/turf/T = get_turf(src)
	var/datum/gas_mixture/environment = T.return_air()
	environment.add_thermal_energy(joules * HEAT_LEAK_COEF)


#undef MINIMUM_ARCING_CONDUCTIVITY
#undef HEAT_LEAK_COEF