/datum/npc_controller
	var/obj/item/current_weapon = null
	var/mob/living/carbon/human/npc/owner = null

/datum/npc_controller/proc/trigger()

/datum/npc_controller/proc/handle_selfprocess()
	trigger()
	spawn(3)
		handle_selfprocess()