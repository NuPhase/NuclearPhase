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

/obj/item/clothing/suit/modern/space/combat_specialized/verb/emergency_ejection()
	set name = "Emergency Ejection"
	set category = "Life Support"
	set src in usr

	leakiness = 100
	visible_message(SPAN_DANGER("[usr] ejects from the [src], tearing it apart!"))
	usr.drop_from_inventory(src, usr.loc)
	var/turf/T = get_ranged_target_turf(usr, wearer.dir, 15)
	usr.throw_at(T, 15, 3, src)

/obj/item/clothing/head/helmet/modern/space/combat_specialized/cold
	name = "CRICS-0.4V helmet"
	desc = "Cold Resistant Issued Combat System is a specialized suit made for engagement in harsh environments. Doesn't look very powerful, still."
	min_cold_protection_temperature = COLD_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = COLD_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	volume_multiplier = 0.3
	weight = 40

/obj/item/clothing/suit/modern/space/combat_specialized/cold
	name = "CRICS-0.4V suit"
	desc = "Cold Resistant Issued Combat System is a specialized suit made for engagement in harsh environments. Doesn't look very powerful, still."
	min_cold_protection_temperature = COLD_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = COLD_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	weight = 170
	windbreak_coefficient = 1.3
	minimum_leak_damage = 25



/obj/item/clothing/head/helmet/modern/space/military_prototype //weak on helmets
	name = "CERS-2.5V helmet"
	desc = "A strange suit with several 'Combat Engineered Resistive System' signs on it. It doesn't have any manufacturer logos, though..."
	icon = 'icons/clothing/spacesuit/void/military/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	min_cold_protection_temperature = COLD_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = HOT_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	weight = 23

/obj/item/clothing/suit/modern/space/military_prototype
	name = "CERS-2.5V suit"
	desc = "A strange suit with several 'Combat Engineered Resistive System' signs on it. It doesn't have any manufacturer logos, though..."
	icon = 'icons/clothing/spacesuit/void/military/suit.dmi'
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	min_cold_protection_temperature = COLD_PRESSURE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = HOT_PRESSURE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	weight = 147
	windbreak_coefficient = 0.6
	minimum_leak_damage = 50 //dynamic protection
	lifesupport_type = /obj/item/storage/backpack/lifesupportpack/military_prototype

/obj/item/storage/backpack/lifesupportpack/military_prototype
	target_pressure = 75
	battery_type = /obj/item/cell/quantum/quadruplecapacity