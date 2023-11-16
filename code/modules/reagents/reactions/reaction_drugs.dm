/decl/chemical_reaction/pacid
	name = "Polytrinic acid"
	result = /decl/material/liquid/acid/polyacid
	required_reagents = list(/decl/material/liquid/acid = 1, /decl/material/liquid/acid/hydrochloric = 1, /decl/material/solid/potassium = 1)
	result_amount = 3

/decl/chemical_reaction/presyncopics
	name = "Presyncopics"
	result = /decl/material/liquid/presyncopics
	required_reagents = list(/decl/material/solid/potassium = 1, /decl/material/liquid/acetone = 1, /decl/material/liquid/nutriment/sugar = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = 60 CELSIUS
	result_amount = 3

/decl/chemical_reaction/amphetamines
	name = "Amphetamines"
	result = /decl/material/liquid/amphetamines
	required_reagents = list(/decl/material/liquid/nutriment/sugar = 1, /decl/material/solid/phosphorus = 1, /decl/material/solid/sulfur = 1)
	result_amount = 3

/decl/chemical_reaction/retrovirals
	name = "Retrovirals"
	result = /decl/material/liquid/retrovirals
	required_reagents = list(/decl/material/liquid/antirads = 1, /decl/material/solid/carbon = 1)
	result_amount = 2

/decl/chemical_reaction/nanitefluid
	name = "Nanite Fluid"
	result = /decl/material/liquid/nanitefluid
	required_reagents = list(/decl/material/liquid/plasticide = 1, /decl/material/solid/metal/aluminium = 1, /decl/material/liquid/lube = 1)
	catalysts = list(/decl/material/liquid/crystal_agent = 1)
	result_amount = 3
	minimum_temperature = (-25 CELSIUS) - 100
	maximum_temperature = -25 CELSIUS
	mix_message = "The solution becomes a metallic slime."

/decl/chemical_reaction/surfactant
	name = "Azosurfactant"
	result = /decl/material/liquid/surfactant
	required_reagents = list(/decl/material/liquid/fuel/hydrazine = 2, /decl/material/solid/carbon = 2, /decl/material/liquid/acid = 1)
	result_amount = 5
	mix_message = "The solution begins to foam gently."

/decl/chemical_reaction/space_cleaner
	name = "Space cleaner"
	result = /decl/material/liquid/cleaner
	required_reagents = list(/decl/material/gas/ammonia = 1, /decl/material/liquid/water = 1)
	result_amount = 2

/decl/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	result = /decl/material/liquid/weedkiller
	required_reagents = list(
		/decl/material/liquid/bromide = 1,
		/decl/material/liquid/water = 4
	)
	result_amount = 5

/decl/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	result = /decl/material/liquid/foaming_agent
	required_reagents = list(/decl/material/solid/lithium = 1, /decl/material/liquid/fuel/hydrazine = 1)
	result_amount = 1
	mix_message = "The solution begins to foam vigorously."

/decl/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	result = /decl/material/solid/sodiumchloride
	required_reagents = list(/decl/material/solid/sodium = 1, /decl/material/liquid/acid/hydrochloric = 1)
	result_amount = 2

/decl/chemical_reaction/stimulants
	name = "Stimulants"
	result = /decl/material/liquid/stimulants
	required_reagents = list(/decl/material/liquid/hallucinogenics = 1, /decl/material/solid/lithium = 1)
	result_amount = 3

/decl/chemical_reaction/antidepressants
	name = "Antidepressants"
	result = /decl/material/liquid/antidepressants
	required_reagents = list(/decl/material/liquid/hallucinogenics = 1, /decl/material/solid/carbon = 1)
	result_amount = 3

/decl/chemical_reaction/hair_remover
	name = "Hair Remover"
	result = /decl/material/liquid/hair_remover
	required_reagents = list(/decl/material/solid/metal/radium = 1, /decl/material/solid/potassium = 1, /decl/material/liquid/acid/hydrochloric = 1)
	result_amount = 3
	mix_message = "The solution thins out and emits an acrid smell."

/decl/chemical_reaction/methyl_bromide
	name = "Methyl Bromide"
	required_reagents = list(
		/decl/material/liquid/bromide = 1,
		/decl/material/liquid/ethanol = 1,
		/decl/material/liquid/fuel/hydrazine = 1
	)
	result_amount = 3
	result = /decl/material/gas/methyl_bromide
	mix_message = "The solution begins to bubble, emitting a dark vapor."

/decl/chemical_reaction/immunobooster
	result = /decl/material/liquid/immunobooster
	required_reagents = list(/decl/material/liquid/presyncopics = 1, /decl/material/liquid/antitoxins = 1)
	minimum_temperature = 40 CELSIUS
	result_amount = 2



/decl/chemical_reaction/sulfuric_morphine
	name = "Morphine Synthesis - Step 1"
	result = /decl/material/liquid/sulfuric_morphine
	required_reagents = list(/decl/material/liquid/opium = 1, /decl/material/liquid/acid = 2)
	mix_message = "The morphine binds to the sulfuric acid with a hiss."
	result_amount = 3