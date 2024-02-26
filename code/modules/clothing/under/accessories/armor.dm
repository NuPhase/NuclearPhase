//Pouches
/obj/item/clothing/accessory/storage/pouches
	name = "storage pouches"
	desc = "A bunch of tactical storage pouches for rigging harnesses and carriers."
	icon = 'icons/clothing/accessories/pouches/pouches_black.dmi'
	icon_state = ICON_STATE_WORLD
	gender = PLURAL
	slot = ACCESSORY_SLOT_ARMOR_S
	slots = 4

/obj/item/clothing/accessory/storage/pouches/green
	icon = 'icons/clothing/accessories/pouches/pouches_green.dmi'

/obj/item/clothing/accessory/storage/pouches/tan
	icon = 'icons/clothing/accessories/pouches/pouches_tan.dmi'

/obj/item/clothing/accessory/storage/pouches/large
	name = "large storage pouches"
	desc = "A lot of tactical storage pouches for rigging harnesses and carriers. Cumbersome, but spacious."
	icon = 'icons/clothing/accessories/pouches/lpouches_black.dmi'
	slots = 8
	slowdown = 0.3

/obj/item/clothing/accessory/storage/pouches/large/green
	icon = 'icons/clothing/accessories/pouches/lpouches_green.dmi'

/obj/item/clothing/accessory/storage/pouches/large/tan
	icon = 'icons/clothing/accessories/pouches/lpouches_tan.dmi'


//Armor plates
/obj/item/clothing/accessory/armor/plate
	name = "light armor plate"
	desc = "A basic armor plate made of steel-reinforced synthetic fibers. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/armor_light.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
		)
	slot = ACCESSORY_SLOT_ARMOR_C
	material = /decl/material/solid/plastic
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY
	)
	origin_tech = @'{"materials":1,"engineering":1,"combat":1}'

/obj/item/clothing/accessory/armor/plate/get_fibers()
	return null	//plates do not shed

/obj/item/clothing/accessory/armor/plate/dynamic
	name = "reactive armor"
	var/current_blocked_projectiles = 0 //counts up each time we suck up a projectile
	var/max_blocked_projectiles = 5
	var/min_blocking_damage = 10
	var/max_blocking_damage = 40

/obj/item/clothing/accessory/armor/plate/dynamic/handle_shielding(mob/user, damage, atom/damage_source, mob/attacker, def_zone, attack_text)
	if(current_blocked_projectiles < max_blocked_projectiles)
		current_blocked_projectiles += 1
		if(damage > min_blocking_damage && damage < max_blocking_damage)
			return TRUE
	return FALSE

/obj/item/clothing/accessory/armor/plate/dynamic/light
	name = "REDP armor plate" //reactive electric discharge protection
	desc = "An armor system consisting of a microcomputer and a set of independent modules consisting of capacitors and discharge systems. It is designed primarily to stop slow projectiles that do not have much kinetic energy."
	russian_desc = "Броневая система, представляющая из себя микрокомпьютер и набор независимых модулей, состоящих из конденсаторов и систем разрядки. Она разработана в первую очередь для остановки медленных снарядов, не обладающих большой кинетической энергией."
	max_blocked_projectiles = 17
	min_blocking_damage = 5
	max_blocking_damage = 35
	weight = 5.2

/obj/item/clothing/accessory/armor/plate/dynamic/medium
	name = "RDP armor plate" //reactive detonation protection
	desc = "Classic body armor with additional protection in the form of small explosive rounds capable of deflecting or stopping a flying projectile. Designed to stop most pistol calibers."
	russian_desc = "Классический бронежилет c дополнительной защитой в виде небольших взрывпакетов, способных отклонить или остановить летящий снаряд. Разработана для остановки большинства пистолетных калибров."
	icon = 'icons/clothing/accessories/armor/armor_medium.dmi'
	max_blocked_projectiles = 4
	min_blocking_damage = 30
	max_blocking_damage = 70
	weight = 5.8
	slowdown = 0.1

/obj/item/clothing/accessory/armor/plate/dynamic/heavy
	name = "RDP-X armor plate"
	desc = "A strengthened version of RDP armor."
	russian_desc = "Усиленная версия бронежилета RDP. Опасно."
	max_blocked_projectiles = 2
	min_blocking_damage = 40
	max_blocking_damage = 200
	weight = 7.4
	slowdown = 0.2

/obj/item/clothing/accessory/armor/plate/medium
	name = "medium armor plate"
	desc = "A plasteel-reinforced synthetic armor plate, providing good protection. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/armor_medium.dmi'
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
		)
	matter = list(
		/decl/material/solid/metal/plasteel = MATTER_AMOUNT_SECONDARY
	)
	origin_tech = @'{"materials":2,"engineering":1,"combat":2}'
	slowdown = 0.1

