/decl/material/liquid/sulfuric_morphine
	name = "sulfuric morphine"
	lore_text = "Morphine with a lot of sulfuric acid traces in it."
	heating_products = list(/decl/material/liquid/opium/morphine = 1, /decl/material/solid/sulfur = 1)
	heating_message = "All sulphuric acid evaporates, leaving a mess of purple liquid and yellow powder."
	heating_point = 140 CELSIUS
	uid = "chem_sulfuricmorphine"

/decl/material/liquid/piperidone
	name = "4-piperidone"
	lore_text = "An opioid drug precursor."
	uid = "chem_piperidone"
	boiling_point = 79 CELSIUS
	molar_mass = 0.099133
	ignition_point = 91 CELSIUS
	combustion_energy = 3400000
	burn_product = /decl/material/gas/carbon_dioxide
	gas_flags = XGM_GAS_FUEL
	heating_products = list(/decl/material/liquid/benzylfentanyl = 0.33, /decl/material/solid/carbon = 0.2, /decl/material/gas/methane = 10)
	heating_point = 270 CELSIUS

/decl/material/liquid/norfentanyl
	name = "norfentanyl"
	lore_text = "A fentanyl precursor."
	uid = "chem_norfentanyl"
	molar_mass = 0.232327

/decl/material/liquid/benzylfentanyl
	name = "benzylfentanyl"
	lore_text = "A fentanyl precursor."
	uid = "chem_benzylfentanyl"
	molar_mass = 0.322452

/decl/material/liquid/tyrosine
	name = "tyrosine"
	lore_text = "A very important amino acid in biology."
	uid = "chem_tyrosine"
	molar_mass = 0.181191

/decl/material/liquid/anthraquinone
	name = "anthraquinone"
	uid = "anthraquinone"
	lore_text = "An aromatic organic compound."
	color = "#e6cd7d"
	liquid_density = 1438
	solid_density = 1438
	melting_point = 558
	boiling_point = 650
	molar_mass = 0.0208



// Rare earth line
/decl/material/solid/rare_earth
	name = "rare earth"
	uid = "rare_earth"
	lore_text = "A mixture of many, many rare elements. It's very impure and still unseparated."
	mechanics_text = "Leave it in a barrel with hydrochloric acid for a long time to purify it further."
	weight = MAT_VALUE_VERY_LIGHT
	hardness = MAT_VALUE_SOFT
	reflectiveness = MAT_VALUE_MATTE
	default_solid_form = /obj/item/stack/material/lump
	color = "#b68844"
	liquid_density = 2900
	solid_density = 3089
	latent_heat = 352700
	gas_specific_heat = 24
	melting_point = 1814
	boiling_point = 3109
	reactivity_coefficient = 0.0002
	dissolves_in = MAT_SOLVENT_STRONG
	dissolves_into = list(
		/decl/material/solid/rare_earth_leached = 0.8,
		/decl/material/solid/metal/chromium = 0.1,
		/decl/material/solid/metal/iron = 0.1
	)
	dissolve_sound = null
	dissolve_message = null

/decl/material/solid/rare_earth_leached
	name = "rare earth (leached)"
	uid = "rare_earth_leached"
	lore_text = "A mixture of many, many rare elements. It passed its first separation step, ridding it of most common impurities."
	mechanics_text = "Bake it in a furnace at 2045K to degas it and complete refinement."
	weight = MAT_VALUE_VERY_LIGHT
	hardness = MAT_VALUE_SOFT
	reflectiveness = MAT_VALUE_MATTE
	default_solid_form = /obj/item/stack/material/lump
	color = "#c28569"
	liquid_density = 2900
	solid_density = 3089
	latent_heat = 352700
	gas_specific_heat = 24
	melting_point = 1814
	boiling_point = 3109
	reactivity_coefficient = 0.001
	heating_point = 2000
	heating_products = list(
		/decl/material/solid/metal/rare_metals = 0.99,
		/decl/material/gas/carbon_dioxide = 15
	)
	heating_temperature_product = -0.01
	heating_message = null
	heating_sound = null