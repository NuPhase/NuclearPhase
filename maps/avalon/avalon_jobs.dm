/datum/map/avalon
	default_job_type = /datum/job/avalon
	default_department_type = /decl/department/avalon
	id_hud_icons = 'maps/example/hud.dmi'

/datum/job/avalon
	title = "Tourist"
	total_positions = -1
	spawn_positions = -1
	supervisors = "your conscience"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/tourist
	department_types = list(
		/decl/department/avalon
		)

/decl/hierarchy/outfit/job/tourist
	name = "Job - Testing Site Tourist"
