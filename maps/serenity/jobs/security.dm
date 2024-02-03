/datum/job/officer
	title = "Trooper"
	department_types = list(/decl/department/security)
	total_positions = 4
	spawn_positions = 4
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
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/security/officer
	allowed_branches = list(
		/datum/mil_branch/army
	)
	allowed_ranks = list(
		/datum/mil_rank/army/e1,
		/datum/mil_rank/army/e2,
		/datum/mil_rank/army/e3
		)
	guestbanned = 1
	min_skill = list(
		SKILL_LITERACY  = SKILL_BASIC,
		SKILL_EVA       = SKILL_BASIC,
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_ADEPT,
		SKILL_FORENSICS = SKILL_BASIC
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

/datum/job/officer/equip(mob/living/carbon/human/H, alt_title, datum/mil_branch/branch, datum/mil_rank/grade)
	. = ..()
	var/obj/item/organ/internal/augment/boost/sleep_processor/sp = new
	sp.AttemptAugmentation(H, BP_HEAD)

/datum/job/field_medic
	title = "Field Medic"
	department_types = list(/decl/department/security)
	total_positions = 2
	spawn_positions = 2
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
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/security/officer
	allowed_branches = list(
		/datum/mil_branch/army
	)
	allowed_ranks = list(
		/datum/mil_rank/army/e2,
		/datum/mil_rank/army/e3
	)
	guestbanned = 1
	min_skill = list(
		SKILL_LITERACY  = SKILL_BASIC,
		SKILL_EVA       = SKILL_BASIC,
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_ADEPT,
		SKILL_FORENSICS = SKILL_BASIC
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

/obj/item/card/id/security
	name = "identification card"
	desc = "A card issued to security staff."
	color = COLOR_OFF_WHITE
	detail_color = COLOR_MAROON

/obj/item/card/id/security/head
	name = "identification card"
	desc = "A card which represents honor and protection."
	extra_details = list("goldstripe")
