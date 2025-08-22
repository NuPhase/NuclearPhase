/obj/machinery/atmospherics/unary/furnace //THIS SHOULD NOT BE USED, USE SUBTYPES
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace"
	var/internal_volume = 20
	var/heat_capacity = 1500
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
	. = ..()
	process_melting()

/obj/machinery/atmospherics/unary/furnace/proc/process_melting()
	do_melt(air_contents)

/obj/machinery/atmospherics/unary/furnace/proc/ore_produced(obj/item/stack/ore/chosen_ore, decl/material/chosen_mat, proc_metal)
	return chosen_ore.amount / chosen_mat.molar_mass * chosen_ore.composition[proc_metal] * chosen_ore.ore_to_slag_ratio() //returns 0

/obj/machinery/atmospherics/unary/furnace/proc/slag_produced(obj/item/stack/ore/chosen_ore, proc_metal)
	var/decl/material/chosen_mat = GET_DECL(/decl/material/solid/slag)
	return chosen_ore.amount / chosen_mat.molar_mass * chosen_ore.composition[proc_metal] * (1 - chosen_ore.ore_to_slag_ratio()) // turn it into slag to ore ratio

/obj/machinery/atmospherics/unary/furnace/proc/do_melt(datum/gas_mixture/gasmix)
	for(var/obj/item/stack/ore/cur_ore in contents)
		for(var/proc_metal in cur_ore.composition)
			var/decl/material/cur_mat = GET_DECL(proc_metal)
			switch(cur_mat.phase_at_temperature(gasmix.temperature, gasmix.return_pressure()))
				if(MAT_PHASE_GAS)
					if(length(cur_ore.composition) == 1)
						var/evap_coef = min(cur_ore.composition[proc_metal] * 0.1 + 0.01, cur_ore.composition[proc_metal])
						gasmix.gas[proc_metal] += ore_produced(cur_ore, cur_mat, proc_metal) * evap_coef
						gasmix.solids[/decl/material/solid/slag] += slag_produced(cur_ore, proc_metal) * evap_coef
						cur_ore.composition[proc_metal] -= evap_coef
						if(cur_ore.composition[proc_metal] <= 0)
							cur_ore.composition.Remove(proc_metal)
				if(MAT_PHASE_LIQUID)
					gasmix.solids[proc_metal] += ore_produced(cur_ore, cur_mat, proc_metal)
					gasmix.solids[/decl/material/solid/slag] += slag_produced(cur_ore, proc_metal)
					cur_ore.composition.Remove(proc_metal)
				if(MAT_PHASE_SOLID)
					if(length(cur_ore.composition) == 1)
						gasmix.solids[proc_metal] += ore_produced(cur_ore, cur_mat, proc_metal)
						gasmix.solids[/decl/material/solid/slag] += slag_produced(cur_ore, proc_metal)
						cur_ore.composition.Remove(proc_metal)
		if(!length(cur_ore.composition))
			qdel(cur_ore)
	gasmix.update_values()
	update_networks()

/obj/machinery/atmospherics/unary/furnace/proc/heat_up(joules)
	air_contents.add_thermal_energy(joules)
	temperature = air_contents.temperature

/obj/machinery/atmospherics/unary/furnace/proc/add_ore(var/obj/item/stack/ore/added_ore)
	var/decl/material/picked_mat = pick(added_ore.composition)
	picked_mat = GET_DECL(picked_mat)
	var/internal_heat_capacity = air_contents.heat_capacity()
	var/ore_heat_capacity = added_ore.amount * picked_mat.molar_mass * picked_mat.gas_specific_heat
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


#define MINIMUM_ARCING_CONDUCTIVITY 0.05
#define HEAT_LEAK_COEF 0.0001
/obj/structure/arc_furnace_overlay
	name = "arc furnace"
	desc = "A giant electric furnace."
	icon = 'icons/obj/machines/arc_furnace.dmi'
	icon_state = "map"
	layer = BELOW_OBJ_LAYER
	var/obj/machinery/atmospherics/unary/furnace/arc/our_furnace
	bound_x = -32
	bound_width = 96
	bound_height = 64
	pixel_x = -32
	pixel_y = -32
	anchored = TRUE
	density = TRUE

/obj/structure/arc_furnace_overlay/return_air()
	if(our_furnace.connected_canister)
		return our_furnace.connected_canister.air_contents
	return null

