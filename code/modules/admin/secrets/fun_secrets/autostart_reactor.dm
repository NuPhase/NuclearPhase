/datum/admin_secret_item/fun_secret/autostart_reactor
	name = "Autostart Fusion Reactor"

/datum/admin_secret_item/fun_secret/autostart_reactor/can_execute(var/mob/user)
	if(GAME_STATE != RUNLEVEL_GAME)
		return FALSE
	if(rcontrol.mode == REACTOR_CONTROL_MODE_AUTO)
		return FALSE

	return ..()

/datum/admin_secret_item/fun_secret/autostart_reactor/execute(var/mob/user)
	. = ..()
	if(.)
		rcontrol.autostart()
