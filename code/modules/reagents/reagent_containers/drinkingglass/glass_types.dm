/obj/item/chems/drinks/glass2/square
	name = "half-pint glass"
	base_name = "glass"
	base_icon = "square"
	icon = 'icons/obj/drink_glasses/square.dmi'
	desc = "Your standard drinking glass."
	filling_states = @"[20,40,60,80,100]"
	volume = 300
	possible_transfer_amounts = @"[5,10,15,30]"
	rim_pos = @'{"y":23,"x_left":13,"x_right":20}'

/obj/item/chems/drinks/glass2/rocks
	name = "rocks glass"
	desc = "A robust tumbler with a thick, weighted bottom."
	base_name = "glass"
	base_icon = "rocks"
	icon = 'icons/obj/drink_glasses/rocks.dmi'
	filling_states = @"[25,50,75,100]"
	volume = 200
	possible_transfer_amounts = @"[5,10,20]"
	rim_pos = @'{"y":21,"x_left":10,"x_right":23}'

/obj/item/chems/drinks/glass2/shake
	name = "sherry glass"
	desc = "Stemware with an untapered conical bowl."
	base_name = "glass"
	base_icon = "shake"
	icon = 'icons/obj/drink_glasses/shake.dmi'
	filling_states = @"[25,50,75,100]"
	volume = 300
	possible_transfer_amounts = @"[5,10,15,30]"
	rim_pos = @'{"y":25,"x_left":13,"x_right":21}'

/obj/item/chems/drinks/glass2/cocktail
	name = "cocktail glass"
	desc = "Fragile stemware with a stout conical bowl. Don't spill."
	base_name = "glass"
	base_icon = "cocktail"
	icon = 'icons/obj/drink_glasses/cocktail.dmi'
	filling_states = @"[33,66,100]"
	volume = 150
	possible_transfer_amounts = @"[5,10,15]"
	rim_pos = @'{"y":22,"x_left":13,"x_right":21}'

/obj/item/chems/drinks/glass2/shot
	name = "shot glass"
	desc = "A small glass, designed so that its contents can be consumed in one gulp."
	base_name = "shot"
	base_icon = "shot"
	icon = 'icons/obj/drink_glasses/shot.dmi'
	filling_states = @"[33,66,100]"
	volume = 50
	material = /decl/material/solid/glass
	possible_transfer_amounts = @"[1,2,5]"
	rim_pos = @'{"y":17,"x_left":13,"x_right":21}'

/obj/item/chems/drinks/glass2/pint
	name = "pint glass"
	base_name = "pint"
	base_icon = "pint"
	icon = 'icons/obj/drink_glasses/pint.dmi'
	filling_states = @"[16,33,50,66,83,100]"
	volume = 600
	material = /decl/material/solid/glass
	possible_transfer_amounts = @"[5,10,15,30,60]"
	rim_pos = @'{"y":25,"x_left":12,"x_right":21}'

/obj/item/chems/drinks/glass2/mug
	name = "glass mug"
	desc = "A heavy mug with thick walls."
	base_name = "mug"
	base_icon = "mug"
	icon = 'icons/obj/drink_glasses/mug.dmi'
	filling_states = @"[25,50,75,100]"
	volume = 400
	possible_transfer_amounts = @"[5,10,20,40]"
	rim_pos = @'{"y":22,"x_left":12,"x_right":20}'

/obj/item/chems/drinks/glass2/wine
	name = "wine glass"
	desc = "A piece of elegant stemware."
	base_name = "glass"
	base_icon = "wine"
	icon = 'icons/obj/drink_glasses/wine.dmi'
	filling_states = @"[20,40,60,80,100]"
	volume = 250
	possible_transfer_amounts = @"[5,10,15,25]"
	rim_pos = @'{"y":25,"x_left":12,"x_right":21}'

/obj/item/chems/drinks/glass2/flute
	name = "flute glass"
	desc = "A piece of very elegant stemware."
	base_name = "glass"
	base_icon = "flute"
	icon = 'icons/obj/drink_glasses/flute.dmi'
	volume = 250
	filling_states = @"[20,40,60,80,100]"
	possible_transfer_amounts = @"[5,10,15,25]"
	rim_pos = @'{"y":24,"x_left":13,"x_right":19}'

/obj/item/chems/drinks/glass2/carafe
	name = "pitcher"
	desc = "A handled glass pitcher."
	base_name = "pitcher"
	base_icon = "carafe"
	icon = 'icons/obj/drink_glasses/carafe.dmi'
	filling_states = @"[10,20,30,40,50,60,70,80,90,100]"
	volume = 1200
	material = /decl/material/solid/glass
	possible_transfer_amounts = @"[5,10,15,30,60,120]"
	rim_pos = @'{"y":26,"x_left":12,"x_right":21}'
	center_of_mass = @'{"x":16,"y":7}'

