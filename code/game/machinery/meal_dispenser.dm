/obj/machinery/meal_dispenser
	name = "meal dispenser"
	desc = "A machine that dispenses non-spoiling meals."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "compressor-off"
	density = 1
	anchored = 1
	var/meals_left = 18
	var/list/food_types = list(
		/obj/item/chems/food/sandwich,
		/obj/item/chems/food/toastedsandwich,
		/obj/item/chems/food/grilledcheese,
		/obj/item/chems/food/tossedsalad,
		/obj/item/chems/food/boiledrice,
		/obj/item/chems/food/boiledspagetti,
		/obj/item/chems/food/pastatomato,
		/obj/item/chems/food/meatballspagetti
	)
	var/list/second_food_types = list(
		/obj/item/chems/food/cracker,
		/obj/item/chems/food/cheesiehonkers,
		/obj/item/chems/food/meatcube
	)
	var/list/drink_types = list(
		/decl/material/liquid/drink/milk/soymilk,
		/decl/material/liquid/drink/milkshake,
		/decl/material/liquid/drink/kefir,
		/decl/material/liquid/drink/compote
	)

/obj/machinery/meal_dispenser/physical_attack_hand(mob/user)
	. = ..()
	if(!meals_left)
		to_chat(user, SPAN_WARNING("There is no food left in \the [src]."))
		return
	meals_left -= 1
	var/obj/item/tray = new /obj/item/storage/tray/metal/aluminium
	var/food_type = pick(food_types)
	var/second_food_type = pick(second_food_types)
	tray.contents += new food_type
	tray.contents += new second_food_type
	var/obj/item/chems/drink = new /obj/item/chems/drinks/glass2
	drink.reagents.add_reagent(pick(drink_types), drink.volume)
	tray.contents += drink
	tray.update_icon()
	user.put_in_hands(tray)
	playsound(src, 'sound/machines/podopen.ogg', 50)
	user.visible_message(SPAN_NOTICE("[user] takes a meal from \the [src]."), SPAN_NOTICE("You take a meal from \the [src]."))