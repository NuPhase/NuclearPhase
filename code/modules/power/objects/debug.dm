/obj/machinery/power/debug_items/
	icon = 'icons/obj/power.dmi'
	icon_state = "tracker"
	anchored = 1
	density = 1
	var/show_extended_information = 1	// Set to 0 to disable extra information on examining (for example, when used on admin events)

/obj/machinery/power/debug_items/examine(mob/user)
	. = ..()
	if(show_extended_information)
		show_info(user)

/obj/machinery/power/debug_items/proc/show_info(var/mob/user)
	if(!powernet)
		to_chat(user, "This device is not connected to a powernet.")
		return

	to_chat(user, "Connected to powernet: [powernet]")
	to_chat(user, "Available power: [num2text(powernet.lavailable, 20)] W")
	to_chat(user, "Load: [num2text(powernet.ldemand, 20)] W")
	to_chat(user, "Has alert: [powernet.problem ? "YES" : "NO"]")
	to_chat(user, "Cables: [powernet.cables.len]")
	to_chat(user, "Nodes: [powernet.nodes.len]")


// An infinite power generator. Adds energy to connected cable.
/obj/machinery/power/generator/debug_items/infinite_generator
	name = "Fractal Energy Reactor"
	desc = "An experimental power generator"
	var/power_generation_rate = 10000000
	var/voltage = 4400

/obj/machinery/power/generator/debug_items/infinite_generator/get_voltage()
	return voltage

/obj/machinery/power/generator/debug_items/infinite_generator/available_power()
	return power_generation_rate

/obj/machinery/power/generator/debug_items/infinite_generator/on_power_drain(w)
	return w


// A cable powersink, without the explosion/network alarms normal powersink causes.
/obj/machinery/power/debug_items/infinite_cable_powersink
	name = "Null Point Core"
	desc = "An experimental device that disperses energy, used for grid testing purposes."
	var/power_usage_rate = 0
	var/last_used = 0

/obj/machinery/power/debug_items/infinite_cable_powersink/Process()
	last_used = draw_power(power_usage_rate)

/obj/machinery/power/debug_items/infinite_cable_powersink/show_info(var/mob/user)
	..()
	to_chat(user, "Power sink is demanding [num2text(power_usage_rate, 20)] W")
	to_chat(user, "[num2text(last_used, 20)] W was actually used last tick")


/obj/machinery/power/debug_items/infinite_apc_powersink
	name = "APC Dummy Load"
	desc = "A dummy load that connects to an APC, used for load testing purposes."
	use_power = POWER_USE_ACTIVE
	active_power_usage = 0

/obj/machinery/power/debug_items/infinite_apc_powersink/show_info(var/mob/user)
	..()
	to_chat(user, "Dummy load is using [num2text(active_power_usage, 20)] W")
	to_chat(user, "Powered: [!(stat & NOPOWER) ? "YES" : "NO"]")
