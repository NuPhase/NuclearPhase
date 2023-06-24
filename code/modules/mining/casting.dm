/obj/item/casting_shape
	name = "blank casting mold"
	desc = "A polymer casting mold. This one is blank."
	icon = 'icons/obj/mining.dmi'
	icon_state = "casting_form"
	var/accepted_materials = list()
	var/output_item = null
	var/is_material = FALSE
	var/weight_cost = 1 //kg
	var/filled = FALSE
	var/filled_icon_state = ""

/obj/item/casting_shape/ingot
	name = "ingot casting mold"
	desc = "A polymer casting mold. This one is made for ingots."
	accepted_materials = list(/decl/material/solid/metal)
	output_item = /obj/item/stack/material/ingot
	is_material = TRUE
	weight_cost = 2

/obj/item/casting_shape/honeycomb
	name = "honeycomb casting mold"
	desc = "A polymer casting mold. This one is made for special honeycomb structures that can be cut. Heat shielding applications."
	accepted_materials = list(/decl/material/solid/carbon, /decl/material/solid/boron)
	output_item = /obj/item/stack/material/ingot
	is_material = FALSE
	weight_cost = 10