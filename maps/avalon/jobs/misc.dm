/datum/job/explorer
	title = "Explorer"
	total_positions = -1
	spawn_positions = -1
	supervisors = "yourself"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/explorer
	is_ghost_role = TRUE

/datum/job/explorer/do_spawn_special(mob/living/character, mob/new_player/new_player_mob, latejoin)
	. = ..()
	to_chat(character, SPAN_ERPBOLD(description))

/datum/job/hobo
	title = "Hobo"
	total_positions = -1
	spawn_positions = -1
	supervisors = "yourself"
	economic_power = 0.1
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/explorer
	forced_spawnpoint = /decl/spawnpoint/service

/datum/job/hobo/do_spawn_special(mob/living/character, mob/new_player/new_player_mob, latejoin)
	. = ..()
	to_chat(character, SPAN_ERPBOLD(description))