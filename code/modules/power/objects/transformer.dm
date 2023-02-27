/obj/machinery/power/generator/transformer
	name = "power transformer"
	icon = 'icons/obj/power.dmi'
	icon_state = "transformer"
	var/coef = 2
	var/obj/machinery/power/generator/transformer/connected = null
	var/max_cap = 75 AMPER

	efficiency = 0.9

/obj/machinery/power/generator/transformer/Process()
	if(connected)
		return
	connected = locate(/obj/machinery/power/generator/transformer, get_step(src, dir))
	if(connected)
		connected.connected = src

/obj/machinery/power/generator/transformer/get_voltage()
	if(!powernet || !connected.powernet || (available() > connected.available()))
		return 0
	return connected.powernet.voltage * coef

/obj/machinery/power/generator/transformer/available_power()
	if(!powernet || !connected.powernet || (available() > connected.available()))
		return 0
	return min(max_cap, connected.available())

/obj/machinery/power/generator/transformer/on_power_drain(w)
	if(!powernet || !connected.powernet || (available() > connected.available()))
		return 0
	return connected.draw_power(w)