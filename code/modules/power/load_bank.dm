/obj/machinery/power/load_bank
	name = "load bank"
	desc = "A load bank is a piece of electrical test equipment used to simulate an electrical load, to test an electric power source without connecting it to its normal operating load."
	icon = 'icons/obj/cellrack.dmi'
	icon_state = "rack"
	var/operational = FALSE
	var/power_usage_rate = 0
	var/max_usage_rate = 500000
	var/last_used = 0

/obj/machinery/power/load_bank/physical_attack_hand(user)
	if(!operational)
		operational = TRUE
		visible_message(SPAN_NOTICE("[user] switches \the [src] on."), SPAN_NOTICE("You switch \the [src] on."))
	else
		operational = FALSE
		visible_message(SPAN_NOTICE("[user] switches \the [src] off."), SPAN_NOTICE("You switch \the [src] off."))

/obj/machinery/power/load_bank/attackby(obj/item/W, mob/user)
	if(IS_MULTITOOL(W))
		var/chosen_rate = input(user, "Select a new load for \the [src].", "Load Bank Configuration", power_usage_rate) as null|num
		chosen_rate = clamp(chosen_rate, 0, max_usage_rate)
		power_usage_rate = chosen_rate
	. = ..()

/obj/machinery/power/load_bank/Process()
	if(operational)
		last_used = draw_power(power_usage_rate)

/obj/machinery/power/load_bank/examine(mob/user)
	. = ..()
	if(operational)
		to_chat(user, SPAN_NOTICE("\The [src] seems operational."))
	to_chat(user, SPAN_NOTICE("It is set to produce a load of [power_usage_rate]W"))

/obj/machinery/power/load_bank/reactor
	uid = "load_bank"
	max_usage_rate = 5000000000

/obj/machinery/power/load_bank/reactor/Initialize()
	. = ..()
	reactor_components[uid] = src