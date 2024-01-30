/decl/hierarchy/outfit/job/engineering
	abstract_type = /decl/hierarchy/outfit/job/engineering
	belt = /obj/item/storage/belt/utility/full
	shoes = /obj/item/clothing/shoes/workboots
	pda_slot = slot_l_store_str
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
	l_pocket = /obj/item/communications/pocket_radio
	id_type = /obj/item/card/id/engineering

/decl/hierarchy/outfit/job/engineering/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/rod
	name = "Job - Reactor Operations Director"
	uniform = /obj/item/clothing/under/lawyer/infil
	shoes = /obj/item/clothing/shoes/jackboots
	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/modular_computer/pda/heads

/decl/hierarchy/outfit/job/rod/assistant
	name = "Job - Reactor Operations Assistant Director"
	uniform = /obj/item/clothing/under/vice

/decl/hierarchy/outfit/job/engineering/chief_engineer
	name = "Job - Reactor Chief Engineer"
	head = /obj/item/clothing/head/hardhat/white
	uniform = /obj/item/clothing/under/executive/zeng/head
	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/modular_computer/pda/heads/ce

/decl/hierarchy/outfit/job/engineering/rmd
	name = "Job - Reactor Maintenance Director"
	head = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/under/chief_engineer
	gloves = /obj/item/clothing/gloves/thick
	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/modular_computer/pda/heads/ce

/decl/hierarchy/outfit/job/engineering/ros
	name = "Job - Reactor Operations Specialist"
	head = /obj/item/clothing/head/hardhat/white
	uniform = /obj/item/clothing/under/executive/zeng
	pda_type = /obj/item/modular_computer/pda/engineering

/decl/hierarchy/outfit/job/engineering/engineer
	name = "Job - Engineer"
	head = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/under/engineer
	r_pocket = /obj/item/t_scanner
	pda_type = /obj/item/modular_computer/pda/engineering

/decl/hierarchy/outfit/job/engineering/engineer_trainee
	name = "Job - Engineer trainee"
	head = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/under/hazard
	r_pocket = /obj/item/t_scanner
	pda_type = /obj/item/modular_computer/pda/engineering

/decl/hierarchy/outfit/job/engineering/atmos
	name = "Job - Atmospheric technician"
	uniform = /obj/item/clothing/under/atmospheric_technician
	belt = /obj/item/storage/belt/utility/atmostech
	pda_type = /obj/item/modular_computer/pda/engineering

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