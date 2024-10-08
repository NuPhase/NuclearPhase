/datum/vote/transfer
	name = "transfer"
	question = "Do you want to escape?"

/datum/vote/transfer/can_run(mob/creator, automatic)
	if(!(. = ..()))
		return
	if(!SSevac.evacuation_controller || !SSevac.evacuation_controller.should_call_autotransfer_vote())
		return FALSE
	if(!automatic && !get_config_value(/decl/config/toggle/vote_restart) && !is_admin(creator))
		return FALSE // Admins and autovotes bypass the config setting.
	if(check_rights(R_INVESTIGATE, 0, creator))
		return //Mods bypass further checks.
	var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)
	if (!automatic && security_state.current_security_level_is_same_or_higher_than(security_state.high_security_level))
		return FALSE
	if(GAME_STATE <= RUNLEVEL_SETUP)
		return FALSE

/datum/vote/transfer/setup_vote(mob/creator, automatic)
	choices = list("Initiate Crew Transfer", "Extend the Round ([get_config_value(/decl/config/num/vote_autotransfer_interval) / 600] minutes)")
	if (get_config_value(/decl/config/toggle/allow_extra_antags) && SSvote.is_addantag_allowed(creator, automatic))
		choices += "Add Antagonist"
	..()

/datum/vote/transfer/handle_default_votes()
	if(get_config_value(/decl/config/num/vote_no_default))
		return
	var/factor = 0.5
	switch(world.time / (1 MINUTE))
		if(0 to 60)
			factor = 0.5
		if(61 to 120)
			factor = 0.8
		if(121 to 240)
			factor = 1
		if(241 to 300)
			factor = 1.2
		else
			factor = 1.4
	choices["Escape"] = round(choices["Escape"] * factor)

/datum/vote/transfer/report_result()
	if(..())
		return 1
	if(result[1] == "Escape")
		to_world(SPAN_ERPBOLD("There is no escape from this hell."))

/datum/vote/transfer/mob_not_participating(mob/user)
	if((. = ..()))
		return
	if(get_config_value(/decl/config/num/vote_no_dead_crew_transfer))
		return !isliving(user) || ismouse(user)

/datum/vote/transfer/check_toggle()
	return get_config_value(/decl/config/toggle/vote_restart) ? "Allowed" : "Disallowed"

/datum/vote/transfer/toggle(mob/user)
	if(is_admin(user))
		toggle_config_value(/decl/config/toggle/vote_restart)