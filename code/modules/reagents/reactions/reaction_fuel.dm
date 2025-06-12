/decl/chemical_reaction/diborane
	name = "Diborane"
	result = /decl/material/gas/diborane
	required_reagents = list(/decl/material/solid/sodium = 1, /decl/material/gas/hydrogen = 2, /decl/material/solid/iodine = 1, /decl/material/solid/boron = 1)
	catalysts = list(/decl/material/gas/hydrogen = 2)
	mix_message = "A barely distinguishable vapor begins to form."
	result_amount = 3

/decl/chemical_reaction/biodiesel
	name = "Biodiesel"
	result = /decl/material/liquid/biodiesel
	required_reagents = list(/decl/material/liquid/nutriment/cornoil = 5, /decl/material/liquid/ethanol = 1)
	catalysts = list(/decl/material/solid/potash = 10)
	result_amount = 5
