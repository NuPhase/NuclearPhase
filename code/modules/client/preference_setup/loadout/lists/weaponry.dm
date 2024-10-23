/decl/loadout_category/weaponry
	name = "Weaponry"

/decl/loadout_option/weaponry
	category = /decl/loadout_category/weaponry

/decl/loadout_option/weaponry/knives
	name = "knife selection"
	description = "A selection of knives."
	path = /obj/item/knife
	cost = 30

/decl/loadout_option/weaponry/knives/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"folding knife" =             /obj/item/knife/folding,
		"peasant folding knife" =     /obj/item/knife/folding/wood,
		"tactical folding knife" =    /obj/item/knife/folding/tacticool,
		"utility knife" =             /obj/item/knife/utility,
		"lightweight utility knife" = /obj/item/knife/utility/lightweight
	)

/decl/loadout_option/weaponry/servicepistol
	name = "CEF pistol"
	description = "Where did you get it?"
	path = /obj/item/gun/projectile/pistol/military_service/loadout
	cost = 170

/decl/loadout_option/weaponry/lowcaliberpistol
	name = "VPS pistol"
	description = "A simple 7mm pistol. Comes with a full magazine."
	path = /obj/item/gun/projectile/pistol/low_caliber/loadout
	cost = 80

/decl/loadout_option/weaponry/smg
	name = "MX-16 SMG"
	description = "A modern lightweight SMG."
	path = /obj/item/gun/projectile/pistol/low_caliber
	cost = 410

/decl/loadout_option/weaponry/cefmagazine
	name = "CEF pistol magazine"
	description = "An 11x25 15-round magazine."
	path = /obj/item/ammo_magazine/pistol
	cost = 30

/decl/loadout_option/weaponry/vpsmagazine
	name = "VPS pistol magazine"
	description = "A 7mm 8-round magazine."
	path = /obj/item/ammo_magazine/pistol/small
	cost = 20

/decl/loadout_option/weaponry/smgmagazine
	name = "MX-16 caseless magazine"
	description = "An 11x25 60-round magazine."
	path = /obj/item/ammo_magazine/smg/c11x25
	cost = 60

/decl/loadout_option/weaponry/mpat
	name = "MPAT launcher"
	description = "A single-use man-portable anti-tank rocket launcher."
	path = /obj/item/gun/launcher/rocket/armor_piercing
	cost = 780
