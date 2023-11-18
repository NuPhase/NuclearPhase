/datum/job/submap
	branch = /datum/mil_branch/civ
	rank =   /datum/mil_rank/civ/civ
	allowed_branches = list(/datum/mil_branch/civ)
	allowed_ranks = list(/datum/mil_rank/civ/civ)
	required_language = null

/datum/map/avalon
	branch_types = list(
		/datum/mil_branch/civ,
		/datum/mil_branch/army
	)

	spawn_branch_types = list(
		/datum/mil_branch/civ,
		/datum/mil_branch/army
	)

/*
 *  Branches
 *  ========
 */


/datum/mil_branch/army
	name = "Sirius Armed Forces"
	name_short = "SAF"

	rank_types = list(
		/datum/mil_rank/army/e1,
		/datum/mil_rank/army/e2,
		/datum/mil_rank/army/e3,
		/datum/mil_rank/army/e4,
		/datum/mil_rank/army/e5,
		/datum/mil_rank/army/e6,
		/datum/mil_rank/army/e7,
		/datum/mil_rank/army/e8,
		/datum/mil_rank/army/o1,
		/datum/mil_rank/army/o2,
		/datum/mil_rank/army/o3,
		/datum/mil_rank/army/o4,
		/datum/mil_rank/army/o5,
		/datum/mil_rank/army/o6,
		/datum/mil_rank/army/o7,
		/datum/mil_rank/army/o8,
		/datum/mil_rank/army/o9,
		/datum/mil_rank/army/o10
	)

	spawn_rank_types = list(
		/datum/mil_rank/army/e1,
		/datum/mil_rank/army/e2,
		/datum/mil_rank/army/e3,
		/datum/mil_rank/army/e4,
		/datum/mil_rank/army/e5,
		/datum/mil_rank/army/e6,
		/datum/mil_rank/army/o1,
		/datum/mil_rank/army/o2,
		/datum/mil_rank/army/o3
	)


/datum/mil_branch/civ
	name = "Civilian"


	rank_types = list(
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/civ/synth
	)

	spawn_rank_types = list(
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/civ/synth
	)

/*
 *  Army
 *  ====
 */
/datum/mil_rank/army/e1
	name = "Recruit"
	name_short = "Rct"
	accessory = list(/obj/item/clothing/accessory/rank/army)
	sort_order = 1

/datum/mil_rank/army/e2
	name = "Private"
	name_short = "Pvt"
	accessory = list(/obj/item/clothing/accessory/rank/army/e2)
	sort_order = 2

/datum/mil_rank/army/e3
	name = "Corporal"
	name_short = "Cpl"
	accessory = list(/obj/item/clothing/accessory/rank/army/e3)
	sort_order = 3

/datum/mil_rank/army/e4
	name = "Sergeant"
	name_short = "Sgt"
	accessory = list (/obj/item/clothing/accessory/rank/army/e4)
	sort_order = 4

/datum/mil_rank/army/e5
	name = "Staff Sergeant"
	name_short = "SSgt"
	accessory = list(/obj/item/clothing/accessory/rank/army/e5)
	sort_order = 5

/datum/mil_rank/army/e6
	name = "Master Sergeant"
	name_short = "MSgt"
	accessory = list(/obj/item/clothing/accessory/rank/army/e6)
	sort_order = 6

/datum/mil_rank/army/e7
	name = "Warrant Officer"
	name_short = "WO"
	accessory = list(/obj/item/clothing/accessory/rank/army/e7)
	sort_order = 7


/datum/mil_rank/army/e8
	name = "Chief Warrant Officer"
	name_short = "CWO"
	accessory = list(/obj/item/clothing/accessory/rank/army/e8)
	sort_order = 8

/datum/mil_rank/army/o1
	name = "Lieutenant Junior-Grade"
	name_short = "LtJG"
	accessory = list(/obj/item/clothing/accessory/rank/army/officer)
	sort_order = 9

/datum/mil_rank/army/o2
	name = "Lieutenant"
	name_short = "Lt"
	accessory = list(/obj/item/clothing/accessory/rank/army/officer/o2)
	sort_order = 10

/datum/mil_rank/army/o3
	name = "Captain"
	name_short = "Cpt"
	accessory = list(/obj/item/clothing/accessory/rank/army/officer/o3)
	sort_order = 11

/datum/mil_rank/army/o4
	name = "Major"
	name_short = "Maj"
	accessory = list(/obj/item/clothing/accessory/rank/army/officer/o4)
	sort_order = 12

/datum/mil_rank/army/o5
	name = "Lieutenant Colonel"
	name_short = "LtCol"
	accessory = list(/obj/item/clothing/accessory/rank/army/officer/o5)
	sort_order = 13

/datum/mil_rank/army/o6
	name = "Colonel"
	name_short = "Col"
	accessory = list(/obj/item/clothing/accessory/rank/army/officer/o6)
	sort_order = 14

/datum/mil_rank/army/o7
	name = "Brigadier General"
	name_short = "BrgGen"
	accessory = list(/obj/item/clothing/accessory/rank/army/general)
	sort_order = 15

/datum/mil_rank/army/o8
	name = "Major General"
	name_short = "MajGen"
	accessory = list(/obj/item/clothing/accessory/rank/army/general/o8)
	sort_order = 16

/datum/mil_rank/army/o9
	name = "Lieutenant General"
	name_short = "LtGen"
	accessory = list(/obj/item/clothing/accessory/rank/army/general/o9)
	sort_order = 17

/datum/mil_rank/army/o10
	name = "General"
	name_short = "Gen"
	accessory = list(/obj/item/clothing/accessory/rank/army/general/o10)
	sort_order = 18

/*
 *  Civilians
 *  =========
 */

/datum/mil_rank/civ/civ
	name = "Civilian"
	name_short = "Civ"

/datum/mil_rank/civ/synth
	name = "Synthetic"
	name_short = "Synth"