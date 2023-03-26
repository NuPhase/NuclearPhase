/obj/item/clothing/head/helmet/modern/space/unf
	icon = 'icons/clothing/spacesuit/void/military/helmet.dmi'
	name = "UN-AF suit helmet"
	desc = "What the hell is this suit?."
	weight = 30
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)

/obj/item/clothing/suit/modern/space/unf //so that crash survivors actually have a chance to survive
	icon = 'icons/clothing/spacesuit/void/military/suit.dmi'
	name = "UN-AF suit"
	desc = "This suit is extremely strange, given its foreign technology and strange 'UN Armed Forces' logos printed all over it. It looks completely devastated after its long exposure to the cold atmosphere outside..."
	weight = 230
	minimum_leak_damage = 70
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)