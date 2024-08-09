/obj/effect/fluid
	name = ""
	icon = 'icons/effects/liquids.dmi'
	icon_state = "puddle"
	anchored = 1
	simulated = 0
	opacity = 0
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	layer = FLY_LAYER
	alpha = 0
	color = COLOR_LIQUID_WATER

	var/last_flow_strength = 0
	var/last_flow_dir = 0
	var/update_lighting = FALSE

/obj/effect/fluid/Initialize()
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	icon_state = ""
	create_reagents(FLUID_MAX_DEPTH)
	. = ..()
	var/turf/simulated/T = get_turf(src)
	if(!isturf(T) || !T.CanFluidPass())
		return INITIALIZE_HINT_QDEL
	if(istype(T))
		T.unwet_floor(FALSE)

/obj/effect/fluid/Crossed(mob/living/carbon/C)
	if(!iscarbon(C))
		return
	if(reagents.total_volume > FLUID_SHALLOW)
		playsound(get_turf(src), pick('sound/effects/fluid/water_wade1.ogg', 'sound/effects/fluid/water_wade2.ogg', 'sound/effects/fluid/water_wade3.ogg', 'sound/effects/fluid/water_wade4.ogg'), 50, 0, -2)
	reagents.touch_mob(C)

	var/temp_adj = 0
	if(temperature < C.bodytemperature)			//Place is colder than we are
		var/thermal_protection = C.get_cold_protection(temperature) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
		if(thermal_protection < 1)
			temp_adj = (1-thermal_protection) * ((temperature - C.bodytemperature) / BODYTEMP_COLD_DIVISOR)	//this will be negative
	else if (temperature > C.bodytemperature)			//Place is hotter than we are
		var/thermal_protection = C.get_heat_protection(temperature) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
		if(thermal_protection < 1)
			temp_adj = (1-thermal_protection) * ((temperature - C.bodytemperature) / BODYTEMP_HEAT_DIVISOR)
	C.bodytemperature += between(-100, temp_adj*reagents.total_volume/FLUID_DEEP, 500)

	//if(reagents.total_volume > FLUID_SHALLOW) //do not slip in deep fluid
	//	return
	// skillcheck for slipping
	//if(!C.should_slip(100) || C.move_intent == /decl/move_intent/walk)
	//	return
	//C.slip("the floor", 6)

/obj/effect/fluid/proc/process_phase_change()
	var/turf/T = get_turf(loc)
	var/datum/gas_mixture/environment = T.return_air()
	var/evaporated = FALSE
	var/freezed = FALSE
	if(!environment || !environment.temperature)
		return

	for(var/mat_t in reagents.reagent_volumes)
		var/decl/material/mat = GET_DECL(mat_t)
		var/cur_phase = mat.phase_at_temperature(environment.temperature, environment.return_pressure())
		if(cur_phase == MAT_PHASE_GAS)
			var/units_to_remove = reagents.reagent_volumes[mat_t]
			reagents.remove_reagent(mat_t, units_to_remove, defer_update = 1)
			environment.adjust_gas(mat_t, units_to_remove / mat.molar_volume, update = 0)
			evaporated = TRUE
		else if(cur_phase == MAT_PHASE_SOLID)
			var/units_to_remove = reagents.reagent_volumes[mat_t]
			reagents.remove_reagent(mat_t, units_to_remove, defer_update = 1)
			mat.create_object(T, units_to_remove / mat.molar_volume, /obj/item/stack/material/lump)
			freezed = TRUE
		else
			return

	if(evaporated)
		playsound(T, 'sound/chemistry/bufferadd.ogg', 50)
	if(freezed)
		playsound(T, pick(list('sound/chemistry/freeze/freeze1.mp3', 'sound/chemistry/freeze/freeze2.mp3', 'sound/chemistry/freeze/freeze3.mp3', 'sound/chemistry/freeze/freeze4.mp3')), 50)

	environment.update_values()

/obj/effect/fluid/airlock_crush()
	qdel(src)

/obj/effect/fluid/Move()
	PRINT_STACK_TRACE("A fluid overlay had Move() called!")
	return FALSE

/obj/effect/fluid/on_reagent_change()
	. = ..()
	ADD_ACTIVE_FLUID(src)
	for(var/checkdir in global.cardinal)
		var/obj/effect/fluid/F = locate() in get_step(loc, checkdir)
		if(F)
			ADD_ACTIVE_FLUID(F)
	update_lighting = TRUE
	update_icon()
	var/total_radioactivity = 0
	for(var/reagent_type in reagents.reagent_volumes)
		var/decl/material/mat = GET_DECL(reagent_type)
		total_radioactivity += mat.radioactivity * reagents.reagent_volumes[reagent_type]
	SSradiation.radiate(src, total_radioactivity)

/obj/effect/fluid/Destroy()
	ADD_ACTIVE_FLUID(src)
	for(var/checkdir in global.cardinal)
		var/obj/effect/fluid/F = locate() in get_step(loc, checkdir)
		if(F)
			ADD_ACTIVE_FLUID(F)
	REMOVE_ACTIVE_FLUID(src)
	SSfluids.pending_flows -= src
	. = ..()
	var/turf/simulated/T = loc
	if(istype(T) && reagents?.total_volume > 0)
		T.wet_floor()

