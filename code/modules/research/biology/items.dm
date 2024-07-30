//Container/injector
/obj/item/dna_container
	name = "DNA container"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "container"
	//Can only contain one of these
	var/mob/dna_owner = null
	var/decl/dna_pattern/installed_pattern = null

	var/dna_quality = 0 //0-100.
	var/dna_contamination = 0 //0-100. Basically how much toxin damage the player gets from the injection.
	weight = 0.1
	w_class = ITEM_SIZE_SMALL

/obj/item/dna_container/on_update_icon()
	if(dna_owner || installed_pattern)
		icon_state = "container_loaded"
	else
		icon_state = "container"

//A container with one of the DNA patterns.
/obj/item/dna_kit
	name = "DNA kit"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "dna_kit"
	var/decl/dna_pattern/installed_pattern = null
	weight = 0.2
	w_class = ITEM_SIZE_NORMAL

/obj/item/dna_kit/on_update_icon()
	if(installed_pattern)
		icon_state = "dna_kit_loaded"
	else
		icon_state = "dna_kit"

//A hard disk with one of the DNA patterns. The pattern can be replicated in an assembler infinitely.
/obj/item/dna_disk
	name = "DNA disk"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "harddisk"
	var/decl/dna_pattern/installed_pattern = null
	weight = 0.1
	w_class = ITEM_SIZE_NORMAL

/obj/item/dna_disk/on_update_icon()
	if(installed_pattern)
		icon_state = "harddisk_loaded"
	else
		icon_state = "harddisk"