#define MIN_TEMP (0 CELSIUS)
#define IDEAL_TEMP (35 CELSIUS)
#define MAX_TEMP (60 CELSIUS)

#define IDEAL_PRESSURE 500
#define MAX_PRESSURE 1500

#define STAGE_CYCLE_COUNT 120

/obj/machinery/atmospherics/unary/dissolving_bioreactor
	name = "bioreactor"
	icon = 'icons/obj/atmospherics/atmos.dmi'
	icon_state = "siphon:0"
	density = TRUE
	var/alist/associative_stage_materials = alist(
		1 = list(/decl/material/gas/hydrogen = 0.04, /decl/material/liquid/water = 0.01),
		2 = list(/decl/material/gas/carbon_dioxide = 0.011, /decl/material/gas/ammonia = 0.011, /decl/material/gas/sulfur_dioxide = 0.004),
		3 = list(/decl/material/gas/carbon_dioxide = 0.002, /decl/material/gas/hydrogen = 0.05, /decl/material/liquid/acetone = 0.01),
		4 = list(/decl/material/gas/methane = 0.03, /decl/material/gas/carbon_dioxide = 0.004, /decl/material/liquid/water = 0.01)
	)
	var/sealed = FALSE
	var/nutrient_amount = 0
	var/current_stage = 1
	var/current_cycle = 0

/obj/machinery/atmospherics/unary/dissolving_bioreactor/Initialize()
	. = ..()
	air_contents.adjust_gas(/decl/material/gas/nitrogen, 2000)

/obj/machinery/atmospherics/unary/dissolving_bioreactor/examine(mob/user)
	. = ..()
	if(!sealed)
		to_chat(user, SPAN_NOTICE("It's open."))
	else
		to_chat(user, SPAN_NOTICE("It's closed."))
	if(MIN_TEMP > air_contents.temperature || air_contents.temperature > MAX_TEMP)
		to_chat(user, SPAN_WARNING("It doesn't work because of bad temperature."))
	if(air_contents.pressure > MAX_PRESSURE)
		to_chat(user, SPAN_WARNING("It doesn't work because of bad pressure."))
	if(current_stage == 5)
		to_chat(user, SPAN_NOTICE("It finished working."))

/obj/machinery/atmospherics/unary/dissolving_bioreactor/Process()
	. = ..()
	if(!sealed)
		return
	update_networks()
	if(MIN_TEMP > air_contents.temperature || air_contents.temperature > MAX_TEMP)
		return
	if(air_contents.pressure > MAX_PRESSURE)
		return
	if(current_stage == 5)
		return
	var/temp_coef = max(1 - (abs(air_contents.temperature - IDEAL_TEMP) * 0.002), 0.1)
	var/pressure_coef = max(1 - (abs(air_contents.pressure - IDEAL_PRESSURE) * 0.01), 0.1)
	if(!prob(100 * temp_coef * pressure_coef))
		return
	current_cycle++
	if(current_cycle > STAGE_CYCLE_COUNT)
		current_stage++
		current_cycle = 0
	if(current_stage == 5)
		return
	var/list/release_list = associative_stage_materials[current_stage]
	for(var/gas_id in release_list)
		air_contents.adjust_gas(gas_id, nutrient_amount * release_list[gas_id] / (STAGE_CYCLE_COUNT * 4), FALSE, FALSE)
	air_contents.add_thermal_energy(nutrient_amount * 2)
	air_contents.update_values()