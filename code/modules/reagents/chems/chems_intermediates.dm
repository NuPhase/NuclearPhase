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