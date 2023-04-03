/decl/webhook/roundend
	id = WEBHOOK_ROUNDEND

// Data expects three numerical fields: "survivors", "escaped", "ghosts", "clients"
/decl/webhook/roundend/get_message(var/list/data)
	. = ..()
	var/desc = "Раунд с режимом **[SSticker.mode ? SSticker.mode.name : "НЕ ОПРЕДЕЛЁН"]** ([game_id]) закончился.\n\n"
	if(data)
		desc += "Концовка: Вымирание."
		if(data["survivors"] > 0)
			desc += "Выжившие: **[data["survivors"]](из них в убежище: [data["shelter_survivors"]])**\n"
			desc += "Сбежало с планеты: **[data["escaped"]]**\n"
		else
			desc += "**Никто** не выжил.\n\n"
		desc += "Умершие: **[data["ghosts"]]**\n"
		desc += "Игроки: **[data["clients"]]**\n"
		desc += "Длительность раунда: **[roundduration2text()]**"

	.["embeds"] = list(list(
		"title" = global.end_credits_title,
		"description" = desc,
		"color" = COLOR_WEBHOOK_DEFAULT
	))
