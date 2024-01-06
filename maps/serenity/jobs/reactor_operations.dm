/datum/job/reactor_operations
	department_types = list(/decl/department/reactor_operations)
	total_positions = 1
	spawn_positions = 1
	supervisors = "administration"
	selection_color = "#adaf14"
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

/datum/job/reactor_operations/rod
	title = "Reactor Operations Director"
	head_position = 1
	supervisors = "the CEO"

/datum/job/reactor_operations/road
	title = "Reactor Operations Assistant Director"
	head_position = 1
	supervisors = "the Reactor Operations Director"

/datum/job/reactor_operations/rce
	title = "Reactor Chief Engineer"
	head_position = 1
	supervisors = "the Reactor Operations Director"

/datum/job/reactor_operations/rmd
	title = "Reactor Maintenance Director"
	head_position = 1
	supervisors = "the Reactor Operations Director"

/datum/job/reactor_operations/ros
	title = "Reactor Operations Specialist"
	total_positions = 10
	spawn_positions = 10
	supervisors = "the Reactor Chief Engineer"