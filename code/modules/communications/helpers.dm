/proc/receive_comm_message(mob/user, message, frequency, flavor, translated)
	if(user.is_deaf())
		return
	to_chat(user, SPAN_RADIO("\[[frequency]\]\[[SPAN_ITALIC(flavor)]\]: \"[message]\""))
	if(!translated && text_needs_translation(message, user.get_preference_value(/datum/client_preference/autotranslate)))
		SSautotranslate.request_translation(message, user.client, "Radio", weakref(user))

/proc/apply_message_quality(message, quality, mob/user)
	return RadioChat(user, message, 100 - quality, (100-quality)*0.1)