/datum/objective/hijack
	explanation_text = "Hijack a shuttle."

/datum/objective/escape
	explanation_text = "Escape this planet by any means necessary. Don't let anyone know you want to, or they'll take your chance away from you."

/datum/objective/allow_escape/New()
	var/escaping = rand(1, 3)
	if(escaping == 1)
		explanation_text = "Find someone worthy of escaping with you. Make sure they don't tell anyone."
	else
		explanation_text = "Find [escaping] people worthy of escaping with you. Make sure they don't tell anyone."
	..()

/datum/objective/survive
	explanation_text = "Stay alive until the end."

/datum/objective/ninja_highlander
   explanation_text = "You aspire to be a Grand Master of the Spider Clan. Kill all of your fellow acolytes."
