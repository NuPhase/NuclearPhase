/turf/exterior/open_ocean
	name = "subsurface ocean"
	icon = 'icons/turf/exterior/ocean_deep.dmi'
	icon_state = "0"
	flooded = TRUE
	icon_edge_layer = EXT_EDGE_OCEAN
	initial_gas = list(/decl/material/gas/oxygen = MOLES_O2MINE, /decl/material/gas/nitrogen = MOLES_N2MINE, /decl/material/gas/carbon_dioxide = 2, /decl/material/gas/sulfur_dioxide = 1)
	is_outside = OUTSIDE_NO
	movement_delay = 2

/turf/exterior/open_ocean/setup_environmental_lighting()
	return

/turf/exterior/open_ocean/set_ambient_light()
	return

/turf/exterior/open_ocean/return_air()
	if(!air)
		make_air()
	return air

/turf/exterior/open_ocean/make_air()
	air = new/datum/gas_mixture
	air.temperature = temperature
	if(initial_gas)
		air.gas = initial_gas.Copy()
	air.update_values()

/turf/exterior/open_ocean/on_update_icon()
	. = ..()
	var/chosen_overlay = "ocean"
	if(prob(20))
		add_overlay(image('icons/turf/flooring/decals.dmi', "asteroid[rand(0,9)]"))
	if(prob(10))
		chosen_overlay = "ocean-bubbles"
	var/image/water_overlay = image('icons/effects/liquids.dmi', chosen_overlay)
	water_overlay.color = COLOR_LIQUID_WATER
	water_overlay.layer = ABOVE_HUMAN_LAYER
	water_overlay.alpha = 170
	water_overlay.mouse_opacity = FALSE
	add_overlay(water_overlay)

/turf/exterior/open_ocean/Initialize()
	. = ..()
	update_icon()
	fluid_update(TRUE)