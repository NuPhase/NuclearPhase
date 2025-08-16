/decl/material/liquid/fuel
	name = "welding fuel"
	lore_text = "A stable hydrazine-based compound whose exact manufacturing specifications are a closely-guarded secret. One of the most common fuels in human space. Extremely flammable."
	taste_description = "gross metal"
	color = "#660000"
	touch_met = 5
	fuel_value = 1
	burn_product = /decl/material/gas/carbon_monoxide
	gas_flags = XGM_GAS_FUEL
	combustion_energy = 70000
	exoplanet_rarity = MAT_RARITY_UNCOMMON
	uid = "chem_fuel"

	glass_name = "welder fuel"
	glass_desc = "Unless you are an industrial tool, this is probably not safe for consumption."
	value = 1.5

/decl/material/liquid/fuel/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(2 * removed)

/decl/material/liquid/fuel/hydrazine
	name = "hydrazine"
	lore_text = "A toxic, colorless, flammable liquid with a strong ammonia-like odor, in hydrate form."
	taste_description = "sweet tasting metal"
	color = "#808080"
	metabolism = REM * 0.2
	touch_met = 5
	value = 1.2
	fuel_value = 1.2
	uid = "chem_hydrazine"



/decl/material/liquid/pentaborane
	name = "pentaborane"
	lore_text = "Pentaborane is an extremely toxic, extremely flammable, corrosive substance. Its second name is 'Green Dragon' because of its flame color."
	taste_description = "sour milk"
	color = "#ffffff"
	touch_met = 5
	fuel_value = 4
	fire_color = "#1ef002"
	fire_alpha = 220
	toxicity = 8
	gas_flags = XGM_GAS_FUEL
	exoplanet_rarity = MAT_RARITY_UNCOMMON
	uid = "pentaborane"
	glass_name = "fiery death"
	glass_desc = "If you see this, you are probably already engulfed in green flames."
	value = 1.5
	combustion_energy = 8704000
	combustion_activation_energy = 21800
	oxidizer_to_fuel_ratio = 6
	combustion_products = list(/decl/material/gas/oxygen = /decl/material/liquid/acid/boric)

/decl/material/liquid/pentaborane/affect_ingest(mob/living/carbon/human/H, removed, datum/reagents/holder) //stomach temperature is enough, WE COMBUST
	. = ..()
	H.adjust_fire_stacks(removed * 10)
	H.IgniteMob()
	H.visible_message(SPAN_DANGER("Green flames rush out of [H]'s mouth!"))

/decl/material/gas/diborane
	name = "diborane"
	lore_text = "Diborane, is the chemical compound with the formula B2H6. It is a toxic, colorless, and pyrophoric gas with a repulsively sweet odor."
	taste_description = "repulsive sweetness"
	color = "#ffffff"
	touch_met = 5
	fuel_value = 2
	fire_color = "#cbee8a"
	fire_alpha = 140
	toxicity = 4
	heating_products = list(/decl/material/liquid/pentaborane = 0.7, /decl/material/solid/boron = 0.3)
	heating_point = 470
	gas_flags = XGM_GAS_FUEL
	exoplanet_rarity = MAT_RARITY_UNCOMMON
	uid = "diborane"
	value = 1.3
	combustion_energy = 2167000
	combustion_activation_energy = 26000
	oxidizer_to_fuel_ratio = 3
	combustion_products = list(/decl/material/gas/oxygen = /decl/material/liquid/acid/boric)

/decl/material/solid/trinitrotoluene
	name = "trinitrotoluene"
	lore_text = "TNT is occasionally used as a reagent in chemical synthesis, but it is best known as an explosive material with convenient handling properties. The explosive yield of TNT is considered to be the standard comparative convention of bombs and asteroid impacts."
	color = "#e4ff49"
	touch_met = 5
	fuel_value = 3
	fire_alpha = 140
	toxicity = 1.3
	burn_product = /decl/material/gas/carbon_dioxide
	gas_flags = XGM_GAS_FUEL|XGM_GAS_OXIDIZER
	oxidizer_power = 5
	combustion_energy = 3291500
	uid = "tnt"
	ignition_point = 986
	molar_mass = 0.227
	default_solid_form = /obj/item/stack/material/cubes

/decl/material/solid/cyclonite
	name = "cyclonite"
	lore_text = "A widely used explosive and propellant."
	color = "#c7e710"
	touch_met = 5
	fuel_value = 3
	fire_alpha = 140
	toxicity = 1.1
	burn_product = /decl/material/gas/carbon_dioxide
	gas_flags = XGM_GAS_FUEL|XGM_GAS_OXIDIZER
	oxidizer_power = 7
	combustion_energy = 4937250
	uid = "cyclonite"
	ignition_point = 477
	molar_mass = 0.222
	default_solid_form = /obj/item/stack/material/cubes