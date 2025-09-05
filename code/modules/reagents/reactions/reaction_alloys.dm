/decl/chemical_reaction/alloy
	minimum_temperature = GENERIC_SMELTING_HEAT_POINT
	maximum_temperature = INFINITY
	reaction_sound = null
	mix_message = null

/decl/chemical_reaction/alloy/borosilicate
	name = "Borosilicate Glass"
	result = /decl/material/solid/glass/borosilicate
	required_reagents = list(
		/decl/material/solid/glass = 2,
		/decl/material/solid/metal/platinum = 1
	)
	result_amount = 3

/decl/chemical_reaction/alloy/steel
	name = "Carbon Steel Alloy"
	result = /decl/material/solid/metal/steel
	required_reagents = list(
		/decl/material/solid/metal/iron = 98,
		/decl/material/solid/carbon = 2
	)
	result_amount = 100
	minimum_temperature = 1710

/decl/chemical_reaction/alloy/inconel
	name = "Inconel Alloy"
	result = /decl/material/solid/metal/inconel
	required_reagents = list(
		/decl/material/solid/metal/rare_metals = 75,
		/decl/material/solid/metal/chromium = 14,
		/decl/material/solid/metal/iron = 10,
		/decl/material/solid/metal/copper = 1
	)
	result_amount = 100
	minimum_temperature = 2400

/decl/chemical_reaction/alloy/bronze
	name = "Bronze Alloy"
	result = /decl/material/solid/metal/bronze
	required_reagents = list(
		/decl/material/solid/metal/copper = 4,
		/decl/material/solid/metal/tin = 1
	)
	result_amount = 5

/decl/chemical_reaction/alloy/brass
	name = "Brass Alloy"
	result = /decl/material/solid/metal/brass
	required_reagents = list(
		/decl/material/solid/metal/copper = 2,
		/decl/material/solid/metal/zinc = 1
	)
	result_amount = 3

/decl/chemical_reaction/alloy/blackbronze
	name = "Black Bronze Billon"
	result = /decl/material/solid/metal/blackbronze
	required_reagents = list(
		/decl/material/solid/metal/copper = 2,
		/decl/material/solid/metal/silver = 1
	)
	result_amount = 3

/decl/chemical_reaction/alloy/redgold
	name = "Red Gold Billon"
	result = /decl/material/solid/metal/redgold
	required_reagents = list(
		/decl/material/solid/metal/copper = 2,
		/decl/material/solid/metal/gold = 1
	)
	result_amount = 3

/decl/chemical_reaction/alloy/stainlesssteel
	name = "Stainless Steel Alloy"
	result = /decl/material/solid/metal/stainlesssteel
	required_reagents = list(
		/decl/material/solid/metal/steel = 9,
		/decl/material/solid/metal/chromium = 1
	)
	result_amount = 10

/decl/chemical_reaction/alloy/hafniumcarbide
	name = "Hafnium Carbide"
	result = /decl/material/solid/stone/ceramic/hafniumcarbide
	required_reagents = list(
		/decl/material/solid/carbon = 1,
		/decl/material/solid/metal/rare_metals = 1
	)
	catalysts = list(/decl/material/gas/argon = 1)
	inhibitors = list(/decl/material/gas/nitrogen = 1)
	result_amount = 1
	minimum_temperature = 2400

/decl/chemical_reaction/alloy/hafniumcarbonitride
	name = "Hafnium Carbonitride"
	result = /decl/material/solid/stone/ceramic/hafniumcarbonitride
	required_reagents = list(
		/decl/material/gas/nitrogen = 1,
		/decl/material/solid/carbon = 1,
		/decl/material/solid/metal/rare_metals = 1
	)
	result_amount = 1
	minimum_temperature = 2400
	minimum_pressure = 25000