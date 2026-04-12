var/global/datum/ui_state/machinery/tgui_machinery_state = new

/datum/ui_state/machinery/can_use_topic(obj/machinery/src_object, mob/user)
	ASSERT(istype(src_object))

	if(src_object.stat & ( BROKEN | NOPOWER ))
		return FALSE

	return user.tgui_default_can_use_topic(src_object)