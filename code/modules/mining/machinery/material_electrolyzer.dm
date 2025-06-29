/obj/machinery/atmospherics/unary/electrolyzer
	name = "industrial electrolyzer"
	icon = 'icons/obj/atmospherics/components/unary/electrolyzer.dmi'
	icon_state = "off"
	anchored = 1
	density = 1
	active_power_usage = 1000000
	idle_power_usage = 1000 //KEEP DAH BASIN COOL GODDAMN
	use_power = POWER_USE_OFF
	uncreated_component_parts = null
	interact_offline = TRUE

/obj/machinery/atmospherics/unary/electrolyzer/Initialize()
	. = ..()
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/atmospherics/unary/electrolyzer/attack_hand(mob/user)
	. = ..()
	if(use_power)
		visible_message(SPAN_NOTICE("[user] switches \the [src] off."))
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		use_power = POWER_USE_OFF
		update_icon()
	else
		visible_message(SPAN_NOTICE("[user] switches \the [src] on."))
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		use_power = POWER_USE_IDLE
		update_icon()

/obj/machinery/atmospherics/unary/electrolyzer/on_update_icon()
	cut_overlays()
	if(use_power == POWER_USE_ACTIVE)
		icon_state = "on"
		add_overlay(emissive_overlay(icon, "lights"))
	else
		icon_state = "off"

/obj/machinery/atmospherics/unary/electrolyzer/Process()
	..()

	if(use_power == POWER_USE_OFF)
		return

	var/power_usage_multiplier = 1
	var/did_electrolyze = FALSE

	for(var/fluid in air_contents.solids)
		power_usage_multiplier += 0.1 //i don't see any active electrochemical reactions occuring in solid materials
	for(var/fluid in air_contents.gas)
		power_usage_multiplier += 0.2 //what the fuck do gases do in a liquid container? Fuck you.

	for(var/fluid in air_contents.liquids)
		var/decl/material/mat = GET_DECL(fluid)
		if(!mat.electrolysis_products)
			power_usage_multiplier += 0.1
		else
			var/electrolyzed_amount = min(air_contents.liquids[fluid], (initial(active_power_usage) / mat.electrolysis_energy) / mat.electrolysis_difficulty)
			for(var/product in mat.electrolysis_products)
				air_contents.adjust_gas(product, mat.electrolysis_products[product] * electrolyzed_amount, FALSE)
			air_contents.liquids[fluid] -= electrolyzed_amount
			air_contents.add_thermal_energy(electrolyzed_amount * mat.electrolysis_energy)
			air_contents.update_values()
			did_electrolyze = TRUE
			active_power_usage = electrolyzed_amount * mat.electrolysis_energy
			break

	if(did_electrolyze)
		use_power = POWER_USE_ACTIVE
	else
		use_power = POWER_USE_IDLE