/obj/item/chems/drinks/glass2/coffeecup
	name = "coffee cup"
	desc = "A plain white coffee cup."
	icon = 'icons/obj/drink_glasses/coffecup.dmi'
	icon_state = "coffeecup"
	item_state = "coffee"
	volume = 300
	center_of_mass = @"{'x':15,'y':13}"
	filling_states = @"[40,80,100]"
	base_name = "cup"
	base_icon = "coffeecup"
	rim_pos = @'{"y":22,"x_left":12,"x_right":20}'
	filling_overlayed = TRUE

/obj/item/chems/drinks/glass2/coffeecup/foundation
	name = "\improper Foundation coffee cup"
	desc = "A white coffee cup with the Cuchulain Foundation logo stencilled onto it."
	icon_state = "coffeecup_foundation"
	base_name = "\improper Foundation cup"

/obj/item/chems/drinks/glass2/coffeecup/black
	name = "black coffee cup"
	desc = "A sleek black coffee cup."
	icon_state = "coffeecup_black"
	base_name = "black cup"

/obj/item/chems/drinks/glass2/coffeecup/green
	name = "green coffee cup"
	desc = "A pale green and pink coffee cup."
	icon_state = "coffeecup_green"
	base_name = "green cup"

/obj/item/chems/drinks/glass2/coffeecup/heart
	name = "heart coffee cup"
	desc = "A white coffee cup, it prominently features a red heart."
	icon_state = "coffeecup_heart"
	base_name = "heart cup"

/obj/item/chems/drinks/glass2/coffeecup/one
	name = "#1 coffee cup"
	desc = "A white coffee cup, prominently featuring a #1."
	icon_state = "coffeecup_one"
	base_name = "#1 cup"

/obj/item/chems/drinks/glass2/coffeecup/punitelli
	name = "#1 monkey coffee cup"
	desc = "A white coffee cup, prominently featuring a \"#1 monkey\" decal."
	icon_state = "coffeecup_punitelli"
	base_name = "#1 monkey cup"

/obj/item/chems/drinks/glass2/coffeecup/punitelli/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/juice/banana, 30)
	update_icon()

/obj/item/chems/drinks/glass2/coffeecup/rainbow
	name = "rainbow coffee cup"
	desc = "A rainbow coffee cup. The colors are almost as blinding as a welder."
	icon_state = "coffeecup_rainbow"
	base_name = "rainbow cup"

/obj/item/chems/drinks/glass2/coffeecup/metal
	name = "metal coffee cup"
	desc = "A metal coffee cup. You're not sure which metal."
	icon_state = "coffeecup_metal"
	base_name = "metal cup"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/chems/drinks/glass2/coffeecup/STC
	name = "\improper ICCG coffee cup"
	desc = "A coffee cup adorned with the flag of the Gilgamesh Colonial Confederation, for when you need some espionage charges to go with your morning coffee."
	icon_state = "coffeecup_STC"
	base_name = "\improper ICCG cup"

/obj/item/chems/drinks/glass2/coffeecup/pawn
	name = "pawn coffee cup"
	desc = "A black coffee cup adorned with the image of a red chess pawn."
	icon_state = "coffeecup_pawn"
	base_name = "pawn cup"

/obj/item/chems/drinks/glass2/coffeecup/britcup
	name = "british coffee cup"
	desc = "A coffee cup with the British flag emblazoned on it."
	icon_state = "coffeecup_brit"
	base_name = "british cup"

/obj/item/chems/drinks/glass2/coffeecup/tall
	name = "tall coffee cup"
	desc = "An unreasonably tall coffee cup, for when you really need to wake up in the morning."
	icon = 'icons/obj/drink_glasses/coffecup_tall.dmi'
	icon_state = "coffeecup_tall"
	volume = 600
	center_of_mass = @'{"x":15,"y":19}'
	filling_states = @"[50,70,90,100]"
	base_name = "tall cup"
	base_icon = "coffeecup_tall"

/obj/item/chems/drinks/glass2/coffeecup/teacup
	name = "teacup"
	desc = "A plain white porcelain teacup."
	icon = 'icons/obj/drink_glasses/teacup.dmi'
	icon_state = "teacup"
	item_state = "coffee"
	volume = 200
	filling_states = @"[100]"
	base_name = "teacup"
	base_icon = "teacup"

/obj/item/chems/drinks/glass2/coffeecup/custom/inherit_custom_item_data(var/datum/custom_item/citem)
	. = ..()
	if(citem.additional_data["base_name"])
		base_name = citem.additional_data["base_name"] || base_name
	custom_name = citem.item_name
	custom_desc = citem.item_desc
