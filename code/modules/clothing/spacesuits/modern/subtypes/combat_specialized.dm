/obj/item/clothing/head/helmet/modern/space/combat_specialized
	icon = 'icons/clothing/spacesuit/void/sec/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)

/obj/item/clothing/suit/modern/space/combat_specialized
	icon = 'icons/clothing/spacesuit/void/sec/suit.dmi'
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)



/obj/item/clothing/head/helmet/modern/space/combat_specialized/cold
	name = "CRICS-0.4V helmet"
	desc = "Cold Resistant Issued Combat System is a specialized suit made for engagement in harsh environments. Doesn't look very powerful, still."
	min_cold_protection_temperature = COLD_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = COLD_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	volume_multiplier = 0.3
	//weight = 40

/obj/item/clothing/suit/modern/space/combat_specialized/cold
	name = "CRICS-0.4V suit"
	desc = "Cold Resistant Issued Combat System is a specialized suit made for engagement in harsh environments. Doesn't look very powerful, still."
	min_cold_protection_temperature = COLD_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = COLD_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	//weight = 170