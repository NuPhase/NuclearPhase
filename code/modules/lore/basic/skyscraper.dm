/obj/item/info_container/phone/clerk
	desc = "Its case has a large 'WEHS' logo stamped on it."
	var/message = ""

/obj/item/info_container/phone/clerk/show_information(mob/user)
	if(prob(15))
		ruin()
		return
	if(message)
		to_chat(user, SPAN_NOTICE(message))
		return
	message = pick(list(
		"This looks like a phone of a professional photographer, although you can only find pictures of ongoing surgeries...",
		"It's a phone of an average joe '[pick(first_names_male)]', filled with nothing but ordinary stuff.",
		"This phone has quite a lot of useful data. Not for someone like you, though. Bureaucracy...",
		"A completely blank phone..."
	))
	to_chat(user, SPAN_NOTICE(message))

/obj/item/info_container/phone/clerk/high_level
	desc = "Its silver-shining case has a large 'WEHS' logo stamped on it. Looks like it belonged to someone important."

/obj/item/info_container/phone/clerk/high_level/show_information(mob/user)
	if(prob(15))
		ruin()
		return
	if(message)
		to_chat(user, SPAN_NOTICE(message))
		return
	message = pick(list(
		"You're lucky its password was '1234'. Although it seems that 'garbage in - garbage out' applies even to such stuff. Various flirt texts, drunken party pictures, and nothing else...",
		"Among a heap of unimportant stuff, you find several mentions of underground laboratories...",
		"It seems to be the phone of a worker in 'WEHS' secret underground labs. You can even find a blurred image of an elevator halfway descended to the first floor. There seems to be something under it..."
	))
	to_chat(user, SPAN_NOTICE(message))