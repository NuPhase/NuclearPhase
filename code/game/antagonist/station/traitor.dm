// Inherits most of its vars from the base datum.
/decl/special_role/traitor
	name = "Traitor"
	name_plural = "Traitors"
	antaghud_indicator = "hud_traitor"
	blacklisted_jobs = list(/datum/job/submap)
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	skill_setter = /datum/antag_skill_setter/station
	blocked_job_event_categories = list(ASSIGNMENT_COMPUTER)

/decl/special_role/traitor/create_objectives(var/datum/mind/traitor)
	var/datum/objective/escape/escape_objective = new
	escape_objective.owner = traitor
	traitor.objectives += escape_objective
	if(prob(50))
		var/datum/objective/allow_escape/allow_escape_objective = new
		allow_escape_objective.owner = traitor
		traitor.objectives += allow_escape_objective
	return

/decl/special_role/traitor/equip(var/mob/living/carbon/human/player)

	. = ..()

	to_chat(player, SPAN_ERPBOLD("You're fed up of this place. Do what's necessary to escape, even if that means leaving everyone behind."))
	to_chat(player, SPAN_ERP("There are two ships orbiting the planet, they caused this catastrophe. If you manage to get on one, perhaps you'll find out how to escape this place. You'll surely do..."))

	var/list/dudes = list()
	for(var/mob/living/carbon/human/man in global.player_list)
		if(man.client)
			var/decl/cultural_info/culture = man.get_cultural_value(TAG_FACTION)
			if(culture && prob(culture.subversive_potential))
				dudes += man
		dudes -= player

	if(LAZYLEN(dudes))
		var/mob/living/carbon/human/M = pick(dudes)
		to_chat(player, "It's possible that [M.real_name] might be willing to help your cause. If you need assistance, consider contacting them.")
		player.StoreMemory("<b>Potential Collaborator</b>: [M.real_name]", /decl/memory_options/system)
		to_chat(M, "<span class='warning'>The subversive potential of your faction has been noticed, and you may be contacted for assistance soon...</span>")