/decl/hierarchy/outfit/job/security
	abstract_type = /decl/hierarchy/outfit/job/security
	uniform = /obj/item/clothing/under/tactical
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/jackboots
	backpack_contents = list(/obj/item/handcuffs = 1)
	l_pocket = /obj/item/communications/pocket_radio

/decl/hierarchy/outfit/job/security/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_SECURITY

/decl/hierarchy/outfit/job/security/hos
	name = "Job - Head of security"
	uniform = /obj/item/clothing/under/head_of_security
	pda_type = /obj/item/modular_computer/pda/heads
	backpack_contents = list(/obj/item/handcuffs = 1)

/decl/hierarchy/outfit/job/security/warden
	name = "Job - Warden"
	uniform = /obj/item/clothing/under/tactical
	r_pocket = /obj/item/flash
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/security/detective
	name = "Job - Detective"
	head = /obj/item/clothing/head/det
	uniform = /obj/item/clothing/under/det
	suit = /obj/item/clothing/suit/storage/det_trench
	r_pocket = /obj/item/flame/lighter/zippo
	shoes = /obj/item/clothing/shoes/dress
	hands = list(/obj/item/storage/briefcase/crimekit)
	pda_type = /obj/item/modular_computer/pda
	backpack_contents = list(/obj/item/storage/box/evidence = 1)

/decl/hierarchy/outfit/job/security/detective/Initialize()
	. = ..()
	backpack_overrides.Cut()

/decl/hierarchy/outfit/job/security/detective/forensic
	name = "Job - Forensic technician"
	head = null
	suit = /obj/item/clothing/suit/storage/forensics/blue

/decl/hierarchy/outfit/job/security/officer
	name = "Job - Security Officer"
	uniform = /obj/item/clothing/under/tactical
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jackboots/tactical
	head = /obj/item/clothing/head/helmet/tactical
	suit = /obj/item/clothing/suit/armor/pcarrier/tactical
	backpack_contents = list(/obj/item/flash=1)
	r_pocket = /obj/item/handcuffs
	pda_type = /obj/item/modular_computer/pda
