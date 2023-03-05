/datum/mood/horny
	name = "Horny"
	description = "You woonna something lust..."
	initializer = "fuck"
	init_chance = 70
	timeout = 3 MINUTES
	difficulty = MOOD_DIFFICULTY_EASY

/datum/mood/affect()
	if(..())
		to_chat(holder, SPAN_ERP("You feel little hot in groin..."))

/datum/mood/timeout_cb()
	to_chat(holder, SPAN_INFO("You've calmed down and you don't want to fuck everyone in a row anymore!"))
	. = ..()
