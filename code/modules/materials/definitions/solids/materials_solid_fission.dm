/decl/material/solid/metal/depleted_uranium
	name = "uranium 238"
	uid = "solid_depleted_uranium"
	lore_text = "Uranium that does not posess a significant amount of radioactive isotopes. Extremely dense, and can be enriched to produce more fission fuel."
	mechanics_text = "Depleted uranium can be enriched in fission reactors for use as fuel."
	taste_description = "the outside of a reactor"
	flags = MAT_FLAG_FISSIBLE
	icon_base = 'icons/turf/walls/stone.dmi'
	table_icon_base = "stone"
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	value = 1.5
	exoplanet_rarity = MAT_RARITY_UNCOMMON

	neutron_cross_section = 5
	neutron_interactions = list(
		INTERACTION_ABSORPTION = 2500,
		INTERACTION_FISSION = 4500
	)
	absorption_products = list(
		/decl/material/solid/metal/plutonium = 0.8
	)
	fission_products = list(
		/decl/material/solid/metal/fission_byproduct = 0.8
	)
	fission_heat = 35000
	fission_energy = 400000
	neutron_absorption = 500
	neutron_production = 200


/decl/material/solid/metal/neptunium // Np-237.
	name = "neptunium"
	uid = "solid_neptunium"
	lore_text = "A byproduct of uranium undergoing beta decay. Extremely radioactive, can be used as fission fuel, with difficulty."
	mechanics_text = "Neptunium can be used as fuel in fission reactors at high neutron energies."
	taste_description = "lemon juice and hot concrete."
	flags = MAT_FLAG_FISSIBLE
	radioactivity = 30
	icon_base = 'icons/turf/walls/stone.dmi'
	table_icon_base = "stone"
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	color = "#404c53"
	value = 0.5
	exoplanet_rarity = MAT_RARITY_UNCOMMON

	neutron_cross_section = 4 // Difficult to use as fuel.
	neutron_interactions = list(
		INTERACTION_FISSION = 3000
	)
	fission_products = list(
		/decl/material/solid/metal/fission_byproduct = 0.2
	)

/decl/material/solid/metal/plutonium
	name = "plutonium"
	uid = "solid_plutonium"
	lore_text = "A mundane silver-grey metal that is highly fissible. Often used as fuel in nuclear fission reactors and weapons."
	mechanics_text = "Plutonium can be used as fuel in fission reactors."
	taste_description = "nuclear fallout"
	flags = MAT_FLAG_FISSIBLE
	icon_base = 'icons/turf/walls/stone.dmi'
	table_icon_base = "stone"
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	color = "#c9beb2"
	value = 3
	exoplanet_rarity = MAT_RARITY_UNCOMMON

	neutron_cross_section = 10
	neutron_interactions = list(
		INTERACTION_FISSION = 1000
	)
	fission_products = list(
		/decl/material/solid/metal/fission_byproduct = 0.5
	)
	neutron_production = 1200
	neutron_absorption = 300
	fission_heat = 60000
	fission_energy = 1200000

/decl/material/solid/metal/plutonium/affect_blood(mob/living/carbon/human/M, removed, datum/reagents/holder)
	. = ..()
	var/volume = REAGENT_VOLUME(holder, type)
	M.apply_damage(2 * volume, IRRADIATE)

// Catch-all for the nasty byproducts of fission reactions.
/decl/material/solid/metal/fission_byproduct
	name = "nuclear waste"
	uid = "solid_nuclear_waste"
	lore_text = "An unfortunate byproduct of nuclear fission. Extremely radioactive, can be recycled into various useful materials."
	mechanics_text = "Nuclear waste can be processed into various exotic chemicals."
	taste_description = "paprika"
	radioactivity = 30
	icon_base = 'icons/turf/walls/stone.dmi'
	table_icon_base = "stone"
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	color = "#c5ba1c"
	value = 0.5
	exoplanet_rarity = MAT_RARITY_NOWHERE // Don't spawn this in plants.

	dissolves_into = list(
		/decl/material/solid/metal/radium = 0.5,
		/decl/material/solid/lithium = 0.5
	)
	neutron_absorption = 800
	neutron_production = 100
	fission_energy = 400000

/decl/material/solid/metal/fission_byproduct/affect_blood(mob/living/carbon/human/M, removed, datum/reagents/holder)
	. = ..()
	var/volume = REAGENT_VOLUME(holder, type)
	if(!M.bloodstr.has_reagent(/decl/material/liquid/potassium_iodide, 0.1))
		M.apply_damage(1.5 * volume, IRRADIATE)
	else
		M.apply_damage(0.1 * volume, IRRADIATE)