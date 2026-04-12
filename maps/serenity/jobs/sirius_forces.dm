/datum/job/sirius_forces
	abstract_type = /datum/job/sirius_forces
	department_types = list(/decl/department/security)
	total_positions = 0
	spawn_positions = 0
	selection_color = "#0e5e19"
	guestbanned = 1
	minimal_player_age = 7
	allowed_branches = list(
		/datum/mil_branch/army
	)

/datum/job/sirius_forces/equip(mob/living/carbon/human/H, alt_title, datum/mil_branch/branch, datum/mil_rank/grade)
	. = ..()
	var/obj/item/organ/internal/augment/boost/sleep_processor/sp = new
	sp.AttemptAugmentation(H, BP_HEAD)

/datum/job/sirius_forces/lieutenant
	title = "Lieutenant"
	total_positions = 1
	spawn_positions = 1
	supervisors = "yourself"
	selection_color = "#0e5e19"
	economic_power = 4
	skill_points = 37
	access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_armory,
		access_heads,
		access_forensics_lockers,
		access_morgue,
		access_maint_tunnels,
		access_all_personal_lockers,
		access_research,
		access_engine,
		access_mining,
		access_medical,
		access_construction,
		access_bridge,
		access_hos,
		access_RC_announce,
		access_keycard_auth,
		access_external_airlocks
	)
	minimal_access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_armory,
		access_heads,
		access_forensics_lockers,
		access_morgue,
		access_maint_tunnels,
		access_all_personal_lockers,
		access_research,
		access_engine,
		access_mining,
		access_medical,
		access_construction,
		access_bridge,
		access_hos,
		access_RC_announce,
		access_keycard_auth,
		access_external_airlocks
	)
	outfit_type = /decl/hierarchy/outfit/job/security/officer
	allowed_ranks = list(
		/datum/mil_rank/army/o1,
		/datum/mil_rank/army/o2,
		/datum/mil_rank/army/o3
		)
	min_skill = list(
		SKILL_LITERACY  = SKILL_BASIC,
		SKILL_EVA       = SKILL_BASIC,
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_ADEPT,
		SKILL_FORENSICS = SKILL_BASIC,
		SKILL_STRENGTH = SKILL_ADEPT,
		SKILL_FITNESS = SKILL_ADEPT,
		SKILL_AGILITY = SKILL_BASIC
	)
	max_skill = list(
		SKILL_COMBAT    = SKILL_MAX,
	    SKILL_WEAPONS   = SKILL_MAX,
	    SKILL_FORENSICS = SKILL_MAX
	)
	software_on_spawn = list(
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/camera_monitor
	)
	event_categories = list(ASSIGNMENT_SECURITY)
	required_whitelists = list(/decl/whitelist/security_management)

/datum/job/sirius_forces/sergeant
	title = "Sergeant"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Lieutenant"
	selection_color = "#0e5e19"
	economic_power = 4
	skill_points = 37
	access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_armory,
		access_maint_tunnels,
		access_research,
		access_engine,
		access_mining,
		access_medical,
		access_construction,
		access_external_airlocks
	)
	minimal_access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_armory,
		access_maint_tunnels,
		access_research,
		access_engine,
		access_mining,
		access_medical,
		access_construction,
		access_external_airlocks
	)
	outfit_type = /decl/hierarchy/outfit/job/security/officer
	allowed_ranks = list(
		/datum/mil_rank/army/e4,
		/datum/mil_rank/army/e5,
		/datum/mil_rank/army/e6,
		/datum/mil_rank/army/e7,
		/datum/mil_rank/army/e8
		)
	min_skill = list(
		SKILL_LITERACY  = SKILL_BASIC,
		SKILL_EVA       = SKILL_BASIC,
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_ADEPT,
		SKILL_FORENSICS = SKILL_BASIC,
		SKILL_STRENGTH = SKILL_ADEPT,
		SKILL_FITNESS = SKILL_ADEPT,
		SKILL_AGILITY = SKILL_BASIC
	)
	max_skill = list(
		SKILL_COMBAT    = SKILL_MAX,
	    SKILL_WEAPONS   = SKILL_MAX,
	    SKILL_FORENSICS = SKILL_MAX
	)
	software_on_spawn = list(
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/camera_monitor
	)
	event_categories = list(ASSIGNMENT_SECURITY)
	required_whitelists = list(/decl/whitelist/security_management)

