/decl/loadout_category/medical
	name = "Medical"

/decl/loadout_option/medical
	category = /decl/loadout_category/medical

/decl/loadout_option/medical/gauze
	name = "gauze roll"
	description = "A roll of sterile medical gauze."
	path = /obj/item/stack/medical/bruise_pack
	cost = 15

/decl/loadout_option/medical/cotton
	name = "cotton balls"
	description = "A pack of surgical cotton balls. Can be used to pack puncture wounds."
	path = /obj/item/stack/medical/wound_filler
	cost = 15

/decl/loadout_option/medical/splints
	name = "makeshift splints"
	description = "For holding your limbs in place with duct tape and scrap metal."
	path = /obj/item/stack/medical/splint/ghetto
	cost = 20

/decl/loadout_option/medical/military_medkit
	name = "PMS kit"
	description = "A box stocked for military first aid."
	path = /obj/item/storage/box/military_medkit
	cost = 30

/decl/loadout_option/medical/medkit
	name = "first aid kit"
	description = "It's an emergency medical kit for those serious boo-boos."
	path = /obj/item/storage/firstaid/regular
	cost = 60