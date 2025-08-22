/obj/item/clothing/head/helmet/modern/space/research
	icon = 'icons/clothing/spacesuit/void/excavation/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)

/obj/item/clothing/suit/modern/space/research
	icon = 'icons/clothing/spacesuit/void/excavation/suit.dmi'
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	windbreak_coefficient = 0.4
	minimum_leak_damage = 15
	lifting_strength_boost = 10

/obj/item/clothing/head/helmet/modern/space/research/cold
	name = "CROCS-0.8V helmet"
	desc = "Cold Resistant Occupant Concealment Suit is an engineering masterpiece, designed to withstand extremely cold environments and shield its occupant from powerful winds."
	min_cold_protection_temperature = COLD_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = COLD_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	weight = 30

/obj/item/clothing/suit/modern/space/research/cold
	name = "CROCS-0.8V suit"
	desc = "Cold Resistant Occupant Concealment Suit is an engineering masterpiece, designed to withstand extremely cold environments and shield its occupant from powerful winds."
	min_cold_protection_temperature = COLD_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = COLD_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	weight = 90

/obj/item/clothing/head/helmet/modern/space/research/hot
	name = "HROCS-0.8V helmet"
	desc = "Heat Resistant Occupant Concealment Suit is an engineering masterpiece, designed to withstand extremely hot environments and shield its occupant from powerful winds."
	min_cold_protection_temperature = HOT_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = HOT_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	weight = 20

/obj/item/clothing/suit/modern/space/research/hot
	name = "HROCS-0.8V suit"
	desc = "Heat Resistant Occupant Concealment Suit is an engineering masterpiece, designed to withstand extremely hot environments and shield its occupant from powerful winds."
	min_cold_protection_temperature = HOT_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = HOT_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	weight = 70