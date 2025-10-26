/obj/item/communications
	name = "comm device"

	var/free_penetration = 2 //how far can we transmit signal without it being blocked
	var/penetration_modifier = 1

	var/receiving_boost = 0

	var/frequency = "172.9"

	var/intercom_handling = FALSE

/obj/item/communications/proc/transmit(var/message, mob/user)
	var/obj/machinery/communications/relay/cur_relay = try_find_relay()
	playsound(loc, pick('sound/effects/radio1.mp3', 'sound/effects/radio2.mp3'), 20, 0, -1)
	if(cur_relay && cur_relay.is_functioning())
		var/quality = get_signal_quality(get_turf(user), get_turf(cur_relay), free_penetration, penetration_modifier, cur_relay.receiving_boost)
		cur_relay.relay(apply_message_quality(message, quality, user), frequency, user.voice_flavor)
	else
		for(var/mob/M in human_mob_list)
			var/obj/item/communications/receiving_radio = locate(/obj/item/communications) in M.contents
			if(!receiving_radio)
				continue
			var/quality = get_signal_quality(get_turf(user), get_turf(M), free_penetration, penetration_modifier, receiving_radio.receiving_boost)
			if(!quality)
				continue
			receive_comm_message(M, apply_message_quality(message, quality, M), frequency, user.voice_flavor)

	for(var/mob/observer/O in ghost_mob_list)
		receive_comm_message(O, message, frequency, user.voice_flavor)

/obj/item/communications/proc/try_find_relay()
	for(var/obj/machinery/communications/relay/cur_relay in radio_relays)
		var/turf/our_turf = get_turf(src)
		if(cur_relay.z == our_turf.z)
			return cur_relay
	return null

/obj/item/communications/pocket_radio
	name = "handheld radio"
	icon = 'icons/obj/items/device/radio/radio.dmi'
	icon_state = "walkietalkie"
	item_state = "walkietalkie"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	throw_speed = 2
	throw_range = 9
	w_class = ITEM_SIZE_SMALL
	intercom_handling = TRUE
	penetration_modifier = 0.7