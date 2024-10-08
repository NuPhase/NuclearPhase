/decl/hierarchy/outfit/job/cargo
	abstract_type = /decl/hierarchy/outfit/job/cargo
	l_pocket = /obj/item/communications/pocket_radio

/decl/hierarchy/outfit/job/cargo/qm
	name = "Job - Cargo"
	uniform = /obj/item/clothing/under/work/nanotrasen
	shoes = /obj/item/clothing/shoes/dress
	glasses = /obj/item/clothing/glasses/sunglasses
	hands = list(/obj/item/clipboard)
	id_type = /obj/item/card/id/cargo/head
	pda_type = /obj/item/modular_computer/pda/cargo

/obj/item/card/id/cargo/head
	name = "identification card"
	desc = "A card which represents service and planning."
	extra_details = list("goldstripe")

/decl/hierarchy/outfit/job/cargo/cargo_tech
	name = "Job - Cargo technician"
	uniform = /obj/item/clothing/under/work/nanotrasen
	shoes = /obj/item/clothing/shoes/workboots
	id_type = /obj/item/card/id/cargo
	pda_type = /obj/item/modular_computer/pda/cargo

/decl/hierarchy/outfit/job/cargo/mining
	name = "Job - Shaft miner"
	uniform = /obj/item/clothing/under/miner
	shoes = /obj/item/clothing/shoes/workboots
	id_type = /obj/item/card/id/cargo
	pda_type = /obj/item/modular_computer/pda/science
	backpack_contents = list(/obj/item/crowbar = 1, /obj/item/storage/ore = 1)
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/cargo/mining/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_ENGINEERING
