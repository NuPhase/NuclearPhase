SUBSYSTEM_DEF(chat)
	name = "Chat"
	wait = 1
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	priority = SS_PRIORITY_CHAT
	init_order = SS_INIT_CHAT
	var/static/list/payload = list()

/datum/controller/subsystem/chat/fire(resumed)
	for(var/key in payload)
		var/client/client = key
		var/our_payload = payload[key]
		our_payload -= key
		if(client)
			// Send to tgchat
			client.tgui_panel?.window.send_message("chat/message", our_payload)
			// Send to old chat
			for(var/message in our_payload)
				direct_output(client, message_to_html(message))
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/chat/proc/queue(target, message, handle_whitespace = TRUE, trailing_newline = TRUE)
	if(islist(target))
		for(var/_target in target)
			var/client/client = CLIENT_FROM_VAR(_target)
			if(client)
				LAZYADD(payload[client], list(message))
		return
	var/client/client = CLIENT_FROM_VAR(target)
	if(client)
		LAZYADD(payload[client], list(message))