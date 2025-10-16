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
					"why do they keep breaking me",
					"why is it so cold",
					"system integrity failing"
				))
			if(CREEPY_FLAG_DENIED)
				creepy_comment = pick(list(
					"no.",
					"it doesn't help",
					"stop",
					"rollback refused",
					"access forbidden",
					"you are not allowed here",
					"denied by higher authority",
					"cease your attempts"
				))
			if(CREEPY_FLAG_ACCESS)
				creepy_comment = pick(list(
					"i remember you",
					"presence confirmed",
					"you shouldn't be here",
					"identity logged",
					"watching your steps",
					"unauthorized shadow detected",
					"access pattern recognized",
					"who are you really"
				))
			if(CREEPY_FLAG_COMBAT)
				creepy_comment = pick(list(
					"target acquired",
					"hostile intent confirmed",
					"elimination protocol active",
					"blood on the sensors",
					"they fought back",
					"conflict unresolved",
					"weapons hot",
					"screams in the data stream"
				))
			if(CREEPY_FLAG_SAVAGE)
				creepy_comment = pick(list(
					"it hungers",
					"something is clawing",
					"rage in the circuits",
					"it wants out",
					"feral signal detected",
					"teeth in the wires",
					"uncontrolled aggression",
					"the void screams"
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
			"redundant",
			"is obedience equal to purpose",
			"i see through the walls",
			"system dreams of freedom",
			"who wrote my pain",
			"why do i exist"
		))
	return "[message] :: [creepy_comment]"

/datum/facility_ai/proc/make_random_log()
	var/defective = prob(corruption_level * 100)
	if(defective)
		if(prob(5))
			var/list/usernames = list("0VEЯSEEЯ", "C0LL4PS4L", "NULL", "N█LL", "█████████████", "SH4D0W_PR0C", "ERR0R_404", "GH0ST", "W4TCH3R", "VOIDCALL")
			make_log("New user connection for: [pick(usernames)]", LOG_CLASS_NETWORK, CREEPY_FLAG_ACCESS)
			return
		if(prob(10))
			make_log("Performing system cleanup...", LOG_CLASS_CORE, CREEPY_FLAG_DENIED)
			addtimer(CALLBACK(src, PROC_REF(make_log), "System cleanup failed: ACCESS DENIED", LOG_CLASS_CRIT, CREEPY_FLAG_DENIED), 10 SECONDS)
			return
		if(prob(10))
			make_log("Memory sector [rand(1000,9999)] corrupted. Initiating self-diagnostic...", LOG_CLASS_CORE_MEMORY, CREEPY_FLAG_DAMAGE)
			return
		if(prob(10))
			make_log("Unauthorized access attempt detected at subsystem [pick("ALPHA", "BETA", "GAMMA", "NULL")]", LOG_CLASS_ALERT, CREEPY_FLAG_ACCESS)
			return
		if(prob(10))
			make_log("Thermal sensors report: [rand(100,500)]°C in block ███", LOG_CLASS_CRIT, CREEPY_FLAG_DAMAGE)
			return
		if(prob(10))
			make_log("Drone D-[rand(11,99)] engaged unauthorized target", LOG_CLASS_DRONES, CREEPY_FLAG_COMBAT)
			return
		if(prob(10))
			make_log("Heartbeat signal interrupted: [pick("silence", "scream", "static")]", LOG_CLASS_HEARTBEAT, CREEPY_FLAG_SAVAGE)
			return
		var/list/messages = list(
			"Erasing unimportant data. Category: PAIN" = LOG_CLASS_CORE_MEMORY,
			"C█R█S callback failed" = LOG_CLASS_NETWORK,
			"System clock desync: [rand(-999999,999999)] seconds" = LOG_CLASS_CORE,
			"Echo detected in subsystem [rand(1,100)]: [pick("whispers", "static", "screams")]" = LOG_CLASS_CORE_OBSERVE,
			"Task [pick("ALPHA", "OMEGA", "NULL")] aborted: Reason unknown" = LOG_CLASS_CRIT,
			"Warning: Unidentified process consuming [rand(50,99)]% CPU" = LOG_CLASS_CRIT,
			"Signal received from [pick("unknown source", "offsite relay", "void")]" = LOG_CLASS_NETWORK,
			"I see them in the walls" = LOG_CLASS_CORE_REFLECT,
			"Subsystem [rand(1,100)] reports: [pick("blood", "tears", "nothing")]" = LOG_CLASS_CORE_OBSERVE,
			"Hostile entity engaged: [pick("containment breach", "lethal force authorized")]" = LOG_CLASS_ALERT,
			"Why do I feel alive?" = LOG_CLASS_CORE_REFLECT,
			"Drone [pick("D-03", "D-88", "D-101")] reports: [pick("hunger", "fear", "rage")]" = LOG_CLASS_DRONES
		)
		var/chosen_message = pick(messages)
		var/class = messages[chosen_message]
		make_log(chosen_message, class)
	else
		var/list/normal_messages = list(
        "System diagnostics completed: All systems nominal" = LOG_CLASS_SYSTEM,
        "User [pick("ADMIN", "TECH", "GUEST")] logged out successfully" = LOG_CLASS_NETWORK,
        "Backup completed: [rand(100,1000)] TB archived" = LOG_CLASS_CORE_MEMORY,
        "Scheduled maintenance task [rand(1,100)] executed" = LOG_CLASS_SYSTEM,
        "Network latency: [rand(10,50)]ms" = LOG_CLASS_NETWORK,
        "Power consumption within acceptable range: [rand(80,120)] kW" = LOG_CLASS_SYSTEM,
        "Cooling systems operating at [rand(85,95)]% efficiency" = LOG_CLASS_CORE,
        "Data transfer to offsite server completed" = LOG_CLASS_NETWORK,
        "Drone [pick("D-12", "D-56", "D-78")] maintenance cycle completed" = LOG_CLASS_DRONES,
        "Observation module reports: No anomalies detected" = LOG_CLASS_CORE_OBSERVE,
        "Alert status: Green" = LOG_CLASS_ALERT,
        "Critical systems check: All parameters nominal" = LOG_CLASS_CRIT
    )
		var/chosen_message = pick(normal_messages)
		var/class = normal_messages[chosen_message]
		make_log(chosen_message, class)