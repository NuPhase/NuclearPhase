/obj/item/chems/drinks/cans
	volume = 400 //just over one and a half cups
	amount_per_transfer_from_this = 50
	atom_flags = 0 //starts closed
	material = /decl/material/solid/metal/aluminium

/obj/item/chems/drinks/cans/on_reagent_change()
	return

//DRINKS

/obj/item/chems/drinks/cans/cola
	name = "\improper Cola"
	desc = "Cola. Simple."
	icon_state = "cola"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/cola/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/cola, 30)

/obj/item/chems/drinks/cans/waterbottle
	name = "bottled water"
	desc = "Pure drinking water, purified in a factory. Extremely safe to drink."
	icon_state = "waterbottle"
	material = /decl/material/solid/plastic
	var/initial_reagent = /decl/material/liquid/water
	center_of_mass = @'{"x":15,"y":8}'

/obj/item/chems/drinks/cans/waterbottle/dirty
	initial_reagent = /decl/material/liquid/water/dirty1

/obj/item/chems/drinks/cans/waterbottle/Initialize()
	. = ..()
	reagents.add_reagent(initial_reagent, 30)

/obj/item/chems/drinks/cans/waterbottle/open(mob/user)
	playsound(loc,'sound/items/bottle_open.mp3', rand(10,50), 1)
	to_chat(user, "<span class='notice'>You twist open \the [src], destroying the safety seal!</span>")
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER

/obj/item/chems/drinks/cans/space_mountain_wind
	name = "\improper Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/space_mountain_wind/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/citrussoda, 30)

/obj/item/chems/drinks/cans/thirteenloko
	name = "\improper Thirteen Loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsibly."
	icon_state = "thirteen_loko"
	center_of_mass = @'{"x":16,"y":8}'

/obj/item/chems/drinks/cans/thirteenloko/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/ethanol/thirteenloko, 30)

/obj/item/chems/drinks/cans/dr_gibb
	name = "\improper Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."
	icon_state = "dr_gibb"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/dr_gibb/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/cherrycola, 30)

/obj/item/chems/drinks/cans/starkist
	name = "\improper Star-Kist"
	desc = "Can you taste a bit of tuna...?"
	icon_state = "starkist"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/starkist/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/orangecola, 30)

/obj/item/chems/drinks/cans/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/space_up/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/lemonade, 30)

/obj/item/chems/drinks/cans/lemon_lime
	name = "\improper Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/lemon_lime/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/lemon_lime, 30)

/obj/item/chems/drinks/cans/iced_tea
	name = "\improper Vrisk Serket Iced Tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth?"
	icon_state = "ice_tea_can"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/iced_tea/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/tea/black, 25)
	reagents.add_reagent(/decl/material/solid/ice, 5)

/obj/item/chems/drinks/cans/grape_juice
	name = "\improper Grapel Juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	icon_state = "purple_can"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/grape_juice/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/juice/grape, 30)

/obj/item/chems/drinks/cans/tonic
	name = "\improper T-Borg's Tonic Water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/tonic/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/tonic, 30)

/obj/item/chems/drinks/cans/sodawater
	name = "soda water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	icon_state = "sodawater"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/sodawater/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/sodawater, 30)

/obj/item/chems/drinks/cans/beastenergy
	name = "Beast Energy"
	desc = "100% pure energy, and 150% pure liver disease."
	icon_state = "beastenergy"
	center_of_mass = @'{"x":16,"y":6}'

//Canned alcohols.

/obj/item/chems/drinks/cans/speer
	name = "\improper Space Beer"
	desc = "Now in a can!"
	icon_state = "beercan"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/speer/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/ethanol/beer/good, 30)

/obj/item/chems/drinks/cans/ale
	name = "\improper Magm-Ale"
	desc = "Now in a can!"
	icon_state = "alecan"
	center_of_mass = @'{"x":16,"y":10}'

/obj/item/chems/drinks/cans/ale/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/ethanol/ale, 30)