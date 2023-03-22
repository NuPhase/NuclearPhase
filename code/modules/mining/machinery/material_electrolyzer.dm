/obj/machinery/atmospherics/unary/electrolyzer
	name = "industrial electrolyzer"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "extractor"
	anchored = 1
	density = 1
	active_power_usage = 90000 //electrolyzing molten metals is tough, to say the least. Bound to get A LOT worse.
	idle_power_usage = 5000 //KEEP DAH BASIN COOL GODDAMN
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
	else
		visible_message(SPAN_NOTICE("[user] switches \the [src] on."))
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/atmospherics/unary/electrolyzer/Process()
	..()

	var/power_usage_multiplier = 1
	var/did_electrolyze = FALSE
	for(var/fluid in air_contents.gas)
		switch(air_contents.phases[fluid])
			if(MAT_PHASE_SOLID)
				power_usage_multiplier += 0.1 //i don't see any active electrochemical reactions occuring in solid materials
			if(MAT_PHASE_LIQUID)
				var/decl/material/mat = GET_DECL(fluid)
				if(!mat.electrolysis_products)
					power_usage_multiplier += 0.1
				else
					for(var/product in mat.electrolysis_products)
						var/decl/material/prod_mat = GET_DECL(product)
						var/produce_amount = (air_contents.gas[fluid] + 1) * prod_mat.electrolysis_difficulty * 0.1
						air_contents.adjust_gas_temp(product, produce_amount, air_contents.temperature)
						air_contents.adjust_gas(fluid, !produce_amount)
					did_electrolyze = TRUE
			if(MAT_PHASE_GAS)
				power_usage_multiplier += 0.2 //what the fuck do gases do in a liquid container? Fuck you.
	if(did_electrolyze)
		active_power_usage = initial(active_power_usage) * power_usage_multiplier
		use_power = POWER_USE_ACTIVE
	else
		use_power = POWER_USE_IDLE
