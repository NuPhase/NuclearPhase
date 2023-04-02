/obj/item/co2filter
	name = "small CO2 scrubber canister"
	var/capacity = 300
	var/power_consumption = 30 //watt
	icon = 'icons/obj/items/chem/chem_cartridge.dmi'
	icon_state = "cartridge"

/obj/item/co2filter/examine(mob/user, distance, infix, suffix)
	. = ..()
	to_chat(user, "It is [return_capacity()]% full")
	to_chat(user, "It will last for approximately [capacity] seconds")

/obj/item/co2filter/proc/clean_gasmix()
	if(capacity)
		capacity -= 1
		return TRUE
	return FALSE

/obj/item/co2filter/proc/return_capacity()
	return capacity / initial(capacity) * 100

/obj/item/co2filter/large
	name = "large CO2 scrubber canister"
	capacity = 900 //15 minutes
	power_consumption = 70

/obj/item/co2filter/regenerative
	name = "regenerative CO2 scrubber"
	capacity = 100
	power_consumption = 440

/obj/item/co2filter/regenerative/clean_gasmix()
	return TRUE