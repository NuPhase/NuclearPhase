/*

Making Bombs with ZAS:
Get gas to react in an air tank so that it gains pressure. If it gains enough pressure, it goes boom.
The more pressure, the more boom.
If it gains pressure too slowly, it may leak or just rupture instead of exploding.
*/

//#define FIREDBG

/turf/var/obj/fire/fire = null

//Some legacy definitions so fires can be started.
/atom/proc/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return null

/atom/movable/proc/is_burnable()
	return FALSE

/mob/is_burnable()
	return simulated

/turf/proc/hotspot_expose(exposed_temperature, exposed_volume, soh = 0)
	return

/turf/simulated/hotspot_expose(exposed_temperature, exposed_volume, soh)
	if(fire_protection > world.time-300)
		return 0
	if(locate(/obj/fire) in src)
		return 1

	var/datum/gas_mixture/air_contents = return_air()
	if(!air_contents || exposed_temperature < FLAMMABLE_GAS_MINIMUM_BURN_TEMPERATURE)
		return 0

	var/igniting = 0
	var/obj/effect/fluid/F = return_fluid()
	if(F)
		F.vaporize_fuel(air_contents)
		if(F.is_combustible())
			igniting = 1

	if(air_contents.check_combustibility())
		igniting = 1

	if(igniting)
		create_fire(exposed_temperature / vsc.fire_firelevel_multiplier, F)
	return igniting

#define FIRELEVEL_PER_T_DELTA 2

/zone/proc/process_fire()
	var/datum/gas_mixture/burn_gas = air.remove(vsc.fire_consuption_rate * length(fire_tiles) * air.total_moles)

	for(var/turf/T in fire_tiles)
		if(T.fire && T.fire.burning_fluid)
			T.fire.burning_fluid.vaporize_fuel(burn_gas)

	var/old_firelevel = 0
	for(var/turf/T in fire_tiles)
		if(T.fire)
			old_firelevel = T.fire.firelevel
			break

	var/old_temperature = burn_gas.temperature
	SSreactions.process_gasmix(burn_gas, old_firelevel)
	var/firelevel = sqrt(burn_gas.temperature - old_temperature) * FIRELEVEL_PER_T_DELTA

	air.merge(burn_gas)

	if(firelevel)
		for(var/turf/T in fire_tiles)
			if(T.fire)
				T.fire.firelevel = firelevel
				if(firelevel > 100)
					cell_explosion(T, firelevel, 1, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, temperature = burn_gas.temperature, is_atmos = TRUE)
			else
				fire_tiles -= T
	else
		for(var/turf/simulated/T in fire_tiles)
			if(istype(T.fire) && !T.fire.burning_fluid)
				qdel(T.fire)
		fire_tiles.Cut()

	if(!fire_tiles.len)
		SSair.active_fire_zones.Remove(src)

/turf/proc/create_fire(fl)
	return 0

/turf/simulated/create_fire(fl, newburnfluid)

	if(submerged())
		return 1

	if(fire)
		fire.firelevel = max(fl, fire.firelevel)
		fire.burning_fluid = newburnfluid
		update_icon()
		return 1

	if(!zone)
		return 1

	fire = new(src, fl)
	SSair.active_fire_zones |= zone

	fire.burning_fluid = newburnfluid

	zone.fire_tiles |= src
	return 0

/obj/fire
	//Icon for fire on turfs.

	alpha = 0
	anchored = 1
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE

	blend_mode = BLEND_ADD

	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	light_color = "#ed9200"
	layer = FIRE_LAYER

	var/firelevel = 1 //Calculated by gas_mixture.calculate_firelevel()
	var/obj/effect/fluid/burning_fluid = null //if we have one
	var/obj/effect/abstract/particle_holder/our_holder = null

/obj/fire/on_update_icon()
	if(burning_fluid)
		layer = BELOW_OBJ_LAYER
		switch(firelevel)
			if(0 to 2)
				icon_state = "fluid_1"
				set_light(1, 2, color, no_update = TRUE)
			if(2 to 4)
				icon_state = "fluid_2"
				set_light(4, 2, color, no_update = TRUE)
			if(4 to 6)
				icon_state = "fluid_3"
				set_light(6, 3, color, no_update = TRUE)
			if(6 to INFINITY)
				icon_state = "fluid_4"
				set_light(8, 4, color, no_update = TRUE)
	else
		layer = FIRE_LAYER
		if(firelevel > 6)
			icon_state = "3"
			set_light(7, 3, color, no_update = TRUE)
		else if(firelevel > 2.5)
			icon_state = "2"
			set_light(5, 2, color, no_update = TRUE)
		else
			icon_state = "1"
			set_light(3, 1, color, no_update = TRUE)

