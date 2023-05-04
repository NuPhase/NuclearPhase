/obj/machinery/communications
	anchored = 1
	density = 1

	var/free_penetration = 2 //how far can we transmit signal without it being blocked
	var/penetration_modifier = 1

	var/receiving_boost = 0

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
	free_penetration = 5
	penetration_modifier = 0.8
	receiving_boost = 25

/obj/machinery/communications/relay/Initialize()
	. = ..()
	radio_relays += src

/obj/machinery/communications/relay/Destroy()
	. = ..()
	radio_relays -= src

/obj/machinery/communications/relay/proc/relay(message) //yes
	for(var/obj/machinery/communications/relay/cur_relay in radio_relays)
		var/quality = get_global_signal_quality(get_turf(src), get_turf(cur_relay), free_penetration, penetration_modifier, cur_relay.receiving_boost)
		if(!quality)
			continue
		message = apply_message_quality(message, quality)
		cur_relay.receive_relay(message)

/obj/machinery/communications/relay/proc/receive_relay(message)