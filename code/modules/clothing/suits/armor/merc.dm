
/obj/item/clothing/suit/armor/pcarrier/merc
	starting_accessories = list(/obj/item/clothing/accessory/armor/plate/merc, /obj/item/clothing/accessory/armguards/merc, /obj/item/clothing/accessory/legguards/merc, /obj/item/clothing/accessory/storage/pouches/large)

/obj/item/clothing/accessory/armor/plate/merc
	name = "heavy armor plate"
	desc = "A diamond-reinforced titanium armor plate, providing state of of the art protection. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/armor_merc.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
		)
	material = /decl/material/solid/metal/titanium
	matter = list(/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = @'{"materials":5,"engineering":2,"combat":3}'
	slowdown = 0.1

/obj/item/clothing/accessory/armguards/merc
	name = "heavy arm guards"
	desc = "A pair of black arm pads reinforced with heavy armor plating. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/armguards_black.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
		)
	color = null
	material = /decl/material/solid/metal/steel
	origin_tech = @'{"materials":2,"engineering":1,"combat":2}'
	slowdown = 0.2

/obj/item/clothing/accessory/legguards/merc
	name = "heavy leg guards"
	desc = "A pair of heavily armored leg pads in black. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/legguards_black.dmi'
	color = null
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
		)
	material = /decl/material/solid/metal/steel
	origin_tech = @'{"materials":2,"engineering":1,"combat":2}'
	slowdown = 0.1