/obj/effect/fluid/on_update_icon()

	cut_overlays()
	if(reagents.total_volume > FLUID_OVER_MOB_HEAD)
		layer = DEEP_FLUID_LAYER
	else
		layer = SHALLOW_FLUID_LAYER

	color = reagents.get_color()

	if(!reagents?.total_volume)
		return

	var/decl/material/main_reagent = reagents.get_primary_reagent_decl()
	if(main_reagent) // TODO: weighted alpha from all reagents, not just primary
		alpha = Clamp(CEILING(255*(reagents.total_volume/FLUID_DEEP)) * main_reagent.opacity, main_reagent.min_fluid_opacity, main_reagent.max_fluid_opacity)
		var/blur_power = min((reagents.total_volume * 0.00002) * (1 - alpha/255), 4)
		if(blur_power > 1)
			add_filter("blur", 1, list("blur", size = round(blur_power)))
		if(temperature > 500)
			var/scale = max((temperature - 500) / 1500, 0)

			var/h_r = heat2color_r(temperature)
			var/h_g = heat2color_g(temperature)
			var/h_b = heat2color_b(temperature)

			if(temperature < 2000) //scale up overlay until 2000K
				h_r = 64 + (h_r - 64)*scale
				h_g = 64 + (h_g - 64)*scale
				h_b = 64 + (h_b - 64)*scale
			var/scale_color = rgb(h_r, h_g, h_b)
			color = scale_color
			add_filter("glow",1, list(type="drop_shadow", color = scale_color, x = 0, y = 0, offset = 0, size = round(scale)))
			set_light(min(3, scale*2.5), min(3, scale*2.5), scale_color)
		else
			set_light(0)
		if(main_reagent.solvent_power || temperature > main_reagent.boiling_point * 0.7)
			add_overlay(image(icon, "bubbles"))

	if(reagents.total_volume <= FLUID_PUDDLE)
		APPLY_FLUID_OVERLAY("puddle")
	else if(reagents.total_volume <= FLUID_SHALLOW)
		APPLY_FLUID_OVERLAY("shallow_still")
	else if(reagents.total_volume < FLUID_DEEP)
		APPLY_FLUID_OVERLAY("mid_still")
	else if(reagents.total_volume < (FLUID_DEEP*2))
		APPLY_FLUID_OVERLAY("deep_still")
	else
		APPLY_FLUID_OVERLAY("ocean")
	compile_overlays()

// Map helper.
/obj/effect/fluid_mapped
	name = "mapped flooded area"
	alpha = 125
	icon_state = "shallow_still"
	color = COLOR_LIQUID_WATER

	var/fluid_type = /decl/material/liquid/water
	var/fluid_initial = FLUID_MAX_DEPTH

/obj/effect/fluid_mapped/Initialize()
	..()
	var/turf/T = get_turf(src)
	if(istype(T))
		T.add_fluid(fluid_type, fluid_initial)
	return INITIALIZE_HINT_QDEL

/obj/effect/fluid_mapped/fuel
	name = "spilled fuel"
	fluid_type = /decl/material/liquid/fuel
	fluid_initial = 10

/obj/effect/fluid_mapped/helium
	fluid_type = /decl/material/gas/helium

// Permaflood overlay.
var/global/obj/abstract/flood/flood_object = new
/obj/abstract/flood
	layer = DEEP_FLUID_LAYER
	color = COLOR_LIQUID_WATER
	icon = 'icons/effects/liquids.dmi'
	icon_state = "ocean"
	alpha = FLUID_MAX_ALPHA
	invisibility = 0

/obj/effect/fluid/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	. = ..()
	if(exposed_temperature >= FLAMMABLE_GAS_MINIMUM_BURN_TEMPERATURE)
		vaporize_fuel(air)

/obj/effect/fluid/proc/vaporize_fuel(datum/gas_mixture/air)
	if(!length(reagents?.reagent_volumes) || !istype(air))
		return
	var/update_air = FALSE
	for(var/rtype in reagents.reagent_volumes)
		var/decl/material/mat = GET_DECL(rtype)
		var/moles = round((reagents.reagent_volumes[rtype] * vsc.fluid_fire_consuption_rate + 10) / mat.molar_volume)
		if(moles > 0)
			air.adjust_gas_temp(rtype, moles, temperature, FALSE)
			reagents.remove_reagent(round(moles * mat.molar_volume + 5))
			update_air = TRUE
	if(!reagents.total_volume)
		qdel(src)
	if(update_air)
		air.update_values()
		return TRUE
	return FALSE

/obj/effect/fluid/proc/is_combustible()
	var/decl/material/main_reagent = reagents.get_primary_reagent_decl()
	if(main_reagent?.gas_flags & XGM_GAS_FUEL)
		return TRUE
	return FALSE