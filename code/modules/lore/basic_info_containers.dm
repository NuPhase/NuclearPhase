//Basic info containers are items that contain information which can be easily accessed(folders, unlocked phones, etc)
//they can be environment-sensitive

/obj/item/info_container
	icon = 'icons/obj/items/info.dmi'
	var/environment_dependant = TRUE
	var/max_temperature = 600
	var/min_temperature = 200
	var/ruined = FALSE
	var/can_open = TRUE

/obj/item/info_container/equipped(mob/user, slot)
	. = ..()
	if(!ruined && environment_dependant)
		check_environment()

/obj/item/info_container/proc/check_environment()
	var/turf/T = get_turf(src)
	var/datum/gas_mixture/environment = T.return_air()
	if(environment.temperature > max_temperature || environment.temperature < min_temperature)
		ruin()
		update_icon()

/obj/item/info_container/attack_self(mob/user)
	. = ..()
	if(!ruined && can_open)
		show_information(user)
	else
		show_ruined_information(user)

/obj/item/info_container/proc/show_information(mob/user)
	return

/obj/item/info_container/proc/show_ruined_information(mob/user)
	return

/obj/item/info_container/proc/ruin()
	ruined = TRUE



/obj/item/info_container/phone
	name = "phone"
	icon_state = "phone"
	max_temperature = 540 //LCD evaporation
	min_temperature = 200 //LCD crystalizes

/obj/item/info_container/phone/broken
	ruined = TRUE

/obj/item/info_container/phone/ruin()
	. = ..()
	visible_message(SPAN_WARNING("The [src]'s display breaks!"))

/obj/item/info_container/phone/show_ruined_information(mob/user)
	to_chat(user, SPAN_NOTICE("Why are you staring at a broken screen?.."))