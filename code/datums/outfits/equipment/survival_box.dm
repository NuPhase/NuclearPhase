var/global/list/survival_box_choices = list()

/decl/survival_box_option
	var/name = "survival kit"
	var/box_type = /obj/item/storage/box/survival

/decl/survival_box_option/Initialize()
	. = ..()
	global.survival_box_choices[name] = src

/decl/survival_box_option/medkit
	name = "handmade medkit"
	box_type = /obj/item/storage/firstaid/handmade

/decl/survival_box_option/mre
	name = "old MRE"
	box_type = /obj/item/storage/mrebag/menu9