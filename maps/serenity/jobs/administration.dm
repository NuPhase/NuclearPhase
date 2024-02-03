/datum/job/administration
	head_position = 1
	department_types = list(/decl/department/administration)
	total_positions = 0
	spawn_positions = 0
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#222255"
	req_admin_notify = 1
	minimal_player_age = 14
	economic_power = 20
	ideal_character_age = 70
	guestbanned = 1
	must_fill = 1
	not_random_selectable = 1
	allowed_branches = list(
		/datum/mil_branch/civ
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
		)
	min_skill = list(
		SKILL_LITERACY    = SKILL_ADEPT
	)
	skill_points = 30

/datum/job/administration/ceo
	title = "Chief Executive Officer"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ceo

/datum/job/administration/coo
	title = "Chief Operations Officer"
	supervisors = "the CEO"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/coo

/datum/job/administration/cso
	title = "Chief Security Officer"
	supervisors = "the CEO"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/cso

/datum/job/administration/sdd
	title = "Site Deputy Director"
	supervisors = "the CEO"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/sdd