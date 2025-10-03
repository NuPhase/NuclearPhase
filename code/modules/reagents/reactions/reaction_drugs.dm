/decl/chemical_reaction/pacid
	name = "Polytrinic acid"
	result = /decl/material/liquid/acid/polyacid
	required_reagents = list(/decl/material/liquid/acid = 1, /decl/material/liquid/acid/hydrochloric = 1, /decl/material/solid/potassium = 1)
	result_amount = 3

/decl/chemical_reaction/nitric_acid
	name = "Nitric acid"
	result = /decl/material/liquid/acid/nitric
	required_reagents = list(/decl/material/gas/nitrodioxide = 2, /decl/material/liquid/water = 1)
	result_amount = 1
	mix_message = "The orange vapors condense into the vapors."
	reaction_sound = null
	maximum_temperature = 40 CELSIUS

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

/decl/chemical_reaction/oxycodone
	name = "Oxycodone Synthesis"
	result = /decl/material/liquid/opium/oxycodone
	required_reagents = list(/decl/material/liquid/opium/codeine = 3, /decl/material/liquid/acid/hydrogen_peroxide = 1, /decl/material/liquid/water = 1)
	catalysts = list(/decl/material/solid/metal/chromium = 50, /decl/material/liquid/acid/hydrochloric = 10)
	result_amount = 3
	minimum_temperature = 35 CELSIUS

/decl/chemical_reaction/desomorphine
	name = "Desomorphine Synthesis"
	result = /decl/material/liquid/opium/codeine/desomorphine
	required_reagents = list(/decl/material/liquid/opium/codeine = 3, /decl/material/liquid/ethanol = 1, /decl/material/solid/iodine = 1, /decl/material/liquid/acid/hydrochloric = 1)
	result_amount = 3

/decl/chemical_reaction/piperidone
	name = "4-Piperidone Synthesis"
	result = /decl/material/liquid/piperidone
	required_reagents = list(/decl/material/liquid/pentaborane = 1, /decl/material/gas/nitricoxide = 1)
	result_amount = 1

/decl/chemical_reaction/norfentanyl
	name = "Norfentanyl Synthesis"
	result = /decl/material/liquid/norfentanyl
	required_reagents = list(/decl/material/liquid/piperidone = 5, /decl/material/gas/ammonia = 1)
	result_amount = 5

/decl/chemical_reaction/fentanyl
	name = "Fentanyl Synthesis"
	result = /decl/material/liquid/opium/fentanyl
	required_reagents = list(/decl/material/liquid/norfentanyl = 1, /decl/material/liquid/benzylfentanyl = 1)
	result_amount = 1.5

/decl/chemical_reaction/propofol
	name = "Propofol Synthesis"
	result = /decl/material/liquid/propofol
	required_reagents = list(/decl/material/liquid/acetone = 1, /decl/material/liquid/tar = 3)
	catalysts = list(/decl/material/solid/metal/platinum = 5)
	result_amount = 3

/decl/chemical_reaction/suxamethonium_one
	name = "Suxamethonium Synthesis I"
	result = /decl/material/liquid/suxamethonium
	required_reagents = list(/decl/material/solid/carbon = 7, /decl/material/gas/hydrogen = 14, /decl/material/gas/chlorine = 1, /decl/material/gas/nitrodioxide = 4)
	catalysts = list(/decl/material/solid/metal/silver = 20)
	result_amount = 1
	minimum_temperature = 300 CELSIUS

/decl/chemical_reaction/suxamethonium_two
	name = "Suxamethonium Synthesis II"
	result = /decl/material/liquid/suxamethonium
	required_reagents = list(/decl/material/gas/methane = 7, /decl/material/liquid/acid/hydrochloric = 2, /decl/material/gas/nitrodioxide = 2)
	catalysts = list(/decl/material/liquid/acid/hydrochloric = 50)
	result_amount = 1

/decl/chemical_reaction/dopamine
	name = "Dopamine Synthesis"
	result = /decl/material/liquid/dopamine
	required_reagents = list(/decl/material/liquid/tyrosine = 1)
	catalysts = list(/decl/material/liquid/enzyme = 10)
	result_amount = 1

/decl/chemical_reaction/noradrenaline
	name = "Noradrenaline Synthesis"
	result = /decl/material/liquid/noradrenaline
	required_reagents = list(/decl/material/liquid/dopamine = 1)
	catalysts = list(/decl/material/liquid/enzyme = 50)
	result_amount = 1

/decl/chemical_reaction/adrenaline
	name = "Adrenaline Synthesis"
	result = /decl/material/liquid/adrenaline
	required_reagents = list(/decl/material/liquid/noradrenaline = 2, /decl/material/liquid/ethanol = 1)
	result_amount = 2

/decl/chemical_reaction/amicile
	name = "Amicile Synthesis"
	result = /decl/material/liquid/antibiotics/amicile
	required_reagents = list(/decl/material/liquid/antibiotics/penicillin = 3, /decl/material/liquid/tyrosine = 1, /decl/material/liquid/acid/hydrochloric = 1)
	result_amount = 3

/decl/chemical_reaction/ceftriaxone
	name = "Ceftriaxone Synthesis"
	result = /decl/material/liquid/antibiotics/ceftriaxone
	required_reagents = list(/decl/material/liquid/piperidone = 1, /decl/material/liquid/tyrosine = 1, /decl/material/liquid/acid/hydrochloric = 1)
	result_amount = 1

/decl/chemical_reaction/nitroglycerin
	name = "Nitroglycerin Synthesis"
	result = /decl/material/liquid/nitroglycerin
	required_reagents = list(/decl/material/liquid/nutriment/cornoil = 5, /decl/material/liquid/acid/nitric = 1)
	result_amount = 5

/decl/chemical_reaction/potassium_iodide
	name = "Potassium Iodide Synthesis"
	result = /decl/material/liquid/potassium_iodide
	required_reagents = list(/decl/material/solid/potassium = 1, /decl/material/solid/iodine = 2)
	result_amount = 1