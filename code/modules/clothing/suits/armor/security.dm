/obj/item/clothing/suit/armor/pcarrier/security
	starting_accessories = list(/obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag)

/obj/item/clothing/suit/armor/pcarrier/detective
	starting_accessories = list(/obj/item/clothing/accessory/armor/plate, /obj/item/clothing/accessory/badge)

/obj/item/clothing/suit/armor/pcarrier/green/infantry
	name = "infantry plate carrier"
	starting_accessories = list(/obj/item/clothing/accessory/armor/plate/medium, /obj/item/clothing/accessory/storage/pouches/green)

/obj/item/clothing/suit/armor/pcarrier/green/tactical
	name = "tactical plate carrier"
	starting_accessories = list(/obj/item/clothing/accessory/armor/plate/tactical, /obj/item/clothing/accessory/storage/pouches/large/green, /obj/item/clothing/accessory/armguards/green, /obj/item/clothing/accessory/legguards/green)

/obj/item/clothing/suit/armor/warden
	name = "warden's jacket"
	desc = "An armoured jacket with silver rank pips and livery."
	icon = 'icons/clothing/suit/warden.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
		)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	cold_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	heat_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	material = /decl/material/solid/leather
	matter = list(
		/decl/material/solid/metal/titanium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT
	)
