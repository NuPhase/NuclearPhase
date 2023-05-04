/obj/item/communications
	name = "comm device"

	var/free_penetration = 2 //how far can we transmit signal without it being blocked
	var/penetration_modifier = 1

	var/receiving_boost = 0

	var/frequency = "172.9"

/obj/item/communications/proc/transmit(var/message)
	var/obj/machinery/communications/relay/cur_relay = try_find_relay()
	if(cur_relay)
		var/quality = get_local_signal_quality(get_turf(src), get_turf(cur_relay), free_penetration, penetration_modifier, cur_relay.receiving_boost)
		message = apply_message_quality(message, quality)
		cur_relay.relay(message)
	else
		for(var/M in human_mob_list)
			var/obj/item/communications/receiving_radio
			var/quality = get_global_signal_quality(get_turf(src), get_turf(M), free_penetration, penetration_modifier, receiving_radio.receiving_boost)
			if(!quality)
				continue
			message = apply_message_quality(message, quality)
			receive_comm_message(M, message, frequency)

/obj/item/communications/proc/try_find_relay() //TODO: OPTIMIZE
	for(var/obj/machinery/communications/relay/cur_relay)
		var/turf/our_turf = get_turf(src)
		if(cur_relay.z == our_turf.z)
			return cur_relay
	return null