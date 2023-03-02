/obj/machinery/power/generator/battery
	name = "battery"
	desc = "A device capable of storing electrical power."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "anomaly_container"
	var/capacity = 0 //in watthour
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

//let's assume that all our batteries are 400 liters in volume unless written otherwise
//https://en.wikipedia.org/wiki/Rechargeable_battery
/obj/machinery/power/generator/battery/lead //85Wh/l capacity
	name = "lead acid battery"
	desc = "Are we in 2000s?.."
	max_capacity = 68000
	voltage = 400
	amperage = 950
	efficiency = 0.6

/obj/machinery/power/generator/battery/lithium_ion //300Wh/l capacity
	name = "primitive lithium-ion battery" //these can be manufactured easily
	desc = "Lithium-Ion batteries are still cheap and practical in our day and age. Even with appearance of new and more dense batteries, lithium-ion ones still reign supreme in cost. This one looks sketchy."
	max_capacity = 120000
	voltage = 400
	amperage = 700
	efficiency = 0.8

/obj/machinery/power/generator/battery/lithium_ion/normal //710Wh/l capacity
	name = "lithium-ion battery" //hard to manufacture
	desc = "Lithium-Ion batteries are still cheap and practical in our day and age. Even with appearance of new and more dense batteries, lithium-ion ones still reign supreme in cost."
	max_capacity = 267000
	voltage = 400
	amperage = 750
	efficiency = 0.9

/obj/machinery/power/generator/battery/quantum //1270Wh/l capacity, found in a sus document. 800l volume
	name = "quantum battery" //IMPOSSIBLE to manufacture
	desc = "Despite the pseudosciencey name, this is real technology, it's just top-level semiconductor exploitation. Not every millionaire was able to afford these, though... Be careful with one."
	max_capacity = 1016000
	voltage = 4000 //FEED THE CHONKER REACTOR PUMPS
	amperage = 450 //WAAAAH
	efficiency = 0.95
