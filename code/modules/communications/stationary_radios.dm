/obj/machinery/communications
	anchored = 1
	density = 1

	var/free_penetration = 2 //how far can we transmit signal without it being blocked
	var/penetration_modifier = 1

	var/receiving_boost = 0

/obj/machinery/communications/proc/is_functioning()
	return powered(EQUIP)

/obj/machinery/communications/Initialize()
	. = ..()
	radio_machinery += src

/obj/machinery/communications/Destroy()
	. = ..()
	radio_machinery -= src

/obj/machinery/communications/proc/transmit(message, target)
	return

/obj/machinery/communications/relay
	name = "radio relay"
	icon = 'icons/obj/machines/tcomms/relay.dmi'
	icon_state = "relay"
	idle_power_usage = 14300
	free_penetration = 5
	penetration_modifier = 0.5 //yes.
	receiving_boost = 60

/obj/machinery/communications/relay/Initialize()
	. = ..()
	radio_relays += src

/obj/machinery/communications/relay/Destroy()
	. = ..()
	radio_relays -= src

/obj/machinery/communications/relay/proc/relay(message, frequency) //yes
	for(var/obj/machinery/communications/relay/cur_relay in radio_relays)
		var/quality = get_signal_quality(get_turf(src), get_turf(cur_relay), free_penetration, penetration_modifier, cur_relay.receiving_boost)
		if(!quality)
			continue
		message = apply_message_quality(message, quality)
		cur_relay.receive_relay(message, frequency)

/obj/machinery/communications/relay/proc/receive_relay(message, frequency)
	for(var/mob/M in human_mob_list)
		if(M.z != src.z)
			continue
		var/obj/item/communications/receiving_radio = locate(/obj/item/communications) in M.contents
		if(!receiving_radio)
			continue
		receive_comm_message(M, message, frequency)