/obj/fire/Process()
	. = 1

	var/turf/simulated/my_tile = loc
	if(!istype(my_tile) || !my_tile.zone || my_tile.submerged())
		if(my_tile && my_tile.fire == src)
			my_tile.fire = null
		qdel(src)
		return PROCESS_KILL

	var/datum/gas_mixture/air_contents = my_tile.return_air()

	if(firelevel < 0.1)
		qdel(src)

	update_icon()

	for(var/mob/living/L in loc)
		L.FireBurn(firelevel, air_contents.temperature, air_contents.return_pressure())  //Burn the mobs!

	loc.fire_act(air_contents, air_contents.temperature, air_contents.volume)
	for(var/atom/A in loc)
		A.fire_act(air_contents, air_contents.temperature, air_contents.volume)

	// prioritize nearby fuel overlays first
	for(var/direction in global.cardinal)
		var/turf/simulated/enemy_tile = get_step(my_tile, direction)
		if(istype(enemy_tile) && (locate(/obj/effect/fluid) in enemy_tile))
			enemy_tile.hotspot_expose(air_contents.temperature, air_contents.volume)

	//spread
	for(var/direction in global.cardinal)
		var/turf/simulated/enemy_tile = get_step(my_tile, direction)

		if(istype(enemy_tile))
			if(my_tile.open_directions & direction) //Grab all valid bordering tiles
				if(!enemy_tile.zone || enemy_tile.fire)
					continue

				//if(!enemy_tile.zone.fire_tiles.len) TODO - optimize
				var/datum/gas_mixture/acs = enemy_tile.return_air()
				var/obj/effect/fluid/fluid_on_tile = enemy_tile.return_fluid()
				if(!acs || !fluid_on_tile?.is_combustible())
					continue

				//If extinguisher mist passed over the turf it's trying to spread to, don't spread and
				//reduce firelevel.
				if(enemy_tile.fire_protection > world.time-30)
					firelevel -= 1.5
					continue

				//Spread the fire.
				if(prob( 50 + 50 * (firelevel/vsc.fire_firelevel_multiplier) ) && my_tile.CanPass(null, enemy_tile, 0,0) && enemy_tile.CanPass(null, my_tile, 0,0))
					enemy_tile.create_fire(firelevel, fluid_on_tile)

			else
				enemy_tile.adjacent_fire_act(loc, air_contents, air_contents.temperature, air_contents.volume)

	animate(src, color = fire_color(air_contents.temperature), 5)

/obj/fire/Initialize(mapload, fl)
	. = ..()

	if(!isturf(loc))
		return INITIALIZE_HINT_QDEL

	set_dir(pick(global.cardinal))

	var/datum/gas_mixture/air_contents = loc.return_air()
	color = fire_color(air_contents.temperature)

	firelevel = fl
	SSair.active_hotspots.Add(src)
	update_icon()

	our_holder = new(loc, /particles/smoke_continuous/fire)
	our_holder.alpha = 90

/obj/fire/proc/fire_color(var/env_temperature)
	if(burning_fluid)
		var/decl/material/main_reagent = burning_fluid.reagents.get_primary_reagent_decl()
		if(main_reagent)
			animate(src, alpha = main_reagent.fire_alpha, 20)
			return main_reagent.fire_color
	var/temperature = max(4000*sqrt(firelevel/vsc.fire_firelevel_multiplier), env_temperature)
	animate(src, alpha = 255, 20)
	return heat2color(temperature)

/obj/fire/Destroy()
	var/turf/T = loc
	if (istype(T))
		set_light(0)
		T.fire = null
	SSair.active_hotspots.Remove(src)
	qdel(our_holder)
	burning_fluid = null
	. = ..()

/turf/simulated/var/fire_protection = 0 //Protects newly extinguished tiles from being overrun again.
/turf/proc/apply_fire_protection()
/turf/simulated/apply_fire_protection()
	fire_protection = world.time

//Returns the firelevel
/datum/gas_mixture/proc/fire_react(zone/zone, force_burn, no_check = 0)
	. = 0
	var/old_temperature = temperature

	SSreactions.process_gasmix(src)

	if(old_temperature > temperature)
		return 0

	var/firelevel = sqrt(temperature - old_temperature) * FIRELEVEL_PER_T_DELTA

	update_values()

	return firelevel

/datum/gas_mixture/proc/check_recombustibility()
	. = 0
	for(var/g in gas)
		if(gas[g] >= 0.1)
			var/decl/material/gas = GET_DECL(g)
			if(gas.gas_flags & XGM_GAS_OXIDIZER)
				. = 1
				break

	if(!.)
		return 0

	. = 0
	for(var/g in gas)
		if(gas[g] >= 0.1)
			var/decl/material/gas = GET_DECL(g)
			if(gas.gas_flags & XGM_GAS_OXIDIZER)
				. = 1
				break

