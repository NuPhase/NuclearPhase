/obj/item/info_container/phone/ordinary
	desc = "Looks like it belonged to someone..."
	var/message = ""

/obj/item/info_container/phone/ordinary/broken
	ruined = TRUE

/obj/item/info_container/phone/ordinary/show_information(mob/user)
	if(prob(15))
		ruin()
		return
	if(message)
		to_chat(user, SPAN_NOTICE(message))
		return
	message = pick(list(
		"You find nothing special, just pictures of a man with a name '[pick(first_names_male)]' and his dog.",
		"You can't figure out who this phone belonged to, looks like its owner tried to conceal their identity.",
		"Among pictures of family and occasional porn, you find some messages with government weather warnings. They don't open for some reason."
	))
	to_chat(user, SPAN_NOTICE(message))