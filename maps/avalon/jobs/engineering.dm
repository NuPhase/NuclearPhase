/datum/job/chief_engineer
	title = "Chief Engineer"
	head_position = 1
	department_types = list(
		/decl/department/engineering,
		/decl/department/command
	)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#7f6e2c"
	req_admin_notify = 1
	economic_power = 10
	ideal_character_age = 50
	guestbanned = 1
	must_fill = 1
	not_random_selectable = 1
	access = list(
		access_engine,
		access_engine_equip,
		access_tech_storage,
		access_maint_tunnels,
		access_heads,
		access_teleporter,
		access_external_airlocks,
		access_atmospherics,
		access_emergency_storage,
		access_eva,
		access_bridge,
		access_construction,
		access_sec_doors,
		access_ce,
		access_RC_announce,
		access_keycard_auth,
		access_tcomsat,
		access_ai_upload
	)
	minimal_access = list(
		access_engine,
		access_engine_equip,
		access_tech_storage,
		access_maint_tunnels,
		access_heads,
		access_teleporter,
		access_external_airlocks,
		access_atmospherics,
		access_emergency_storage,
		access_eva,
		access_bridge,
		access_construction,
		access_sec_doors,
		access_ce,
		access_RC_announce,
		access_keycard_auth,
		access_tcomsat,
		access_ai_upload
	)
	minimal_player_age = 14
	outfit_type = /decl/hierarchy/outfit/job/engineering/chief_engineer
	allowed_branches = list(
		/datum/mil_branch/civ
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
		)
	min_skill = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_COMPUTER     = SKILL_ADEPT,
		SKILL_EVA          = SKILL_ADEPT,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_ELECTRICAL   = SKILL_ADEPT,
		SKILL_ATMOS        = SKILL_ADEPT,
		SKILL_ENGINES      = SKILL_EXPERT
	)

	max_skill = list(
		SKILL_CONSTRUCTION = SKILL_MAX,
	    SKILL_ELECTRICAL   = SKILL_MAX,
	    SKILL_ATMOS        = SKILL_MAX,
	    SKILL_ENGINES      = SKILL_MAX
	)
	skill_points = 30
	software_on_spawn = list(
		/datum/computer_file/program/comm,
		/datum/computer_file/program/network_monitor,
		/datum/computer_file/program/power_monitor,
		/datum/computer_file/program/supermatter_monitor,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmos_control,
		/datum/computer_file/program/rcon_console,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/shields_monitor,
		/datum/computer_file/program/reports
	)
	event_categories = list(ASSIGNMENT_ENGINEER)

/datum/job/engineer
	title = "Engineer"
	department_types = list(/decl/department/engineering)

	total_positions = 8
	spawn_positions = 7
	supervisors = "the chief engineer"
	selection_color = "#5b4d20"
	economic_power = 5
	minimal_player_age = 7
	access = list(
		access_eva,
		access_engine,
		access_engine_equip,
		access_tech_storage,
		access_maint_tunnels,
		access_external_airlocks,
		access_construction,
		access_atmospherics,
		access_emergency_storage
	)
	minimal_access = list(
		access_eva,
		access_engine,
		access_engine_equip,
		access_tech_storage,
		access_maint_tunnels,
		access_external_airlocks,
		access_construction,
		access_atmospherics,
		access_emergency_storage
	)
	alt_titles = list(
		"Maintenance Technician",
		"Engine Technician",
		"Electrician",
		"Atmospheric Technician" = /decl/hierarchy/outfit/job/engineering/atmos
	)
	outfit_type = /decl/hierarchy/outfit/job/engineering/engineer
	allowed_branches = list(
		/datum/mil_branch/civ
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
		)
	min_skill = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_COMPUTER     = SKILL_BASIC,
	    SKILL_EVA          = SKILL_BASIC,
	    SKILL_CONSTRUCTION = SKILL_ADEPT,
	    SKILL_ELECTRICAL   = SKILL_BASIC,
	    SKILL_ATMOS        = SKILL_BASIC,
	    SKILL_ENGINES      = SKILL_BASIC
	)
	max_skill = list(
		SKILL_CONSTRUCTION = SKILL_MAX,
	    SKILL_ELECTRICAL   = SKILL_MAX,
	    SKILL_ATMOS        = SKILL_MAX,
	    SKILL_ENGINES      = SKILL_MAX
	)
	skill_points = 20
	software_on_spawn = list(
		/datum/computer_file/program/power_monitor,
		/datum/computer_file/program/supermatter_monitor,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmos_control,
		/datum/computer_file/program/rcon_console,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/shields_monitor
	)
	event_categories = list(ASSIGNMENT_ENGINEER)


