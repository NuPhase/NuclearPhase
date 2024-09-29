/turf/exterior/open_ocean
	name = "subsurface ocean"
	icon = 'icons/turf/exterior/ocean_deep.dmi'
	icon_state = "0"
	flooded = TRUE
	icon_edge_layer = EXT_EDGE_OCEAN
	initial_gas = list(/decl/material/gas/oxygen = MOLES_O2MINE, /decl/material/gas/nitrogen = MOLES_N2MINE, /decl/material/gas/carbon_dioxide = 2, /decl/material/gas/sulfur_dioxide = 1)
	is_outside = OUTSIDE_NO
	movement_delay = 2
	footstep_type = /decl/footsteps/water

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
	if(prob(20))
		add_overlay(image('icons/turf/flooring/decals.dmi', "asteroid[rand(0,9)]"))

/turf/exterior/open_ocean/Initialize()
	. = ..()
	update_icon()
	fluid_update(TRUE)
	add_vis_contents(src, global.flood_object)