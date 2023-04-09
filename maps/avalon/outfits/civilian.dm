/decl/hierarchy/outfit/job/service
	abstract_type = /decl/hierarchy/outfit/job/service
	l_pocket = /obj/item/radio

/decl/hierarchy/outfit/job/service/bartender
	name = "Job - Bartender"
	uniform = /obj/item/clothing/under/bartender
	id_type = /obj/item/card/id/civilian

/decl/hierarchy/outfit/job/service/chef
	name = "Job - Chef"
	uniform = /obj/item/clothing/under/chef
	suit = /obj/item/clothing/suit/chef
	head = /obj/item/clothing/head/chefhat
	id_type = /obj/item/card/id/civilian

/decl/hierarchy/outfit/job/service/gardener
	name = "Job - Gardener"
	uniform = /obj/item/clothing/under/hydroponics
	suit = /obj/item/clothing/suit/apron
	gloves = /obj/item/clothing/gloves/thick/botany
	r_pocket = /obj/item/scanner/plant
	id_type = /obj/item/card/id/civilian

/decl/hierarchy/outfit/job/service/gardener/Initialize()
	. = ..()
	backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/storage/backpack/hydroponics
	backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/storage/backpack/satchel/hyd
	backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/storage/backpack/messenger/hyd

/decl/hierarchy/outfit/job/service/janitor
	name = "Job - Janitor"
	uniform = /obj/item/clothing/under/medical/scrubs/blue
	gloves = /obj/item/clothing/gloves/latex
	mask = /obj/item/clothing/mask/surgical
	shoes = /obj/item/clothing/shoes/color/blue
	id_type = /obj/item/card/id/civilian
/decl/hierarchy/outfit/job/internal_affairs_agent
	name = "Job - Internal affairs agent"
	uniform = /obj/item/clothing/under/internalaffairs
	suit = /obj/item/clothing/suit/storage/toggle/suit/black
	shoes = /obj/item/clothing/shoes/color/brown
	id_type = /obj/item/card/id/civilian

/decl/hierarchy/outfit/job/chaplain
	name = "Job - Chaplain"
	uniform = /obj/item/clothing/under/chaplain
	hands = list(/obj/item/storage/bible)
	id_type = /obj/item/card/id/civilian
	l_pocket = /obj/item/radio

/decl/hierarchy/outfit/job/explorer
	name = "Job - Explorer"
	uniform = /obj/item/clothing/under/familiargarb
	shoes = /obj/item/clothing/shoes/color/brown