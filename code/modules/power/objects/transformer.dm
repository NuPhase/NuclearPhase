/obj/machinery/power/generator/transformator
	icon = 'icons/obj/power.dmi'
	icon_state = "transformator"
	var/coef = 2
	var/obj/machinery/power/generator/transformator/connected = null
	var/max_cap = 75 AMPER

	efficiency = 0.75

/obj/machinery/power/generator/transformator/Process()
	if(connected)
		return
	connected = locate(/obj/machinery/power/generator/transformator, get_step(src, dir))
	if(connected)
		connected.connected = src

/obj/machinery/power/generator/transformator/get_voltage()
	if(!powernet || !connected.powernet || (available() > connected.available()))
		return 0
	return connected.powernet.voltage * coef

/obj/machinery/power/generator/transformator/available_power()
	if(!powernet || !connected.powernet || (available() > connected.available()))
		return 0
	return min(max_cap * connected.powernet.voltage * coef, connected.available())

/obj/machinery/power/generator/transformator/on_power_drain(w)
	if(!powernet || !connected.powernet || (available() > connected.available()))
		return 0
	return connected.draw_power(w)