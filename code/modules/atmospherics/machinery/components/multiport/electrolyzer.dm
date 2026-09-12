/obj/machinery/multitile/electrolyzer
	name = "electrolyzer"
	icon = 'icons/obj/atmospherics/multiport/cflow_exchanger.dmi'
	icon_state = "base"
	color = COLOR_ALUMINIUM

	map_port_volume = 5000

	width = 2
	height = 0
	bound_width = 96
	bound_height = 32

	map_ports = list(
		list(1, 0, SOUTH, "Tank")
	)
	spawn_power_terminal = TRUE

/obj/machinery/multitile/electrolyzer/Process()
	if(!power_port.powernet)
		return
	var/datum/gas_mixture/air_contents = port_gases["Tank"]

	var/conducted_amperage = air_contents.total_moles * 100

	var/available_power = min(power_port.powernet.max_power, conducted_amperage * power_port.powernet.voltage)
	if(!available_power)
		return

	power_port.powernet.draw_power(available_power)

	for(var/fluid in air_contents.liquids)
		var/decl/material/mat = GET_DECL(fluid)
		if(!mat.electrolysis_products)
			continue
		else
			var/electrolyzed_amount = min(air_contents.liquids[fluid], (available_power / mat.electrolysis_energy) / mat.electrolysis_difficulty)
			for(var/product in mat.electrolysis_products)
				air_contents.adjust_gas(product, mat.electrolysis_products[product] * electrolyzed_amount, FALSE)
			air_contents.liquids[fluid] -= electrolyzed_amount
			air_contents.update_values()
			break

	air_contents.add_thermal_energy(available_power * 0.25)