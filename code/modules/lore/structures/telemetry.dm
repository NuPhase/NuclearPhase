/obj/structure/telemetry
	var/show_info = ""

/obj/structure/telemetry/attack_hand(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE(show_info))

/obj/structure/telemetry/server_rack
	name = "server rack"
	desc = "A typical looking server rack with a small 'QuantOS' logo on its side."
	show_info = "It doesn't have any visible data ports whatsoever..."
	icon = 'icons/obj/machines/tcomms/hub.dmi'
	icon_state = "hub"

/obj/structure/telemetry/server_rack/floor
	icon = 'icons/obj/structures/ship_decor.dmi'
	icon_state = "floor_server"

/obj/structure/telemetry/server_rack/destroyed
	desc = "This server rack looks fried from the inside..."
	show_info = "Nothing to be gathered here. Just heaps and heaps of burnt wiring."
	icon_state = "hub_o_off"

/obj/structure/telemetry/data_interface
	name = "data interfacing unit"
	desc = "This machine has lots of ports and loose wiring all around it."
	show_info = "Looks like you can upload data from it!"
	icon = 'icons/obj/machines/tcomms/processor.dmi'
	icon_state = "processor"

/obj/structure/telemetry/data_interface/attackby(obj/item/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/vehicle_component/reference_unit))
		var/obj/item/vehicle_component/reference_unit/nunit = O
		if(!nunit.is_updated)
			nunit.is_updated = TRUE
			visible_message(SPAN_NOTICE("[user] uploads data from [src] into [nunit]."))