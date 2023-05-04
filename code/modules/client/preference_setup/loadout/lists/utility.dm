/decl/loadout_category/utility
	name = "Utility"

// "Useful" items - I'm guessing things that might be used at work?
/decl/loadout_option/utility
	category = /decl/loadout_category/utility

/decl/loadout_option/utility/briefcase
	name = "briefcase"
	path = /obj/item/storage/briefcase
	cost = 15

/decl/loadout_option/utility/clipboard
	name = "clipboard"
	path = /obj/item/clipboard
	cost = 5

/decl/loadout_option/utility/folder
	name = "folders"
	path = /obj/item/folder
	cost = 5

/decl/loadout_option/utility/taperecorder
	name = "tape recorder"
	path = /obj/item/taperecorder
	cost = 20

/decl/loadout_option/utility/folder/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"blue folder" =   /obj/item/folder/blue,
		"grey folder" =   /obj/item/folder,
		"red folder" =    /obj/item/folder/red,
		"cyan folder" =  /obj/item/folder/cyan,
		"yellow folder" = /obj/item/folder/yellow
	)

/decl/loadout_option/utility/camera
	name = "camera"
	path = /obj/item/camera
	cost = 15

/decl/loadout_option/utility/photo_album
	name = "photo album"
	path = /obj/item/storage/photo_album
	cost = 10

/decl/loadout_option/utility/film_roll
	name = "film roll"
	path = /obj/item/camera_film
	cost = 10

/decl/loadout_option/utility/pen
	name = "multicolored pen"
	path = /obj/item/pen/multi
	cost = 20

/decl/loadout_option/utility/fancy
	name = "fancy pen"
	path = /obj/item/pen/fancy
	cost = 20