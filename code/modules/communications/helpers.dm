/proc/receive_comm_message(mob, message, frequency)
	to_chat(mob, SPAN_INFO("'[frequency]': '[message]'"))

/proc/apply_message_quality(message, quality)
	return message