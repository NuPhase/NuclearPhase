/obj/item/stack/ore
	name = "ore chunk"
	desc = "Unpurified chunks of rock with minerals in it. This isn't some game from 2011, right?"
	icon_state = "shiny"
	icon = 'icons/obj/ore.dmi'
	singular_name = "ore chunk"
	plural_name = "ore chunks"
	w_class = ITEM_SIZE_LARGE
	attack_cooldown = 21
	melee_accuracy_bonus = -20
	throw_speed = 5
	throw_range = 20
	max_amount = 150 //150kg in one item, should be okay
	var/true_mineral_name = "" //only visible to geologists
	var/list/composition //associative list of binary ratios
/*
	var/list/composition = list(
		var/decl/material/someshit = 0.3,
		var/decl/material/somepiss = 0.7
	)
*/
	var/crushed = FALSE

/obj/item/stack/ore/hematite //straightforward smelting to release oxygen
	color = "#a52e10"
	true_mineral_name = "hematite"
	composition = list(
		/decl/material/solid/metal/iron = 0.7,
		/decl/material/gas/oxygen = 0.3
	)

/obj/item/stack/ore/chalcopyrite // smelting = copper sulfide and iron, copper sulfide must be electrolyzed
	color = "#bdc018"
	true_mineral_name = "chalcopyrite"
	composition = list(
		/decl/material/solid/metal/iron = 0.35,
		/decl/material/solid/copper_sulfide = 0.65
	)