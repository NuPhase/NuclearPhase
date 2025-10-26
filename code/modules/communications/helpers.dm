/proc/receive_comm_message(mob/user, message, frequency, flavor)
	if(user.is_deaf())
		return
	to_chat(user, SPAN_RADIO("\[[frequency]\]\[[SPAN_ITALIC(flavor)]\]: \"[message]\""))

/proc/apply_message_quality(message, quality, mob/user)
	return RadioChat(user, message, 100 - quality, (100-quality)*0.1)