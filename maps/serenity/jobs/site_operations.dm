/datum/job/site_operations
	department_types = list(/decl/department/site_operations)
	total_positions = 1
	spawn_positions = 1
	supervisors = "administration"
	selection_color = "#86263e"
	guestbanned = 1
	allowed_branches = list(
		/datum/mil_branch/civ
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
		)
	min_skill = list(
		SKILL_LITERACY    = SKILL_ADEPT
	)
	skill_points = 20

/datum/job/site_operations/faid
	title = "Facility AI Director"
	head_position = 1
	supervisors = "the Chief Operations Officer and Chief Security Officer"

/datum/job/site_operations/ca
	title = "Chief Architect"
	head_position = 1
	supervisors = "the Chief Operations Officer and Reactor Operations Director"

/datum/job/site_operations/ss
	title = "Safety Supervisor"
	head_position = 1
	supervisors = "the Chief Operations Officer"

/datum/job/site_operations/sme
	title = "Site Maintenance Engineer"
	total_positions = 10
	spawn_positions = 10
	supervisors = "the Chief Architect, Laboratory Operations Director and Reactor Maintenance Director"