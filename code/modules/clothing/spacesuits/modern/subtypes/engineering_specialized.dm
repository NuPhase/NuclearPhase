//These are universal suits primarily made for firefighting and such

/obj/item/clothing/head/helmet/modern/space/engineering
	icon = 'icons/clothing/spacesuit/void/engineering_new/helmet.dmi'
	name = "HEOS-3V helmet"
	desc = "Hazardous Environments Operations Suit is designed for brief exposures to extreme environments and intense thermal radiation. Its surface is very reflective, almost like a mirror."
	min_cold_protection_temperature = ENGINEERING_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = ENGINEERING_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = ENGIE_SUIT_MAX_PRESSURE
	volume_multiplier = 0.8
	weight = 5
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)

/obj/item/clothing/suit/modern/space/engineering
	icon = 'icons/clothing/spacesuit/void/engineering_new/suit.dmi'
	name = "HEOS-3V suit"
	desc = "Hazardous Environments Operations Suit is designed for brief exposures to extreme environments and intense thermal radiation. Its surface is very reflective, almost like a mirror."
	min_cold_protection_temperature = ENGINEERING_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = ENGINEERING_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = ENGIE_SUIT_MAX_PRESSURE
	weight = 35 //we're very light
	windbreak_coefficient = 1.5
	siemens_coefficient = 0.1
	lifting_strength_boost = 30
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	lifesupport_type = /obj/item/storage/backpack/lifesupportpack/adaptive_cooling/engineering

/obj/item/storage/backpack/lifesupportpack/adaptive_cooling/engineering
	target_pressure = 65 //oxygen toxicity is a real thing, but this suit is for brief use only
	battery_type = /obj/item/cell/quadruplecapacity