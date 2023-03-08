/datum/npc_controller
	var/obj/item/current_weapon = null
	var/mob/living/carbon/human/npc/owner = null

/datum/npc_controller/proc/trigger()
	return PROCESS_KILL

/datum/npc_controller/New()
	START_PROCESSING(SSnpc, src)
	. = ..()

/datum/npc_controller/Destroy(force)
	STOP_PROCESSING(SSnpc, src)
	. = ..()

