/decl/material/solid/slag
	name = "slag"
	lore_text = "A crazy mix of various metals, minerals and ceramics. A result of poor alloying."
	uid = "solid_slag"
	color = "#5c5a3d"
	ore_name = "slag"
	ore_desc = "Someone messed up..."
	ore_icon_overlay = "lump"
	reflectiveness = MAT_VALUE_DULL
	wall_support_value = MAT_VALUE_LIGHT
	construction_difficulty = MAT_VALUE_HARD_DIY
	hardness = MAT_VALUE_SOFT
	flags = MAT_FLAG_BRITTLE
	value = 0.1
	default_solid_form = /obj/item/stack/material/lump
	exoplanet_rarity = MAT_RARITY_NOWHERE

	toxicity = 10

	// Slag can be reclaimed into more useful forms by grinding it up and mixing it with strong acid.
	dissolves_in = MAT_SOLVENT_STRONG
	dissolves_into = list(
		/decl/material/solid/sand =    0.2,
		/decl/material/liquid/water/dirty4 = 0.5,
		/decl/material/solid/metal/iron =      0.1,
		/decl/material/solid/metal/aluminium = 0.05,
		/decl/material/solid/phosphorus =      0.05,
		/decl/material/gas/sulfur_dioxide =    0.05,
		/decl/material/gas/carbon_dioxide =    0.05
	)

	molar_mass = 0.05414
	gas_specific_heat = 40.2

	liquid_density = 2160
	solid_density = 2560

	melting_point = 1512 CELSIUS
	boiling_point = 2228 CELSIUS