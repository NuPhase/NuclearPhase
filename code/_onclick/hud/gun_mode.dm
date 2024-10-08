/obj/screen/gun
	name = "gun"
	icon = 'icons/hud/screen1.dmi'
	master = null
	dir = SOUTH

/obj/screen/gun/Click(location, control, params)
	if(!usr)
		return
	return 1

/obj/screen/gun/move
	name = "Allow Movement"
	icon_state = "no_walk1"
	screen_loc = ui_gun2

/obj/screen/gun/move/Click(location, control, params)
	if(..())
		var/mob/living/user = usr
		if(istype(user))
			if(!user.aiming) user.aiming = new(user)
			user.aiming.toggle_permission(TARGET_CAN_MOVE)
		return 1
	return 0

/obj/screen/gun/item
	name = "Allow Item Use"
	icon_state = "no_item1"
	screen_loc = ui_gun1

/obj/screen/gun/item/Click(location, control, params)
	if(..())
		var/mob/living/user = usr
		if(istype(user))
			if(!user.aiming) user.aiming = new(user)
			user.aiming.toggle_permission(TARGET_CAN_CLICK)
		return 1
	return 0

/obj/screen/gun/mode
	name = "Toggle Gun Mode"
	icon_state = "gun0"
	screen_loc = ui_gun_select

/obj/screen/gun/mode/Click(location, control, params)
	if(..())
		var/mob/living/user = usr
		if(istype(user))
			if(!user.aiming) user.aiming = new(user)
			user.aiming.toggle_active()
		return 1
	return 0

/obj/screen/gun/radio
	name = "Disallow Radio Use"
	icon_state = "no_radio1"
	screen_loc = ui_gun4

/obj/screen/gun/radio/Click(location, control, params)
	if(..())
		var/mob/living/user = usr
		if(istype(user))
			if(!user.aiming) user.aiming = new(user)
			user.aiming.toggle_permission(TARGET_CAN_RADIO)
		return 1
	return 0
