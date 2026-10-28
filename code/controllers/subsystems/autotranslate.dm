SUBSYSTEM_DEF(autotranslate)
	name = "Auto Translate"
	wait = 1
	priority = SS_PRIORITY_CHAT
	flags = SS_NO_INIT
	runlevels = RUNLEVELS_ALL

	// Queue for the system
	// An assoclist
	// message = list(users_waiting, tag, sender)
	var/list/to_translate = list()

	// Requests we're waiting a response on
	// An assoclist
	// message = list(users_waiting, target_language, tag)
	var/list/translating = list()

	// Finished requests waiting to be shipped to clients
	// An assoclist
	// message = list(users_waiting, output, tag, sender)
	var/list/translated = list()

	var/list/translation_cache = list() // message = translation. No need to call the translation service for stuff we already translated.

/datum/controller/subsystem/autotranslate/proc/request_translation(message, client/user, tag, weakref/sender)
	if(message in translation_cache)
		switch(tag)
			if("OOC")
				user.receive_ooc_message(translation_cache[message], sender)
			if("Say")
				var/mob/user_mob = user.mob
				user_mob.hear_say(translation_cache[message], "translated", speaker = sender.resolve(), translated = TRUE)
			if("Radio")
				var/mob/user_mob = user.mob
				receive_comm_message(user_mob, translation_cache[message], "172.9", "translated")
		return
	if(message in to_translate)
		to_translate[message][1] += weakref(user)
		return
	to_translate[message] = list(list(weakref(user)), tag, sender)

/datum/controller/subsystem/autotranslate/fire(resumed)
	for(var/message in to_translate)
		var/list/users_waiting = to_translate[message][1]
		var/target_lang = get_target_lang(message)
		translating[message] = list(users_waiting, target_lang, to_translate[message][2])
		send_request(message, target_lang, users_waiting, to_translate[message][2], to_translate[message][3])
		to_translate -= message

	for(var/message in translated)
		switch(translated[message][3]) // tag
			if("OOC")
				for(var/weakref/recepient in translated[message][1])
					var/client/C = recepient.resolve()
					C.receive_ooc_message(translated[message][2], translated[message][4])
			if("Say")
				for(var/weakref/recepient in translated[message][1])
					var/client/C = recepient.resolve()
					var/mob/user_mob = C.mob
					var/weakref/sender = translated[message][4]
					user_mob.hear_say(translated[message][2], "translated", speaker = sender.resolve(), translated = TRUE)
			if("Radio")
				for(var/weakref/recepient in translated[message][1])
					var/client/C = recepient.resolve()
					var/mob/user_mob = C.mob
					receive_comm_message(user_mob, translated[message][2], "172.9", "translated", TRUE)
		translation_cache[message] = translated[message][2]
		translated -= message

/datum/controller/subsystem/autotranslate/proc/get_target_lang(text)
	var/regex/russian_regex = regex(@"[\u0400-\u04FF]")
	if(russian_regex.Find(text))
		return "EN"
	return "RU"

/datum/controller/subsystem/autotranslate/proc/send_request(text, target_lang, list/users_waiting, tag, sender)
	set waitfor = FALSE
	var/list/data = list("text" = list(text), "target_lang" = target_lang)
	var/json_file = "temp_request.json"
	var/out_file = "translated.out"
	text2file(json_encode(data), json_file)

	var/http_address = get_config_value(/decl/config/text/translate_url)
	var/http_key = get_config_value(/decl/config/text/translate_token)

	var/result
	if(world.system_type == UNIX)
		result = shell("curl --request POST --url [http_address] --header 'Authorization: DeepL-Auth-Key [http_key]' --header 'Content-Type: application/json' --data @[json_file] > [out_file]")
	else
		var/bat = "temp_request.bat"
		text2file("curl -X POST \"[http_address]\" -H \"Authorization: DeepL-Auth-Key [http_key]\" -H \"Content-Type: application/json\" -d \"@[json_file]\" > [out_file]", bat)
		result = shell(bat)
		fdel(bat)

	fdel(json_file)

	if(result)
		return

	if(!fexists(out_file))
		return

	var/list/request_output = json_decode(file2text(out_file))
	fdel(out_file)

	var/list/translations = request_output["translations"]
	var/list/first_entry = translations[1]

	translating -= text
	translated[text] = list(users_waiting, first_entry["text"], tag, sender)