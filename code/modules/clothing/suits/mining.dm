/obj/item/clothing/under/hevacs
	name = "HevACS undersuit"
	desc = "It's a tight-fitting undersuit consisting of layers of airtight fabric and thermal insulation."
	icon = 'icons/clothing/under/jumpsuits/hevacs.dmi'
	min_cold_protection_temperature = 170
	max_heat_protection_temperature = 410
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_STRONG,
		rad = ARMOR_RAD_SMALL
	)

/obj/item/clothing/under/hevacs/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 0.7)

/obj/item/clothing/head/hevacs
	name = "HevACS helmet"
	icon = 'icons/clothing/head/hevacs.dmi'
	desc = "A helmet that provides general thermal and chemical protection."
	permeability_coefficient = 0.05
	armor = list(
		bio = ARMOR_BIO_STRONG,
		rad = ARMOR_RAD_MINOR
		)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCK_ALL_HAIR
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES|SLOT_EARS
	siemens_coefficient = 0.9
	origin_tech = "{'materials':3, 'engineering':3}"
	matter = list(
		/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/clothing/mask/breath/hevacs
	name = "HevACS mask"
	desc = "It's an airtight mask that can be connected to an air supply."
	icon = 'icons/clothing/mask/gas_mask_poltergeist.dmi'
	icon_state = ICON_STATE_WORLD
	item_flags = ITEM_FLAG_AIRTIGHT|ITEM_FLAG_FLEXIBLEMATERIAL
	min_cold_protection_temperature = 170
	max_heat_protection_temperature = 410
	body_parts_covered = SLOT_FACE
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.05
	filtered_gases = list(
		/decl/material/gas/nitrous_oxide,
		/decl/material/gas/chlorine,
		/decl/material/gas/ammonia,
		/decl/material/gas/carbon_monoxide,
		/decl/material/gas/methyl_bromide,
		/decl/material/gas/methane
	)
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_RESISTANT,
		rad = ARMOR_RAD_SMALL
	)

/obj/item/clothing/gloves/hevacs
	name = "HevACS gloves"
	desc = "These gloves are resistant to chemicals."
	siemens_coefficient = 0.50
	permeability_coefficient = 0.05
	item_flags = ITEM_FLAG_THICKMATERIAL
	cold_protection = SLOT_HANDS
	min_cold_protection_temperature = 170
	heat_protection = SLOT_HANDS
	max_heat_protection_temperature = 410
	color = COLOR_GRAY20
	icon = 'icons/clothing/hands/firefighter.dmi'
	icon_state = ICON_STATE_WORLD
	force = 5
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_RESISTANT,
		rad = ARMOR_RAD_SMALL
	)

/obj/item/clothing/shoes/hevacs
	name = "HevACS boots"
	desc = "Tall boots with several layers of protective material."
	icon = 'icons/clothing/feet/hevacs.dmi'
	material = /decl/material/solid/plastic
	applies_material_colour = FALSE
	force = 3
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_RESISTANT,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.50
	permeability_coefficient = 0.05
	cold_protection = SLOT_FEET
	body_parts_covered = SLOT_FEET
	heat_protection = SLOT_FEET
	min_cold_protection_temperature = 170
	max_heat_protection_temperature = 410
