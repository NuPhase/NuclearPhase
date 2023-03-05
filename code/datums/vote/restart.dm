/datum/vote/restart
	name = "give up"
	choices = list("Accept Your Fate","Continue Trying")
	priorities = list("First")
	weights = list(1)
	results_length = 1

/datum/vote/restart/can_run(mob/creator, automatic)
	if(!automatic && !config.allow_vote_restart && !is_admin(creator))
		return FALSE // Admins and autovotes bypass the config setting.
	return ..()

/datum/vote/restart/handle_default_votes()
	var/non_voters = ..()
	choices["Continue Trying"] += non_voters

/datum/vote/restart/report_result()
	if(..())
		return 1
	if(result[1] == "Accept Your Fate")
		SSvote.restart_world()