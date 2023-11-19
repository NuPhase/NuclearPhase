/obj/machinery/power/generator/disposable_reactor
	name = "HPD-MS reactor"
	desc = "High Power Disposable Molten Salt Reactor. Extreme power density, please be careful. Rated for 30 minutes of active operation. Can be used as an RTG after depletion."
	icon = 'icons/obj/machines/power/moltensalt_reactor.dmi'
	var/used = FALSE
	var/active = FALSE
	uncreated_component_parts = null
	obj_flags = OBJ_FLAG_ANCHORABLE

/obj/machinery/power/generator/disposable_reactor/available_power()
	if(active)
		return 2000000
	else if(used)
		return 15000 //decay heat
	else
		return 0

/obj/machinery/power/generator/disposable_reactor/physical_attack_hand(user)
	. = ..()
	if(used)
		return
	if(tgui_alert(user, "Are you sure you want to switch on the reactor? It won't be usable after it finishes running.", "Usage Warning", list("DESCEND HELL UPON EARTH!", "No...")) == "DESCEND HELL UPON EARTH!")
		used = TRUE
		active = TRUE
		SSradiation.radiate(src, 150)
		visible_message(SPAN_WARNING("[user] turns on the [src]!"))
		spawn(30 MINUTES)
			active = FALSE
		spawn(10)
			visible_message(SPAN_DANGER("The [src] whirrs up and starts roaring like a huge industrial generator!"))