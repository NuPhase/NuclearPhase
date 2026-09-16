#define WATER_MOLES_HALF ((150000 * 0.5) / 0.018)

/obj/machinery/multitile/condenser
	name = "shell-tube condenser"
	icon = 'icons/obj/atmospherics/multiport/condenser.dmi'
	icon_state = "base"

	map_port_volume = 5000

	width = 4
	height = 1
	bound_width = 160
	bound_height = 64

	map_ports = list(
		list(1, 0, SOUTH, "Steam IN"),
		list(2, 0, SOUTH, "Water OUT"),
		list(4, 0, SOUTH, "Coolant IN"),
		list(4, 1, NORTH, "Coolant OUT"),
		list(1, 1, NORTH, "Non-condensibles OUT"),
	)

	var/datum/gas_mixture/constant_pressure/air_contents
	var/coolant_valve_coef = 0 // 0-1

/obj/machinery/multitile/condenser/Initialize()
	. = ..()
	var/datum/gas_mixture/steam_inlet =    port_gases["Steam IN"]
	var/datum/gas_mixture/coolant_inlet =  port_gases["Coolant IN"]
	var/datum/gas_mixture/coolant_outlet = port_gases["Coolant OUT"]
	var/datum/gas_mixture/noncon_outlet =  port_gases["Non-condensibles OUT"]
	steam_inlet.volume =    	100000
	steam_inlet.suction_moles = 100000
	coolant_inlet.volume =  	60000
	coolant_outlet.volume = 	60000
	noncon_outlet.volume  = 	100

	air_contents = new(150000)
	air_contents.adjust_gas(/decl/material/gas/nitrogen, 1)
	air_contents.adjust_gas(/decl/material/liquid/water, (150000 * 0.7) / 0.018)
	air_contents.temperature = 350
	reactor_components["condenser"] = src

/obj/machinery/multitile/condenser/Process()
	var/datum/gas_mixture/steam_inlet =    port_gases["Steam IN"]
	var/datum/gas_mixture/water_outlet =   port_gases["Water OUT"]
	var/datum/gas_mixture/coolant_inlet =  port_gases["Coolant IN"]
	var/datum/gas_mixture/coolant_outlet = port_gases["Coolant OUT"]
	var/datum/gas_mixture/noncon_outlet =  port_gases["Non-condensibles OUT"]

	var/liquid_moles = air_contents.total_moles - air_contents.gas_moles
	if(water_outlet.available_volume > 2000 && liquid_moles > WATER_MOLES_HALF)
		water_outlet.merge(air_contents.remove(min(75000, liquid_moles - WATER_MOLES_HALF)))

	var/noncondensible_moles = 0
	for(var/g in air_contents.gas)
		if(g == /decl/material/liquid/water)
			continue
		noncondensible_moles += air_contents.gas[g]
		air_contents.adjust_gas(g, (air_contents.gas[g] * -0.01) - 0.001)
		noncon_outlet.adjust_gas(g, (air_contents.gas[g] * 0.01) + 0.001)

	if((steam_inlet.pressure - air_contents.pressure) > 10)
		air_contents.merge(steam_inlet.remove_ratio(1))

	if(coolant_valve_coef)
		var/datum/gas_mixture/coolant_pass = coolant_inlet.remove_ratio(coolant_valve_coef)
		air_contents.exchange_heat(coolant_pass)
		coolant_outlet.merge(coolant_pass)

	air_contents.pressure = 40 + (noncondensible_moles * R_IDEAL_GAS_EQUATION * air_contents.temperature / air_contents.available_volume)
	if(air_contents.temperature > 300)
		air_contents.pressure += (((air_contents.temperature - 300) / 150)**2) * ONE_ATMOSPHERE

#undef WATER_MOLES_HALF