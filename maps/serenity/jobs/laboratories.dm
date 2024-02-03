/datum/job/laboratories
	abstract_type = /datum/job/laboratories
	department_types = list(/decl/department/laboratories)
	total_positions = 0
	spawn_positions = 0
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
	access = list(
		access_robotics,
		access_tox,
		access_tox_storage,
		access_research,
		access_xenobiology,
		access_xenoarch,
		access_hydroponics
	)
	minimal_access = list(
		access_tox,
		access_tox_storage,
		access_research,
		access_xenoarch,
		access_xenobiology,
		access_hydroponics
	)

/datum/job/laboratories/lod
	title = "Laboratory Operations Director"
	supervisors = "the CEO"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/science/rd
	access = list(
		access_rd,
		access_bridge,
		access_tox,
		access_morgue,
		access_tox_storage,
		access_teleporter,
		access_sec_doors,
		access_heads,
		access_research,
		access_robotics,
		access_xenobiology,
		access_ai_upload,
		access_tech_storage,
		access_RC_announce,
		access_keycard_auth,
		access_tcomsat,
		access_gateway,
		access_xenoarch,
		access_network
	)
	minimal_access = list(access_rd,
		access_bridge,
		access_tox,
		access_morgue,
		access_tox_storage,
		access_teleporter,
		access_sec_doors,
		access_heads,
		access_research,
		access_robotics,
		access_xenobiology,
		access_ai_upload,
		access_tech_storage,
		access_RC_announce,
		access_keycard_auth,
		access_tcomsat,
		access_gateway,
		access_xenoarch,
		access_network
	)

/datum/job/laboratories/load
	title = "Laboratory Operations Assistant Director"
	supervisors = "the Laboratory Operations Director"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/science/rd
	access = list(
		access_rd,
		access_bridge,
		access_tox,
		access_morgue,
		access_tox_storage,
		access_teleporter,
		access_sec_doors,
		access_heads,
		access_research,
		access_robotics,
		access_xenobiology,
		access_ai_upload,
		access_tech_storage,
		access_RC_announce,
		access_keycard_auth,
		access_tcomsat,
		access_gateway,
		access_xenoarch,
		access_network
	)
	minimal_access = list(access_rd,
		access_bridge,
		access_tox,
		access_morgue,
		access_tox_storage,
		access_teleporter,
		access_sec_doors,
		access_heads,
		access_research,
		access_robotics,
		access_xenobiology,
		access_ai_upload,
		access_tech_storage,
		access_RC_announce,
		access_keycard_auth,
		access_tcomsat,
		access_gateway,
		access_xenoarch,
		access_network
	)

/datum/job/laboratories/pps
	title = "Particle Physics Specialist"
	supervisors = "the Laboratory Operations Director"
	total_positions = 3
	spawn_positions = 3
	outfit_type = /decl/hierarchy/outfit/job/science/scientist

/datum/job/laboratories/ggs
	title = "General Genetics Specialist"
	supervisors = "the Laboratory Operations Director"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/science/scientist
	access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_surgery,
		access_chemistry,
		access_virology,
		access_eva,
		access_maint_tunnels,
		access_external_airlocks,
		access_psychiatrist
	)
	minimal_access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_eva,
		access_maint_tunnels,
		access_external_airlocks
	)

/datum/job/laboratories/los
	title = "Laboratory Operations Specialist"
	supervisors = "the Laboratory Operations Director"
	total_positions = 5
	spawn_positions = 5
	outfit_type = /decl/hierarchy/outfit/job/science/scientist
	access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_surgery,
		access_chemistry,
		access_virology,
		access_eva,
		access_maint_tunnels,
		access_external_airlocks,
		access_psychiatrist
	)
	minimal_access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_eva,
		access_maint_tunnels,
		access_external_airlocks
	)

/datum/job/laboratories/loa
	title = "Laboratory Operations Assistant"
	supervisors = "the Laboratory Operations Director"
	total_positions = 3
	spawn_positions = 3
	outfit_type = /decl/hierarchy/outfit/job/science/scientist
	access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_surgery,
		access_chemistry,
		access_virology,
		access_eva,
		access_maint_tunnels,
		access_external_airlocks,
		access_psychiatrist
	)
	minimal_access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_eva,
		access_maint_tunnels,
		access_external_airlocks
	)