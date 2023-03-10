/datum/mood/horny
	name = "Horny"
	description = "You woonna something lust..."
	initializer = "fuck"
	timeout = 3 MINUTES
	difficulty = MOOD_DIFFICULTY_EASY

/datum/mood/horny/affect()
	if(..())
		to_chat(holder, SPAN_ERP("You feel a little hot in your lower half..."))

/datum/mood/horny/timeout_cb()
	to_chat(holder, SPAN_INFO("You've calmed down and you don't want to fuck everyone in a row anymore!"))
	. = ..()
