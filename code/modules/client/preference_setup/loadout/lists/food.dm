/decl/loadout_category/food
	name = "Food"

/decl/loadout_option/food
	category = /decl/loadout_category/food

/decl/loadout_option/food/tea
	name = "tea packet"
	description = "A tea packet from the old times. Worth a fortune nowadays."
	path = /obj/item/chems/condiment/small/packet/tea
	cost = 10

/decl/loadout_option/food/coffee
	name = "coffee packet"
	description = "A tea packet from the old times. Worth two fortunes nowadays."
	path = /obj/item/chems/condiment/small/packet/coffee
	cost = 12

/decl/loadout_option/food/clean_water
	name = "purified water bottle"
	description = "The cleanest water that could be found in this shitty shelter."
	path = /obj/item/chems/drinks/cans/waterbottle
	cost = 30

/decl/loadout_option/food/normal_water
	name = "water bottle"
	description = "A typical water bottle. Isn't exactly clean, but it won't cause any trouble."
	path = /obj/item/chems/drinks/cans/waterbottle/dirty
	cost = 10

/decl/loadout_option/food/water_cleaner
	name = "water disinfection packet"
	description = "Contains a premade water cleaning mix. Can clean up to a liter of liquid."
	path = /obj/item/chems/condiment/small/packet/waterpurifier
	cost = 25

/decl/loadout_option/food/lunchbox
	name = "filled lunchbox selection"
	path = /obj/item/storage/lunchbox/filled
	cost = 40

/decl/loadout_option/food/lunchbox/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"default" =        /obj/item/storage/lunchbox/filled,
		"heart" =          /obj/item/storage/lunchbox/heart/filled,
		"cat" =  		   /obj/item/storage/lunchbox/cat/filled,
		"mars" =      	   /obj/item/storage/lunchbox/mars/filled,
		"cti" =    		   /obj/item/storage/lunchbox/cti/filled,
		"black&red" = 	   /obj/item/storage/lunchbox/syndicate/filled
	)