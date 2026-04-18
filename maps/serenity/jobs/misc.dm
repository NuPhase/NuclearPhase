/datum/job/explorer
	title = "Explorer"
	total_positions = -1
	spawn_positions = -1
	supervisors = "yourself"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/explorer
	allowed_branches = list(
		/datum/mil_branch/civ
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
		)
	is_ghost_role = TRUE

/datum/job/explorer/do_spawn_special(mob/living/character, mob/new_player/new_player_mob, latejoin)
	. = ..()
	to_chat(character, SPAN_ERP("You wake up in a strange place. A lush forest, a quiet remnant of one's memories devoid of life. It seems safe and peaceful, yet you can't let off the feeling that you're not alone amidst these woods..."))

/datum/job/hobo
	title = "Hobo"
	total_positions = -1
	spawn_positions = -1
	supervisors = "yourself"
	economic_power = 0.1
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/explorer
	allowed_branches = list(
		/datum/mil_branch/civ
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
		)
	forced_spawnpoint = /decl/spawnpoint/service

/datum/job/hobo/do_spawn_special(mob/living/character, mob/new_player/new_player_mob, latejoin)
	. = ..()
	to_chat(character, SPAN_ERPBOLD(description))

/datum/job/officeman
	title = "Office Clerk"
	description = "You are a high-class worker at 'WEHS' in its largest skyscraper office on a break. Your second shift will begin soon, it's time to regain strength to hold the reigns of this partly utopian world."
	total_positions = -1
	spawn_positions = -1
	supervisors = "your supervisors"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/internal_affairs_agent
	allowed_branches = list(
		/datum/mil_branch/civ
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
		)
	is_ghost_role = TRUE

/datum/job/officeman/do_spawn_special(mob/living/character, mob/new_player/new_player_mob, latejoin)
	. = ..()
	to_chat(character, SPAN_ERPBOLD(description))