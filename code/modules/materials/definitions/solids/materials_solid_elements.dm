/decl/material/solid/boron
	name = "boron"
	uid = "solid_boron"
	lore_text = "Boron is a chemical element with the symbol B and atomic number 5."
	flags = MAT_FLAG_FUSION_FUEL | MAT_FLAG_FISSIBLE

	neutron_interactions = list(
		"slow" = list(
			INTERACTION_SCATTER = 2,
			INTERACTION_ABSORPTION = 200
		),
		"fast" = list(
			INTERACTION_SCATTER = 2,
			INTERACTION_ABSORPTION = 0.4
		)
	)
	absorption_products = list(
		/decl/material/solid/lithium = 0.5,
		/decl/material/gas/helium = 0.5
	)
	neutron_absorption = 2000

/decl/material/solid/lithium
	name = "lithium"
	uid = "solid_lithium"
	lore_text = "A chemical element, used as antidepressant."
	flags = MAT_FLAG_FUSION_FUEL | XGM_GAS_FUEL
	combustion_energy = 2380
	burn_product = /decl/material/gas/oxygen
	taste_description = "metal"
	color = "#808080"
	value = 0.5
	narcosis = 5
	absorption_products = list(
		/decl/material/gas/hydrogen/tritium = 0.3,
		/decl/material/gas/helium = 0.7
	)
	neutron_interactions = list(
		"slow" = list(
			INTERACTION_SCATTER = 0.67,
			INTERACTION_ABSORPTION = 0.03
		),
		"fast" = list(
			INTERACTION_SCATTER = 0.03,
			INTERACTION_ABSORPTION = 0.13
		)
	)


/decl/material/solid/carbon
	name = "carbon"
	uid = "solid_carbon"
	lore_text = "A chemical element, the building block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	color = "#1c1300"
	value = 0.5
	dirtiness = 30
	neutron_interactions = list(
		"slow" = list(
			INTERACTION_SCATTER = 5,
			INTERACTION_ABSORPTION = 0.002
		),
		"fast" = list(
			INTERACTION_SCATTER = 2,
			INTERACTION_ABSORPTION = 0.00001
		)
	)
	melting_point = 3823
	boiling_point = 5100

/decl/material/solid/carbon/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested && LAZYLEN(ingested.reagent_volumes) > 1)
		var/effect = 1 / (LAZYLEN(ingested.reagent_volumes) - 1)
		for(var/R in ingested.reagent_volumes)
			if(R != type)
				ingested.remove_reagent(R, removed * effect)

/decl/material/solid/phosphorus
	name = "phosphorus"
	uid = "solid_phosphorus"
	lore_text = "A chemical element, the backbone of biological energy carriers."
	flags = XGM_GAS_FUEL
	combustion_energy = 137600
	burn_product = /decl/material/gas/carbon_dioxide
	taste_description = "vinegar"
	color = "#832828"
	fire_color = "#ffd271"
	value = 0.5

/decl/material/solid/silicon
	name = "silicon"
	uid = "solid_silicon"
	lore_text = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	color = "#a8a8a8"
	value = 0.5

/decl/material/solid/sodium
	name = "sodium"
	uid = "solid_sodium"
	lore_text = "A chemical element, readily reacts with water."
	taste_description = "salty metal"
	color = "#808080"
	value = 0.5

/decl/material/solid/caesium
	name = "caesium"
	uid = "caesium"
	lore_text = "A radioactive element commonly found in reactors."
	taste_description = "nothing"
	color = "#585858"
	value = 1

/decl/material/solid/iodine
	name = "iodine"
	uid = "iodine"
	lore_text = "A very common element in chemistry."
	taste_description = "fish"
	color = "#663a66"
	value = 1

/decl/material/solid/sulfur
	name = "sulfur"
	uid = "solid_sulfur"
	lore_text = "A chemical element with a pungent smell."
	taste_description = "old eggs"
	color = "#bf8c00"
	value = 0.5

/decl/material/solid/potassium
	name = "potassium"
	uid = "solid_potassium"
	lore_text = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	color = "#a0a0a0"
	value = 0.5

/decl/material/solid/potassium/affect_blood(var/mob/living/carbon/human/H, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	heart.bpm_modifiers[name] = volume * -8
	heart.cardiac_output_modifiers[name] = 1 - volume * 0.005