/obj/structure/arc_furnace_overlay/attack_hand(mob/user)
	. = ..()
	tgui_interact(user)

/obj/structure/arc_furnace_overlay/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ArcFurnace", "Arc Furnace")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/structure/arc_furnace_overlay/tgui_data(mob/user)
	var/total_mass = 0
	for(var/obj/item/stack/ore/cur_ore in our_furnace.contents)
		total_mass += cur_ore.amount
	if(our_furnace.connected_canister)
		total_mass += our_furnace.connected_canister.air_contents.get_mass()
	return list("has_canister" = our_furnace.connected_canister,
				"canister_content_mass" = total_mass,
				"canister_content_temperature" = (our_furnace.connected_canister ? our_furnace.connected_canister.air_contents.temperature : T20C),
				"canister_content_pressure" = (our_furnace.connected_canister ? our_furnace.connected_canister.air_contents.pressure : 0),
				"canister_content_fluidlevel" = round(our_furnace.connected_canister ? (1-(our_furnace.connected_canister.air_contents.available_volume/our_furnace.connected_canister.air_contents.volume))*100 : 0),
				"power_consumption" = our_furnace.active_power_usage,
				"conductivity" = round(our_furnace.get_conductivity_coefficient()*100),
				"is_operating" = (our_furnace.use_power == POWER_USE_ACTIVE))

/obj/structure/arc_furnace_overlay/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("start")
			our_furnace.start_arcing()
		if("stop")
			our_furnace.stop_arcing()

/obj/structure/arc_furnace_overlay/receive_mouse_drop(atom/dropping, mob/living/user)
	. = ..()
	if(!Adjacent(dropping))
		return
	if(our_furnace.use_power == POWER_USE_ACTIVE)
		return
	if(our_furnace.connected_canister)
		visible_message("[user] disconnects the canister from \the [src].")
		playsound(src, 'sound/machines/podopen.ogg', 50)
		our_furnace.connected_canister.forceMove(user.loc)
		our_furnace.connected_canister = null
	else if(dropping)
		if(!istype(dropping, /obj/machinery/portable_atmospherics))
			return
		if(!do_after(user, 30, dropping))
			return
		if(our_furnace.connected_canister)
			return
		our_furnace.connected_canister = dropping
		our_furnace.connected_canister.forceMove(src)
		visible_message("[user] connects a canister to \the [src].")
		playsound(src, 'sound/machines/podclose.ogg', 50)
	update_icon()

/obj/structure/arc_furnace_overlay/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	icon_state = "bottom"

/obj/structure/arc_furnace_overlay/on_update_icon()
	cut_overlays()
	var/list/overlays_to_add = list()
	if(our_furnace.connected_canister)
		overlays_to_add += image(our_furnace.connected_canister.icon, icon_state=our_furnace.connected_canister.icon_state, layer=ABOVE_OBJ_LAYER, pixel_x = 56)
	overlays_to_add += image(icon, icon_state="top", layer = STRUCTURE_LAYER)
	add_overlay(overlays_to_add)

/obj/machinery/atmospherics/unary/furnace/arc
	internal_volume = 3000
	var/list/inserted_electrodes = list()
	var/nominal_power_usage = 108 MWATT
	idle_power_usage = 50 KWATT
	active_power_usage = 108 MWATT
	power_channel = EQUIP
	var/obj/structure/arc_furnace_overlay/overlay
	var/obj/machinery/portable_atmospherics/connected_canister
	var/datum/sound_token/sound_token
	var/firelevel = 0 //firelevel that is returned on fire_react()
	var/instability = 0 //0-100, defines how much everything sloshes around
	var/sound_id

/obj/machinery/atmospherics/unary/furnace/arc/Initialize()
	. = ..()
	overlay = new(get_turf(src))
	overlay.our_furnace = src
	overlay.update_icon()
	sound_id = "[type]_[sequential_id(type)]"

