/datum/mood/psychopathy
	name = "Psychopathy"
	description = "Psychopathy is a neuropsychiatric disorder marked by deficient emotional responses, lack of empathy, and poor behavioral controls, commonly resulting in persistent antisocial deviance and criminal behavior."
	init_chance = 5
	eventnames = list("psycho")
	randomgive = TRUE
	difficulty = MOOD_DIFFICULTY_HARD

/datum/mood/psychopathy/affect()
	if(!..())
		return
	var/message = pick(list(
		"It's disgusting that everyone shows their useless emotions. Why should I care?",
		"I haven't had my portion of attention lately.",
		"No one cares enough about me.",
		"I don't care about anyone's feelings. Mine are the most important.",
		"Everyone should fuck off.",
		"Why does no one show attention to me?",
		"I am the most important person here!"
	))
	to_chat(holder, SPAN_NOTICE(message))

/datum/mood/psychopathy/by_event(args_)
	if(!..())
		return

	var/message = pick(list(
		"Ah, can they just shut up?",
		"I don't care, just shut up!",
		"Why is [args_["source"]] so damn loud?",
		"Control your fucking emotions, [src]!",
		"Stop being so whiney!"
	))

	to_chat(holder, SPAN_NOTICE(message))
