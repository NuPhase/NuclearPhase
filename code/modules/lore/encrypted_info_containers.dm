//encrypted info containers are items that need effort to access their info(locked phones, email boxes, flash drives)

/obj/item/info_container/encrypted
	var/unlocked = FALSE
	can_open = FALSE

/obj/item/info_container/encrypted/flash_drive
	name = "flash drive"
	desc = "A familiar data storage device."
	icon_state = "flash"
	var/contained_info = ""