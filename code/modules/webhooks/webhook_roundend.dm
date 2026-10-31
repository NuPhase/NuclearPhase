/decl/webhook/roundend
	id = WEBHOOK_ROUNDEND

// Data expects three numerical fields: "survivors", "shelter_survivors", "escaped", "ghosts", "clients"
/decl/webhook/roundend/get_message(var/list/data)
	. = ..()
	var/desc = "Round with mode **[SSticker.mode ? SSticker.mode.name : "UNDEFINED"]** ([game_id]) ended.\n\n"
	if(data)
		desc += "Ending: **Extinction**.\n"
		if(data["survivors"] > 0)
			desc += "Survivors: **[data["survivors"]](in the shelter: [data["shelter_survivors"]])**\n"
			desc += "Escaped the planet: **[data["escaped"]]**\n"
		else
			desc += "Nobody survived.\n\n"
		desc += "Dead: **[data["ghosts"]]**\n"
		desc += "Players: **[data["clients"]]**\n"
		desc += "Round duration: **[roundduration2text()]**"

	.["embeds"] = list(list(
		"title" = "STATUS REPORT",
		"description" = desc,
		"color" = COLOR_WEBHOOK_DEFAULT
	))