/datum/job/engineer_trainee
	title = "Engineer Trainee"
	department_types = list(/decl/department/engineering)

	total_positions = 8
	spawn_positions = 7
	supervisors = "the chief engineer and engineer"
	selection_color = "#5b4d20"
	economic_power = 3
	minimal_player_age = 7
	access = list(
		access_eva,
		access_engine,
		access_engine_equip,
		access_tech_storage,
		access_maint_tunnels,
		access_external_airlocks,
		access_construction,
		access_atmospherics,
		access_emergency_storage
	)
	minimal_access = list(
		access_eva,
		access_engine,
		access_engine_equip,
		access_tech_storage,
		access_maint_tunnels,
		access_external_airlocks,
		access_construction,
		access_atmospherics,
		access_emergency_storage
	)
	outfit_type = /decl/hierarchy/outfit/job/engineering/engineer_trainee
	allowed_branches = list(
		/datum/mil_branch/civ
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
		)
	min_skill = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_COMPUTER     = SKILL_BASIC,
	    SKILL_EVA          = SKILL_BASIC,
	    SKILL_CONSTRUCTION = SKILL_BASIC,
	    SKILL_ELECTRICAL   = SKILL_BASIC,
	    SKILL_ATMOS        = SKILL_BASIC,
	    SKILL_ENGINES      = SKILL_BASIC
	)
	max_skill = list(
		SKILL_CONSTRUCTION = SKILL_ADEPT,
	    SKILL_ELECTRICAL   = SKILL_ADEPT,
	    SKILL_ATMOS        = SKILL_ADEPT,
	    SKILL_ENGINES      = SKILL_ADEPT
	)
	skill_points = 20
	software_on_spawn = list(
		/datum/computer_file/program/power_monitor,
		/datum/computer_file/program/supermatter_monitor,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmos_control,
		/datum/computer_file/program/rcon_console,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/shields_monitor
	)
	event_categories = list(ASSIGNMENT_ENGINEER)

/obj/item/card/id/engineering
	name = "identification card"
	desc = "A card issued to engineering staff."
	detail_color = COLOR_SUN
	var/acquired_dose = 0 //mSv

/obj/item/card/id/engineering/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/card/id/engineering/examine(mob/user, distance)
	. = ..()
	var/message
	switch(acquired_dose)
		if(0 to 1000)
			message = SPAN_NOTICE("The radiation dose badge is green and clear.")
		if(1000 to 6000)
			message = SPAN_WARNING("The radiation dose badge is yellow, signaling dangerous levels.")
		if(6000 to 28000)
			message = SPAN_DANGER("The radiation dose badge is discolored to lethal red...")
		if(28000 to INFINITY)
			message = SPAN_DANGER("The radiation dose badge burned out and turned black from radiation...")
	to_chat(user, message)

/obj/item/card/id/engineering/Process()
	acquired_dose += SSradiation.get_rads_at_turf(get_turf(src)) / 3600

/obj/item/card/id/engineering/head
	name = "identification card"
	desc = "A card which represents creativity and ingenuity."
	extra_details = list("goldstripe")
