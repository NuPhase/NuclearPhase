/datum/job/laboratories
	department_types = list(/decl/department/laboratories)
	total_positions = 1
	spawn_positions = 1
	supervisors = "administration"
	selection_color = "#1a718b"
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

/datum/job/laboratories/lod
	title = "Laboratory Operations Director"
	supervisors = "the CEO"

/datum/job/laboratories/load
	title = "Laboratory Operations Assistant Director"
	supervisors = "the Laboratory Operations Director"

/datum/job/laboratories/pps
	title = "Particle Physics Specialist"
	supervisors = "the Laboratory Operations Director"
	total_positions = 3
	spawn_positions = 3

/datum/job/laboratories/ggs
	title = "General Genetics Specialist"
	supervisors = "the Laboratory Operations Director"
	total_positions = 2
	spawn_positions = 2

/datum/job/laboratories/los
	title = "Laboratory Operations Specialist"
	supervisors = "the Laboratory Operations Director"
	total_positions = 5
	spawn_positions = 5

/datum/job/laboratories/loa
	title = "Laboratory Operations Assistant"
	supervisors = "the Laboratory Operations Director"
	total_positions = 3
	spawn_positions = 3