/obj/machinery/reactor_monitor/warnings
	name = "control system output display"
	program_overlay = "warnings"

/obj/machinery/reactor_monitor/warnings/Initialize()
	. = ..()
	rcontrol.announcement_monitors += src

/obj/machinery/reactor_monitor/warnings/proc/chat_report(message, urgency)
	switch(urgency)
		if(1)
			loc.visible_message("[src] declares: [SPAN_NOTICE(message)].")
		if(2)
			loc.visible_message("[src] beeps: [SPAN_WARNING(message)].")
		if(3)
			loc.visible_message("[src] buzzes: [SPAN_DANGER(message)]!")

/obj/machinery/reactor_monitor/warnings/get_display_data()
	. = ..()
	var/data = ""
	for(var/message in rcontrol.all_messages)
		switch(rcontrol.all_messages[message])
			if(1)
				message = SPAN_NOTICE(message)
			if(2)
				message = SPAN_WARNING(message)
			if(3)
				message = SPAN_DANGER(message)
		data += "[message]<br>"
	return data