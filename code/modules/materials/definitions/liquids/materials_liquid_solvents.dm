/decl/material/liquid/acid
	name = "sulphuric acid"
	uid = "liquid_sulphuric_acid"
	lore_text = "A very corrosive mineral acid with the molecular formula H2SO4."
	taste_description = "acid"
	color = "#db5008"
	metabolism = REM * 2
	touch_met = 50 // It's acid!
	value = 1.2
	solvent_power = MAT_SOLVENT_STRONG + 2
	solvent_melt_dose = 60
	solvent_max_damage = 30
	boiling_point = 290 CELSIUS
	melting_point = 10 CELSIUS
	latent_heat = 25730
	molar_mass = 0.098

/decl/material/liquid/acid/hydrochloric //Like sulfuric, but less toxic and more acidic.
	name = "hydrochloric acid"
	uid = "liquid_hydrochloric_acid"
	lore_text = "A very corrosive mineral acid with the molecular formula HCl."
	taste_description = "stomach acid"
	color = "#808080"
	solvent_power = MAT_SOLVENT_STRONG
	solvent_melt_dose = 48
	solvent_max_damage = 30
	value = 1.5
	boiling_point = 48 CELSIUS
	melting_point = -30 CELSIUS
	molar_mass = 0.036

/decl/material/liquid/acid/nitric
	name = "nitric acid"
	uid = "liquid_nitric_acid"
	lore_text = "A very corrosive acid made from air."
	color = "#c48870"
	solvent_power = MAT_SOLVENT_STRONG
	solvent_melt_dose = 48
	solvent_max_damage = 30
	value = 1.5

/decl/material/liquid/acid/boric
	name = "boric acid"
	uid = "boric_acid"
	lore_text = "A weak acid."
	color = "#808080"
	solvent_power = MAT_SOLVENT_MILD
	solvent_melt_dose = 120
	solvent_max_damage = 5
	value = 1.5

/decl/material/liquid/acid/hydrogen_peroxide
	name = "hydrogen peroxide"
	uid = "hydrogen_peroxide"
	lore_text = "A very weak acid. It is used as an oxidizer, bleaching agent, and antiseptic, usually as a dilute solution (3%-6% by weight) in water for consumer use and in higher concentrations for industrial use. Concentrated hydrogen peroxide, or 'high-test peroxide', decomposes explosively when heated and has been used as both a monopropellant and an oxidizer in rocketry."
	color = "#c9edf0"
	solvent_power = MAT_SOLVENT_MILD
	solvent_melt_dose = 120
	solvent_max_damage = 5
	liquid_density = 1450
	melting_point = 272.72
	boiling_point = 423.3
	molar_mass = 0.034014
	gas_specific_heat = 98
	gas_flags = XGM_GAS_OXIDIZER
	oxidizer_power = 6
	heating_point = 40 CELSIUS
	heating_sound = 'sound/chemistry/bufferadd.ogg'
	heating_products = list(/decl/material/liquid/water = 0.77, /decl/material/gas/oxygen = 521)
	heating_temperature_product = 100
	reactivity_coefficient = 0.01

/decl/material/liquid/acid/polyacid
	name = "polytrinic acid"
	uid = "liquid_polytrinic_acid"
	lore_text = "Polytrinic acid is a an extremely corrosive chemical substance."
	taste_description = "acid"
	color = "#8e18a9"
	solvent_power = MAT_SOLVENT_STRONG + 7
	solvent_melt_dose = 24
	solvent_max_damage = 60
	value = 1.8
	exoplanet_rarity = MAT_RARITY_UNCOMMON

/decl/material/liquid/acid/stomach
	name = "stomach acid"
	uid = "liquid_stomach_acid"
	taste_description = "coppery foulness"
	solvent_power = MAT_SOLVENT_STRONG
	color = "#d8ff00"
	hidden_from_codex = TRUE
	value = 0
	exoplanet_rarity = MAT_RARITY_UNCOMMON

/decl/material/liquid/acetone
	name = "acetone"
	uid = "liquid_acetone"
	lore_text = "A colorless liquid solvent used in chemical synthesis."
	taste_description = "acid"
	color = "#808080"
	metabolism = REM * 0.2
	value = 0.1
	solvent_power = MAT_SOLVENT_MODERATE
	toxicity = 3
	boiling_point = 56 CELSIUS
	melting_point = -95 CELSIUS
	latent_heat = 32000
	molar_mass = 0.058
