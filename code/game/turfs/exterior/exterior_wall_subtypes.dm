/turf/exterior/wall/random
	reinf_material = null

/turf/exterior/wall/random/proc/get_weighted_mineral_list()
	return list(
		/obj/item/stack/ore/hematite = /decl/material/solid/hematite,
		/obj/item/stack/ore/chalcopyrite = /decl/material/solid/chalcopyrite
	)

/turf/exterior/wall/random/Initialize()
	if(isnull(reinf_material))
		var/list/ore_list = get_weighted_mineral_list()
		var/chosen_ore = pick(ore_list)
		reinf_material = ore_list[chosen_ore]
		ore_type = chosen_ore
	. = ..()

/turf/exterior/wall/volcanic
	strata = /decl/strata/igneous

/turf/exterior/wall/random/volcanic
	strata = /decl/strata/igneous

/turf/exterior/wall/random/high_chance/volcanic
	strata = /decl/strata/igneous

/turf/exterior/wall/ice
	strata = /decl/strata/permafrost
	floor_type = /turf/exterior/surface

/turf/exterior/wall/random/ice
	strata = /decl/strata/permafrost
	floor_type = /turf/exterior/ice

/turf/exterior/wall/random/high_chance/ice
	strata = /decl/strata/permafrost
	floor_type = /turf/exterior/ice
