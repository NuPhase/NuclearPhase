/obj/item/clothing/head/helmet/modern/space/medical
	icon = 'icons/clothing/spacesuit/void/medical_alt/helmet.dmi'
	name = "CRIMES-1V helmet"
	desc = "Cold Resistant Industrial Medical Excursion Suit is specifically designed for rescue operations in harsh environments."
	min_cold_protection_temperature = UNIVERSAL_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = UNIVERSAL_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	weight = 15

/obj/item/clothing/suit/modern/space/medical
	icon = 'icons/clothing/spacesuit/void/medical_alt/suit.dmi'
	name = "CRIMES-1V suit"
	desc = "Cold Resistant Industrial Medical Excursion Suit is specifically designed for rescue operations in harsh environments."
	min_cold_protection_temperature = UNIVERSAL_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = UNIVERSAL_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	weight = 70
	windbreak_coefficient = 0.6
	minimum_leak_damage = 10
	lifting_strength_boost = 10