/obj/item/clothing/accessory/armor/plate/tactical
	name = "tactical armor plate"
	desc = "A heavier armor plate with additional diamond micromesh. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/armor_tactical.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_AP,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
		)
	slowdown = 0.2
	material = /decl/material/solid/metal/plasteel
	matter = list(
		/decl/material/solid/metal/titanium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
	origin_tech = @'{"materials":3,"engineering":2,"combat":2}'

//Arm guards
/obj/item/clothing/accessory/armguards
	name = "arm guards"
	desc = "A pair of armored arm pads. They have some straps with which they're meant to be attached to a rig."
	icon = 'icons/clothing/accessories/armor/armguards_black.dmi'
	icon_state = ICON_STATE_WORLD
	gender = PLURAL
	body_parts_covered = SLOT_ARMS
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
		)
	slot = ACCESSORY_SLOT_ARMOR_A
	material = /decl/material/solid/plastic
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY
	)
	origin_tech = @'{"materials":1,"engineering":1,"combat":1}'
	slowdown = 0.1

/obj/item/clothing/accessory/armguards/blue
	icon = 'icons/clothing/accessories/armor/armguards_blue.dmi'

/obj/item/clothing/accessory/armguards/green
	icon = 'icons/clothing/accessories/armor/armguards_green.dmi'

/obj/item/clothing/accessory/armguards/tan
	icon = 'icons/clothing/accessories/armor/armguards_tan.dmi'

/obj/item/clothing/accessory/armguards/craftable
	material_armor_multiplier = 1
	matter = null
	applies_material_name = TRUE

//Leg guards
/obj/item/clothing/accessory/legguards
	name = "leg guards"
	desc = "A pair of armored leg pads. They have some straps with which they're meant to be attached to a rig."
	icon = 'icons/clothing/accessories/armor/legguards_black.dmi'
	icon_state = ICON_STATE_WORLD
	gender = PLURAL
	body_parts_covered = SLOT_LEGS
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
		)
	slot = ACCESSORY_SLOT_ARMOR_L
	material = /decl/material/solid/plastic
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY
	)
	origin_tech = @'{"materials":1,"engineering":1,"combat":1}'
	slowdown = 0.1

/obj/item/clothing/accessory/legguards/blue
	icon = 'icons/clothing/accessories/armor/legguards_blue.dmi'

/obj/item/clothing/accessory/legguards/green
	icon = 'icons/clothing/accessories/armor/legguards_green.dmi'

/obj/item/clothing/accessory/legguards/tan
	icon = 'icons/clothing/accessories/armor/legguards_tan.dmi'

/obj/item/clothing/accessory/legguards/craftable
	material_armor_multiplier = 1
	matter = null
	applies_material_name =  TRUE

/obj/item/clothing/accessory/armor
	name = "master armor accessory"
	icon_state = ICON_STATE_WORLD

//Decorative attachments
/obj/item/clothing/accessory/armor/tag
	name = "\improper SECURITY tag"
	desc = "A black tag with the word SECURITY printed in silver lettering on it."
	slot = ACCESSORY_SLOT_ARMOR_M
	icon = 'icons/clothing/accessories/armor/tags.dmi'
	icon_state = "sectag"

/obj/item/clothing/accessory/armor/tag/press
	name = "\improper PRESS tag"
	desc = "A high-contrast blue tag with the word PRESS printed in white lettering on it."
	slot_flags = SLOT_LOWER_BODY
	icon = 'icons/clothing/accessories/armor/whitetags.dmi'
	icon_state = "presstag"

/obj/item/clothing/accessory/armor/tag/hos
	name = "\improper LEAD tag"
	desc = "A black tag with the word LEAD printed in white lettering on it."
	icon_state = "leadtag"

/obj/item/clothing/accessory/armor/tag/oneg
	name = "\improper O- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as O NEGATIVE."
	icon_state = "onegtag"

/obj/item/clothing/accessory/armor/tag/opos
	name = "\improper O+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as O POSITIVE."
	icon_state = "opostag"

/obj/item/clothing/accessory/armor/tag/apos
	name = "\improper A+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as A POSITIVE."
	icon_state = "apostag"

/obj/item/clothing/accessory/armor/tag/aneg
	name = "\improper A- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as A NEGATIVE."
	icon_state = "anegtag"

/obj/item/clothing/accessory/armor/tag/bpos
	name = "\improper B+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as B POSITIVE."
	icon_state = "bpostag"

/obj/item/clothing/accessory/armor/tag/bneg
	name = "\improper B- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as B NEGATIVE."
	icon_state = "bnegtag"

/obj/item/clothing/accessory/armor/tag/abpos
	name = "\improper AB+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as AB POSITIVE."
	icon_state = "abpostag"

/obj/item/clothing/accessory/armor/tag/abneg
	name = "\improper AB- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as AB NEGATIVE."
	icon_state = "abnegtag"

/obj/item/clothing/accessory/armor/helmcover
	name = "helmet cover"
	desc = "A fabric cover for armored helmets. This one is forest green."
	icon = 'icons/clothing/accessories/armor/helmcover_green.dmi'
	icon_state = ICON_STATE_WORLD
	slot = ACCESSORY_SLOT_HELM_C

/obj/item/clothing/accessory/armor/helmcover/blue
	name = "blue helmet cover"
	desc = "A fabric cover for armored helmets. This one is baby blue, made for combat reporters and UN blue-hats."
	icon = 'icons/clothing/accessories/armor/helmcover_blue.dmi'

/obj/item/clothing/accessory/armor/helmcover/tan
	icon = 'icons/clothing/accessories/armor/helmcover_tan.dmi'