/datum/gas_mixture/proc/check_combustibility()
	. = 0
	for(var/g in gas)
		if(QUANTIZE(gas[g] * vsc.fire_consuption_rate) >= 0.1)
			var/decl/material/gas = GET_DECL(g)
			if(gas.gas_flags & XGM_GAS_OXIDIZER)
				. = 1
				break

	if(!.)
		return 0

	. = 0
	for(var/g in gas)
		if(QUANTIZE(gas[g] * vsc.fire_consuption_rate) >= 0.1)
			var/decl/material/gas = GET_DECL(g)
			if(gas.gas_flags & XGM_GAS_FUEL)
				. = 1
				break

//returns a value between 0 and vsc.fire_firelevel_multiplier
/datum/gas_mixture/proc/calculate_firelevel(total_fuel, total_oxidizers, reaction_limit, gas_volume)
	//Calculates the firelevel based on one equation instead of having to do this multiple times in different areas.
	var/firelevel = 0

	var/total_combustibles = (total_fuel + total_oxidizers)
	var/active_combustibles = (FIRE_REACTION_OXIDIZER_AMOUNT/FIRE_REACTION_FUEL_AMOUNT + 1)*reaction_limit

	if(total_combustibles > 0 && total_moles > 0 && group_multiplier > 0)
		//slows down the burning when the concentration of the reactants is low
		var/damping_multiplier = min(1, active_combustibles / (total_moles/group_multiplier))

		//weight the damping mult so that it only really brings down the firelevel when the ratio is closer to 0
		damping_multiplier = 2*damping_multiplier - (damping_multiplier*damping_multiplier)

		//calculates how close the mixture of the reactants is to the optimum
		//fires burn better when there is more oxidizer -- too much fuel will choke the fire out a bit, reducing firelevel.
		var/mix_multiplier = 1 / (1 + (5 * ((total_fuel / total_combustibles) ** 2)))

		#ifdef FIREDBG
		ASSERT(damping_multiplier <= 1)
		ASSERT(mix_multiplier <= 1)
		#endif

		//toss everything together -- should produce a value between 0 and fire_firelevel_multiplier
		firelevel = vsc.fire_firelevel_multiplier * mix_multiplier * damping_multiplier

	return max( 0, firelevel)


/mob/living/proc/FireBurn(var/firelevel, var/last_temperature, var/pressure)
	var/mx = 5 * firelevel/vsc.fire_firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)
	apply_damage(2.5*mx, BURN)
	return mx


/mob/living/carbon/human/FireBurn(var/firelevel, var/last_temperature, var/pressure)
	//Burns mobs due to fire. Respects heat transfer coefficients on various body parts.
	//Due to TG reworking how fireprotection works, this is kinda less meaningful.

	var/head_exposure = 1
	var/chest_exposure = 1
	var/groin_exposure = 1
	var/legs_exposure = 1
	var/arms_exposure = 1

	//Get heat transfer coefficients for clothing.

	var/holding = get_held_items()
	for(var/obj/item/clothing/C in src)
		if(C in holding)
			continue

		if( C.max_heat_protection_temperature >= last_temperature )
			if(C.body_parts_covered & SLOT_HEAD)
				head_exposure = 0
			if(C.body_parts_covered & SLOT_UPPER_BODY)
				chest_exposure = 0
			if(C.body_parts_covered & SLOT_LOWER_BODY)
				groin_exposure = 0
			if(C.body_parts_covered & SLOT_LEGS)
				legs_exposure = 0
			if(C.body_parts_covered & SLOT_ARMS)
				arms_exposure = 0
	//minimize this for low-pressure enviroments
	var/mx = 5 * firelevel/vsc.fire_firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)

	//Always check these damage procs first if fire damage isn't working. They're probably what's wrong.

	apply_damage(0.9*mx*head_exposure,  BURN, BP_HEAD,  used_weapon =  "Fire")
	apply_damage(2.5*mx*chest_exposure, BURN, BP_CHEST, used_weapon =  "Fire")
	apply_damage(2.0*mx*groin_exposure, BURN, BP_GROIN, used_weapon =  "Fire")
	apply_damage(0.6*mx*legs_exposure,  BURN, BP_L_LEG, used_weapon =  "Fire")
	apply_damage(0.6*mx*legs_exposure,  BURN, BP_R_LEG, used_weapon =  "Fire")
	apply_damage(0.4*mx*arms_exposure,  BURN, BP_L_ARM, used_weapon =  "Fire")
	apply_damage(0.4*mx*arms_exposure,  BURN, BP_R_ARM, used_weapon =  "Fire")

	//return a truthy value of whether burning actually happened
	return mx * (head_exposure + chest_exposure + groin_exposure + legs_exposure + arms_exposure)
