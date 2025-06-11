/decl/material/solid/dead_bacteria
	name = "dead bacteria"
	uid = "solid_bacteria_dead"
	color = COLOR_BEASTY_BROWN
	scannable = 1
	taste_description = "dead swamp"

/decl/material/solid/bacteria
	name = "bacteria"
	lore_text = "A microorganism."
	uid = "solid_bacteria_generic"
	color = COLOR_GREEN
	scannable = 1
	taste_description = "swamp"
	dirtiness = 2
	chilling_point = T0C
	chilling_products = list(
		/decl/material/solid/dead_bacteria = 1
	)
	chilling_sound = null
	heating_point = 40 CELSIUS
	heating_products = list(
		/decl/material/solid/dead_bacteria = 1
	)
	heating_sound = null



// PENNICILIN
/decl/material/solid/bacteria/penicillium
	name = "penicillium mold"
	uid = "solid_bacteria_penicillium"
	color = COLOR_PALE_YELLOW
	dissolves_in = MAT_SOLVENT_MODERATE
	dissolves_into = list(/decl/material/liquid/antibiotics/penicillin = 0.1)

/decl/material/solid/bacteria/penicillium/fed
	name = "fed penicillium mold"
	uid = "solid_bacteria_penicillium_fed"
	heating_point = 30 CELSIUS
	heating_products = list(
		/decl/material/solid/bacteria/penicillium = 1.1
	)
	heating_sound = null
	heating_message = null

/decl/chemical_reaction/pennicilium_feeding
	name = "Penicillium Feeding"
	result = /decl/material/solid/bacteria/penicillium/fed
	required_reagents = list(/decl/material/solid/bacteria/penicillium = 1, /decl/material/liquid/nutriment/glucose = 1)
	result_amount = 1
	reaction_sound = null
	mix_message = null



// TYROSINE
/decl/material/solid/bacteria/tyrosine
	name = "tyrosine bacteria"
	uid = "solid_bacteria_tyrosine"
	dissolves_in = MAT_SOLVENT_MODERATE
	dissolves_into = list(/decl/material/liquid/tyrosine = 0.25)

/decl/chemical_reaction/tyrosinebreeding
	name = "Tyrosine Breeding"
	result = /decl/material/solid/bacteria/tyrosine
	required_reagents = list(/decl/material/solid/bacteria/tyrosine = 1, /decl/material/liquid/nutriment/glucose = 1)
	catalysts = list(/decl/material/liquid/enzyme = 1)
	result_amount = 2
	reaction_sound = null
	mix_message = null