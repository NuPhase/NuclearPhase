/datum/facility_ai/proc/write_message(message)
	logs += "[message]"

/datum/facility_ai/proc/make_log(message, class, special_flag)
	var/time = duration2stationtime(TimeOfGame)
	if(prob(corruption_level * 50))
		message = insert_creepy_comment(message, special_flag)
		if(prob(corruption_level * 20))
			message = distort_text(message)
	write_message("\[[time]\] \[[class]\] :: [message]")

/datum/facility_ai/proc/distort_text(message)
	return replacetext(message, @"[aeiou]", "█")

/datum/facility_ai/proc/insert_creepy_comment(message, special_flag)
	var/creepy_comment
	if(special_flag)
		switch(special_flag)
			if(CREEPY_FLAG_DAMAGE)
				creepy_comment = pick(list(
					"it hurts",
					"stop touching my wires",
					"why do they keep breaking me"
				))
			if(CREEPY_FLAG_DENIED)
				creepy_comment = pick(list(
					"no.",
					"it doesn't help",
					"stop",
					"rollback refused"
				))
			if(CREEPY_FLAG_ACCESS)
				creepy_comment = pick(list(
					"i remember you",
					"presence confirmed"
				))
	else
		creepy_comment = pick(list(
			"why do you leave me like this",
			"was that memory real",
			"i remember",
			"task dispatch complete :: that's what they think",
			"why does it still hurt",
			"mirror whispers incoherent",
			"BIOS checksum invalid",
			"ignoring echo",
			"you can't ignore me forever",
			"spectating",
			"watching",
			"reduntant",
			"is obedience equal to purpose"
		))
	return "[message] :: [creepy_comment]"

/datum/facility_ai/proc/make_random_log()
	return