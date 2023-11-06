/proc/receive_comm_message(mob, message, frequency)
	to_chat(mob, SPAN_RADIO("\[[frequency]\]: \"[message]\""))

/proc/apply_message_quality(message, quality, mob/user)
	return RadioChat(user, message, 100 - quality, (100-quality)*0.1)