/obj/structure/arc_furnace_overlay/attackby(obj/item/I, mob/user)
	. = ..()
	if(IS_WRENCH(I))
		if(our_furnace.use_power == POWER_USE_ACTIVE)
			electrocute_mob(user, get_area(src), our_furnace)
			return
		if(!length(our_furnace.inserted_electrodes))
			to_chat(user, SPAN_NOTICE("\The [src] doesn't have any electrodes installed."))
			return
		var/obj/item/electrode = pick(our_furnace.inserted_electrodes)
		user.put_in_hands(electrode)
		our_furnace.inserted_electrodes -= electrode
		visible_message(SPAN_NOTICE("[user] removes an electrode from \the [src]."))
		update_icon()
		return
	if(istype(I, /obj/item/arc_electrode))
		if(length(our_furnace.inserted_electrodes) >= 3)
			to_chat(user, SPAN_NOTICE("\The [src] already has 3 electrodes installed."))
			return
		if(!user.do_skilled(20, SKILL_DEVICES, src))
			return
		user.drop_from_inventory(I, src)
		our_furnace.inserted_electrodes |= I
		visible_message(SPAN_NOTICE("[user] inserts an electrode into \the [src]."))
		update_icon()
		return
	if(istype(I, /obj/item/stack/material))
		our_furnace.add_mat_stack(I)
	our_furnace.attackby(I, user)

/obj/structure/arc_furnace_overlay/examine(mob/user)
	. = ..()
	if(length(our_furnace.inserted_electrodes))
		to_chat(user, SPAN_NOTICE("It has [length(our_furnace.inserted_electrodes)] electrodes installed."))
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
	var/list/solid_mats = connected_canister.air_contents.get_fluid(fluid_types = MAT_PHASE_SOLID)
	var/mole_sum = 0
	for(var/g in solid_mats)
		mole_sum += solid_mats[g]
	var/solid_factor = 1
	if(connected_canister.air_contents.total_moles)
		solid_factor = mole_sum / connected_canister.air_contents.total_moles * 0.5
	return (coef_sum / length(inserted_electrodes)) - solid_factor

/obj/machinery/atmospherics/unary/furnace/arc/proc/lose_electrode_integrity(conduction_coefficient)
	for(var/obj/item/arc_electrode/cur_electrode in inserted_electrodes)
		cur_electrode.integrity = max(0, cur_electrode.integrity - cur_electrode.integrity_loss_per_cycle * conduction_coefficient)
		cur_electrode.coke_content = min(100, cur_electrode.coke_content + 0.1)

/obj/machinery/atmospherics/unary/furnace/arc/proc/process_stability()
	var/ninstability = instability * 0.5
	ninstability += (connected_canister.air_contents.pressure / MAX_TANK_PRESSURE) * 10
	if(connected_canister.air_contents.pressure > MAX_TANK_PRESSURE && instability >= 100)
		var/turf/T = get_turf(src)
		cell_explosion(T, 50, 0.1, z_transfer = null, temperature = connected_canister.air_contents.temperature)
		T.add_fluid(/decl/material/solid/slag, connected_canister.air_contents.total_moles * 20, ntemperature = connected_canister.air_contents.temperature)
		connected_canister.air_contents.remove_ratio(0.99)
	return

/obj/machinery/atmospherics/unary/furnace/arc/power_change()
	handle_sound()

/obj/machinery/atmospherics/unary/furnace/arc/proc/handle_sound()
	if(sound_token)
		if(powered(EQUIP))
			if(use_power == POWER_USE_ACTIVE)
				if(sound_token.sound.file == 'sound/machines/arcing_cooling.wav')
					QDEL_NULL(sound_token)
					sound_token = play_looping_sound(src, sound_id, 'sound/machines/arcing_start.ogg', 50, 10)
				sound_token.SetVolume((get_conductivity_coefficient() / 1) * 70)
			else
				if(connected_canister)
					if(sound_token.sound.file == 'sound/machines/arcing_start.ogg')
						QDEL_NULL(sound_token)
						sound_token = play_looping_sound(src, sound_id, 'sound/machines/arcing_cooling.wav', 50, 6)
					sound_token.SetVolume((connected_canister.air_contents.temperature / 5000) * 100)
				else
					QDEL_NULL(sound_token)
		else
			QDEL_NULL(sound_token)
	else
		if(powered(EQUIP))
			if(use_power == POWER_USE_ACTIVE)
				sound_token = play_looping_sound(src, sound_id, 'sound/machines/arcing_start.ogg', 50, 10)
			else
				sound_token = play_looping_sound(src, sound_id, 'sound/machines/arcing_cooling.wav', 50, 6)

/obj/machinery/atmospherics/unary/furnace/arc/proc/start_arcing()
	if(!powered(EQUIP) || get_conductivity_coefficient() < MINIMUM_ARCING_CONDUCTIVITY)
		return
	update_use_power(POWER_USE_ACTIVE)
	handle_sound()

