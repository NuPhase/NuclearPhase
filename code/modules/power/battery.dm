/obj/machinery/power/generator/battery
	name = "battery"
	desc = "A device capable of storing electrical power."
	var/capacity = 10000 //in watthour
	var/max_capacity = 10000
	var/amperage = 30
	var/voltage = 220
	should_heat = TRUE
	anchored = TRUE
	//a reminder that watts are amperage*voltage

/obj/machinery/power/generator/battery/examine(mob/user)
	. = ..()
	to_chat(user, "It is rated for [max_capacity]Wh.")

/obj/machinery/power/generator/battery/available_power()
	return min(capacity / CELLRATE, amperage * voltage)

/obj/machinery/power/generator/battery/get_voltage()
	return voltage

/obj/machinery/power/generator/battery/on_power_drain(w)
	capacity -= w * CELLRATE

/obj/machinery/power/generator/battery/Process()
	if(!powernet)
		return
	var/requesting_power = amperage * voltage
	if(powernet.lavailable < requesting_power)
		return
	capacity += min(max_capacity, powernet.draw_power(requesting_power) * CELLRATE * efficiency)

/obj/machinery/power/generator/battery/attackby(obj/item/W, mob/user)
	if(IS_WRENCH(W))
		if(!anchored)
			to_chat(user, "<span class='notice'>You secure \the [src] to the floor.</span>")
		else
			to_chat(user, "<span class='notice'>You unsecure \the [src] from the floor.</span>")

		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		anchored = !anchored
	if(IS_MULTITOOL(W))
		to_chat(user, SPAN_NOTICE("It has [capacity]Wh of charge left."))
		to_chat(user, SPAN_NOTICE("It outputs power at [amperage]A and [voltage]V."))
	. = ..()