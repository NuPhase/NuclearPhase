/obj/item/chemical_vessel/sealable/beaker
	name = "beaker"
	desc = "A beaker."
	icon = 'icons/obj/items/chem/beakers/beaker.dmi'
	starting_volume = 1.5
	icon_state = ICON_STATE_WORLD
	center_of_mass = @"{'x':15,'y':10}"
	material = /decl/material/solid/glass
	applies_material_name = TRUE
	applies_material_colour = TRUE
	material_force_multiplier = 0.25

/obj/item/chemical_vessel/sealable/beaker/Initialize()
	. = ..()
	desc += " It can hold up to [internal.volume] liters."

/obj/item/chemical_vessel/sealable/beaker/large
	name = "large beaker"
	desc = "A large beaker."
	icon = 'icons/obj/items/chem/beakers/large.dmi'
	center_of_mass = @"{'x':16,'y':10}"
	starting_volume = 3
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,60,120]"
	material_force_multiplier = 0.5
	w_class = ITEM_SIZE_LARGE