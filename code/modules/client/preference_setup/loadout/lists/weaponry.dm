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
	name = "service pistol"
	description = "Where did you get it?"
	path = /obj/item/gun/projectile/pistol/military_service/loadout
	cost = 65