/datum/job/assistant
	title = "Workman"
	total_positions = -1
	spawn_positions = -1
	supervisors = "capitalistic regime"
	economic_power = 1
	access = list()
	minimal_access = list()
	alt_titles = list("Technical Assistant","Medical Intern","Research Assistant")
	outfit_type = /decl/hierarchy/outfit/job/generic/assistant
	department_types = list(/decl/department/civilian)
	skill_points = 24
	only_for_whitelisted = FALSE

/datum/job/assistant/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()

/datum/job/chaplain
	title = "Chaplain"
	department_types = list(/decl/department/civilian)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the human resources manager"
	access = list(
		access_morgue,
		access_chapel_office,
		access_crematorium,
		access_maint_tunnels
	)
	minimal_access = list(
		access_morgue,
		access_chapel_office,
		access_crematorium
	)
	outfit_type = /decl/hierarchy/outfit/job/chaplain
	is_holy = TRUE
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_FINANCE  = SKILL_BASIC
	)
	skill_points = 20
	software_on_spawn = list(/datum/computer_file/program/reports)

//Food
/datum/job/bartender
	title = "Bartender"
	department_types = list(/decl/department/service)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the human resources manager"
	access = list(
		access_hydroponics,
		access_bar,
		access_kitchen
	)
	minimal_access = list(access_bar)
	alt_titles = list("Barista")
	outfit_type = /decl/hierarchy/outfit/job/service/bartender
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_COOKING   = SKILL_BASIC,
	    SKILL_BOTANY    = SKILL_BASIC,
	    SKILL_CHEMISTRY = SKILL_BASIC
	)
	skill_points = 24

/datum/job/chef
	title = "Chef"
	department_types = list(/decl/department/service)
	total_positions = 2
	spawn_positions = 2
	supervisors = "the human resources manager"
	access = list(
		access_hydroponics,
		access_bar,
		access_kitchen
	)
	minimal_access = list(access_kitchen)
	alt_titles = list("Cook")
	outfit_type = /decl/hierarchy/outfit/job/service/chef
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_COOKING   = SKILL_ADEPT,
	    SKILL_BOTANY    = SKILL_BASIC,
	    SKILL_CHEMISTRY = SKILL_BASIC
	)
	skill_points = 24

/datum/job/hydro
	title = "Gardener"
	department_types = list(/decl/department/service)
	total_positions = 2
	spawn_positions = 1
	supervisors = "the human resources manager"
	access = list(
		access_hydroponics,
		access_bar,
		access_kitchen
	)
	minimal_access = list(access_hydroponics)
	alt_titles = list("Hydroponicist")
	outfit_type = /decl/hierarchy/outfit/job/service/gardener
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_BOTANY    = SKILL_BASIC,
	    SKILL_CHEMISTRY = SKILL_BASIC
	)
	event_categories = list(ASSIGNMENT_GARDENER)
	skill_points = 20

//Cargo
/datum/job/qm
	title = "Supply Operations Manager"
	department_types = list(/decl/department/supply)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the human resources manager"
	economic_power = 5
	access = list(
		access_maint_tunnels,
		access_mailsorting,
		access_cargo,
		access_cargo_bot,
		access_qm,
		access_mining,
		access_mining_station
	)
	minimal_access = list(
		access_maint_tunnels,
		access_mailsorting,
		access_cargo,
		access_cargo_bot,
		access_qm,
		access_mining,
		access_mining_station
	)
	minimal_player_age = 3
	ideal_character_age = 40
	outfit_type = /decl/hierarchy/outfit/job/cargo/qm
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
	    SKILL_FINANCE  = SKILL_BASIC,
	    SKILL_STRENGTH  = SKILL_BASIC,
		SKILL_FITNESS = SKILL_BASIC,
	    SKILL_EVA      = SKILL_BASIC,
	    SKILL_PILOT    = SKILL_BASIC
	)
	max_skill = list(
		SKILL_PILOT    = SKILL_MAX
	)
	skill_points = 18
	software_on_spawn = list(
		/datum/computer_file/program/supply,
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/reports
	)
	skill_points = 26

/datum/job/cargo_tech
	title = "Supply Technician"
	department_types = list(/decl/department/supply)
	total_positions = 2
	spawn_positions = 2
	supervisors = "the quartermaster and the human resources manager"
	access = list(
		access_maint_tunnels,
		access_mailsorting,
		access_cargo,
		access_cargo_bot,
		access_qm,
		access_mining,
		access_mining_station
	)
	minimal_access = list(
		access_maint_tunnels,
		access_cargo,
		access_cargo_bot,
		access_mailsorting
	)
	outfit_type = /decl/hierarchy/outfit/job/cargo/cargo_tech
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_FINANCE  = SKILL_BASIC,
		SKILL_FITNESS  = SKILL_BASIC
	)
	max_skill = list(
		SKILL_PILOT    = SKILL_MAX
	)
	software_on_spawn = list(
		/datum/computer_file/program/supply,
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/reports
	)
	skill_points = 24

/datum/job/mining
	title = "Mining Operations Specialist"
	department_types = list(/decl/department/supply)
	total_positions = 3
	spawn_positions = 3
	supervisors = "the supply operations and human resources managers"
	economic_power = 5
	access = list(
		access_maint_tunnels,
		access_mailsorting,
		access_cargo,
		access_cargo_bot,
		access_qm,
		access_mining,
		access_mining_station
	)
	minimal_access = list(
		access_mining,
		access_mining_station,
		access_mailsorting
	)
	alt_titles = list(
		"Drill Technician",
		"Prospector"
	)
	outfit_type = /decl/hierarchy/outfit/job/cargo/mining
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_STRENGTH  = SKILL_ADEPT,
	    SKILL_EVA      = SKILL_BASIC
	)
	max_skill = list(
		SKILL_PILOT    = SKILL_MAX
	)
	skill_points = 24
	only_for_whitelisted = FALSE

/datum/job/janitor
	title = "Sanitation Specialist"
	department_types = list(/decl/department/service)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the human resources manager"
	access = list(
		access_janitor,
		access_maint_tunnels,
		access_engine,
		access_research,
		access_sec_doors,
		access_medical
	)
	minimal_access = list(
		access_janitor,
		access_maint_tunnels,
		access_engine,
		access_research,
		access_sec_doors,
		access_medical
	)
	alt_titles = list(
		"Custodian",
		"Janitor",
		"Sanitation Technician"
	)
	outfit_type = /decl/hierarchy/outfit/job/service/janitor
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_FITNESS  = SKILL_BASIC
	)
	event_categories = list(ASSIGNMENT_JANITOR)
	skill_points = 20
	only_for_whitelisted = FALSE

/obj/item/card/id/cargo
	name = "identification card"
	desc = "A card issued to cargo staff."
	detail_color = COLOR_BROWN

/obj/item/card/id/cargo/head
	name = "identification card"
	desc = "A card which represents service and planning."
	extra_details = list("goldstripe")

/obj/item/card/id/civilian/internal_affairs_agent
	detail_color = COLOR_NAVY_BLUE
