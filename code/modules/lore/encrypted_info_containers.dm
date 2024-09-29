//encrypted info containers are items that need effort to access their info(locked phones, email boxes, flash drives)

/obj/item/info_container/encrypted
	var/unlocked = FALSE
	can_open = FALSE

/obj/item/info_container/encrypted/quantum_data
	name = "quantum data drive"
	desc = "A high-tech device that stores quantum particle data."
	icon = 'icons/obj/items/stock_parts/modular_components.dmi'
	icon_state = "hdd_cluster"

/obj/item/info_container/encrypted/quantum_data/warp
	name = "quantum warp data drive"

/obj/item/info_container/encrypted/flash_drive
	name = "flash drive"
	desc = "A familiar data storage device."
	icon_state = "flash"
	var/contained_info = ""