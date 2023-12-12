/obj/item/chems/jerrycan
	name = "fuel canister"
	base_name = "fuel canister"
	desc = "A 5L jerrycan."
	icon = 'icons/obj/items/chem/jerrycan.dmi'
	icon_state = ICON_STATE_WORLD
	amount_per_transfer_from_this = 1000
	possible_transfer_amounts = @"[50,100,150,250,1000,5000]"
	w_class = ITEM_SIZE_NORMAL
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	item_flags = 0
	obj_flags = 0
	weight = 0.6
	volume = 5000
	material = /decl/material/solid/metal/steel
	applies_material_colour = FALSE
	show_reagent_name = FALSE