/obj/item/co2filter
	name = "CO2 filter canister"
	var/capacity = 300
	var/power_consumption = 30 //watt

/obj/item/co2filter/examine(mob/user, distance, infix, suffix)
	. = ..()
	to_chat(user, "It is [return_capacity()]% full")

/obj/item/co2filter/proc/clean_gasmix()
	if(capacity)
		capacity -= 1
		return TRUE
	return FALSE

/obj/item/co2filter/proc/return_capacity()
	return capacity / initial(capacity) * 100