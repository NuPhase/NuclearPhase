/decl/hierarchy/outfit/job/science
	abstract_type = /decl/hierarchy/outfit/job/science
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/color/white
	pda_type = /obj/item/modular_computer/pda/science
	l_pocket = /obj/item/communications/pocket_radio

/decl/hierarchy/outfit/job/science/rd
	name = "Job - Chief Science Officer"
	uniform = /obj/item/clothing/under/research_director
	shoes = /obj/item/clothing/shoes/color/brown
	hands = list(/obj/item/clipboard)
	pda_type = /obj/item/modular_computer/pda/heads

/decl/hierarchy/outfit/job/science/scientist
	name = "Job - Scientist"
	uniform = /obj/item/clothing/under/color/white
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science

/decl/hierarchy/outfit/job/science/roboticist
	name = "Job - Roboticist"
	uniform = /obj/item/clothing/under/color/white
	shoes = /obj/item/clothing/shoes/color/black
	belt = /obj/item/storage/belt/utility/full
	pda_slot = slot_r_store_str
	pda_type = /obj/item/modular_computer/pda/science

/decl/hierarchy/outfit/job/science/roboticist/Initialize()
	. = ..()
	backpack_overrides.Cut()