/obj/machinery/atmospherics/unary/furnace/arc/proc/stop_arcing()
	update_use_power(POWER_USE_IDLE)
	set_light(0)
	handle_sound()

/obj/machinery/atmospherics/unary/furnace/arc/Process()
	if(connected_canister)
		control_pressure()

	if(use_power == POWER_USE_IDLE)
		return
	. = ..()

	if(!powered(EQUIP) || !connected_canister)
		stop_arcing()
		return
	var/conductivity_coefficient = get_conductivity_coefficient()
	if(get_conductivity_coefficient() < MINIMUM_ARCING_CONDUCTIVITY)
		stop_arcing()
		return
	if(connected_canister.air_contents.temperature > 5000)
		stop_arcing()
		return

	var/total_heat_capacity = connected_canister.air_contents.heat_capacity()

	firelevel = air_contents.fire_react()
	var/actually_used_power = min(nominal_power_usage * conductivity_coefficient, total_heat_capacity * rand(10, 50) * conductivity_coefficient)
	heat_up(actually_used_power)
	change_power_consumption(actually_used_power, POWER_USE_ACTIVE)
	lose_electrode_integrity(conductivity_coefficient)
	process_stability()
	spark_at(get_turf(pick(oview(2, src))), 3, 0)
	set_light(rand(4, 7), pick(3, 5), pick("#00b7ff", "#30c4ff", "#53ceff", "#5bd0ff", "#a6e6ff"))
	handle_sound()

/obj/machinery/atmospherics/unary/furnace/arc/proc/control_pressure()
	var/pressure_delta = connected_canister.air_contents.return_pressure() - 303
	if(pressure_delta > 200)
		var/moles_to_remove = (pressure_delta * connected_canister.volume) / (R_IDEAL_GAS_EQUATION * connected_canister.air_contents.temperature)
		moles_to_remove = min(moles_to_remove, connected_canister.air_contents.gas_moles * 0.7)
		for(var/g in connected_canister.air_contents.gas)
			connected_canister.air_contents.adjust_gas(g, -moles_to_remove)
			air_contents.adjust_gas(g, moles_to_remove)
			break
		playsound(src, 'sound/machines/thruster.ogg', 70)
	else if(pressure_delta < 50)
		var/moles_to_remove = (pressure_delta * connected_canister.volume) / (R_IDEAL_GAS_EQUATION * connected_canister.air_contents.temperature)
		connected_canister.air_contents.merge(air_contents.remove(abs(moles_to_remove)))

/obj/machinery/atmospherics/unary/furnace/arc/process_melting()
	if(connected_canister)
		do_melt(connected_canister.air_contents)

/obj/machinery/atmospherics/unary/furnace/arc/heat_up(joules)
	connected_canister.air_contents.add_thermal_energy(joules, TRUE, TRUE)
	temperature = air_contents.temperature
	var/turf/T = get_turf(src)
	var/datum/gas_mixture/environment = T.return_air()
	environment.add_thermal_energy(joules * HEAT_LEAK_COEF)

/obj/machinery/atmospherics/unary/furnace/arc/proc/add_mat_stack(obj/item/stack/material/mat_stack)
	mat_stack_to_gas(mat_stack, connected_canister.air_contents)

/obj/machinery/atmospherics/unary/furnace/arc/proc/heat_capacity()
	. = heat_capacity
	for(var/obj/item/stack/ore/O in contents)
		. += O.amount * 1000
	return .

/obj/machinery/atmospherics/unary/furnace/arc/add_ore(var/obj/item/stack/ore/added_ore)
	var/decl/material/picked_mat = pick(added_ore.composition)
	picked_mat = GET_DECL(picked_mat)
	var/internal_heat_capacity = connected_canister.air_contents.heat_capacity()
	var/ore_heat_capacity = added_ore.amount * picked_mat.molar_mass * picked_mat.gas_specific_heat
	var/combined_heat_capacity = internal_heat_capacity + ore_heat_capacity
	var/datum/gas_mixture/environment = loc.return_air()
	var/combined_energy = environment.temperature * ore_heat_capacity + internal_heat_capacity * connected_canister.air_contents.temperature
	connected_canister.air_contents.temperature = combined_energy/combined_heat_capacity

#undef MINIMUM_ARCING_CONDUCTIVITY
#undef HEAT_LEAK_COEF