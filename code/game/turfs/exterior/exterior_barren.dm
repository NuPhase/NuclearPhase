/turf/exterior/barren
	name = "ground"
	icon = 'icons/turf/exterior/barren.dmi'
	icon_edge_layer = EXT_EDGE_BARREN
	initial_gas = list(/decl/material/gas/oxygen = MOLES_O2STANDARD, /decl/material/gas/nitrogen = MOLES_N2STANDARD)

/turf/exterior/barren/return_air()
	if(!air)
		make_air()
	return air

/turf/exterior/barren/make_air()
	air = new/datum/gas_mixture
	air.temperature = temperature
	if(initial_gas)
		air.gas = initial_gas.Copy()
	air.update_values()

/turf/exterior/barren/on_update_icon()
	. = ..()
	if(prob(20))
		add_overlay(image('icons/turf/flooring/decals.dmi', "asteroid[rand(0,9)]"))

/turf/exterior/barren/Initialize()
	. = ..()
	update_icon()