/datum/job/sirius_forces/officer
	title = "Trooper"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Sergeant and Troop Commander"
	selection_color = "#166320"
	alt_titles = list("Recruit Trooper")
	economic_power = 4
	skill_points = 35
	access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_maint_tunnels,
		access_morgue,
		access_external_airlocks
	)
	minimal_access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_maint_tunnels,
		access_external_airlocks
	)
	outfit_type = /decl/hierarchy/outfit/job/security/officer
	allowed_ranks = list(
		/datum/mil_rank/army/e1,
		/datum/mil_rank/army/e2,
		/datum/mil_rank/army/e3
		)
	min_skill = list(
		SKILL_LITERACY  = SKILL_BASIC,
		SKILL_EVA       = SKILL_BASIC,
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_ADEPT,
		SKILL_FORENSICS = SKILL_BASIC,
		SKILL_STRENGTH = SKILL_ADEPT,
		SKILL_FITNESS = SKILL_ADEPT,
		SKILL_AGILITY = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_COMBAT    = SKILL_MAX,
	    SKILL_WEAPONS   = SKILL_MAX,
	    SKILL_FORENSICS = SKILL_MAX
	)
	software_on_spawn = list(
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/camera_monitor
	)
	event_categories = list(ASSIGNMENT_SECURITY)

/datum/job/sirius_forces/officer/equip(mob/living/carbon/human/H, alt_title, datum/mil_branch/branch, datum/mil_rank/grade)
	. = ..()
	var/obj/item/organ/internal/augment/boost/sleep_processor/sp = new
	sp.AttemptAugmentation(H, BP_HEAD)

/datum/job/sirius_forces/field_medic
	title = "Field Medic"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Sergeant and Troop Commander"
	selection_color = "#166320"
	economic_power = 4
	skill_points = 38
	access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_maint_tunnels,
		access_morgue,
		access_external_airlocks,
		access_medical,
		access_medical_equip
	)
	minimal_access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_maint_tunnels,
		access_external_airlocks,
		access_medical,
		access_medical_equip
	)
	outfit_type = /decl/hierarchy/outfit/job/security/officer
	allowed_ranks = list(
		/datum/mil_rank/army/e2,
		/datum/mil_rank/army/e3
	)
	min_skill = list(
		SKILL_LITERACY  = SKILL_BASIC,
		SKILL_EVA       = SKILL_BASIC,
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_ADEPT,
		SKILL_FORENSICS = SKILL_BASIC,
		SKILL_STRENGTH = SKILL_ADEPT,
		SKILL_FITNESS = SKILL_ADEPT,
		SKILL_AGILITY = SKILL_BASIC,
		SKILL_MEDICAL = SKILL_ADEPT,
		SKILL_ANATOMY = SKILL_ADEPT,
		SKILL_CHEMISTRY = SKILL_BASIC
	)
	max_skill = list(
		SKILL_COMBAT    = SKILL_MAX,
	    SKILL_WEAPONS   = SKILL_MAX,
	    SKILL_FORENSICS = SKILL_MAX
	)
	software_on_spawn = list(
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/camera_monitor
	)
	event_categories = list(ASSIGNMENT_SECURITY)
	required_whitelists = list(/decl/whitelist/medical_low)

/obj/item/card/id/security
	name = "identification card"
	desc = "A card issued to security staff."
	color = COLOR_OFF_WHITE
	detail_color = COLOR_MAROON

/obj/item/card/id/security/head
	name = "identification card"
	desc = "A card which represents honor and protection."
	extra_details = list("goldstripe")
