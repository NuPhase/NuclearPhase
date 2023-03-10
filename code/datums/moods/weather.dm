/datum/mood/astraphobia
	name = "Astraphobia"
	description = "Astraphobia, also known as astrapophobia, brontophobia, keraunophobia, or tonitrophobia, is an abnormal fear of thunder and lightning or an unwarranted fear of scattered and/or isolated thunderstorms, a type of specific phobia."
	init_chance = 15
	eventnames = list("sunrise", "weather_worsen", "solar_storm")
	randomgive = TRUE
	difficulty = MOOD_DIFFICULTY_EASY

/datum/mood/astraphobia/by_event(list/args_)
	. = ..()
	var/message = ""
	var/strength = 0 //will be used later for effects
	switch(args_[1])
		if("sunrise")
			message = pick(list(
				"The deadly light is near, hide!",
				"It will kill you!",
				"There are no safe places! It will doom us all!"
			))
			strength = 100
		if("solar_storm")
			message = pick(list(
				"It's invisible and deadly...",
				"Are we really safe inside of the shelter?",
				"It's a good idea to seek shelter."
			))
			strength = 50
		if("weather_worsen")
			message = pick(list(
				"Everything's getting worse, you can feel it...",
				"The weather is getting worse every day..."
			))
			strength = 25
	to_chat(holder, SPAN_PHOBIA(message))
	return strength
