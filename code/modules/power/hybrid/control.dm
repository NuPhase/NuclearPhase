/obj/machinery/reactor_control_node
	name = "primary reactor control node"
	desc = "Reads and interprets signals transferred from the control room to the reactor."
	anchored = 1
	density = 1
	var/operable = TRUE

/obj/machinery/reactor_control_node/Destroy()
	. = ..()
	reactor_components["control_node"] = null

/obj/machinery/reactor_control_node/Initialize()
	. = ..()
	reactor_components["control_node"] = src

/obj/machinery/reactor_control_node/proc/check_controllability()
	if(operable)
		return TRUE
	else
		return FALSE

/obj/machinery/reactor_button
	name = "button"
	anchored = 1
	icon = 'icons/obj/power.dmi'
	icon_state = "light0-flat"
	layer = ABOVE_WINDOW_LAYER
	power_channel = ENVIRON
	idle_power_usage = 10
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES
	var/cooldown = 10
	var/used = FALSE
	var/id

/obj/machinery/reactor_button/Initialize()
	. = ..()
	if(id)
		reactor_buttons[id] = src

/obj/machinery/reactor_button/physical_attack_hand(user)
	. = ..()
	if(used)
		return

	var/obj/machinery/reactor_control_node/cnode = reactor_components["control_node"]
	if(cnode && cnode.check_controllability())
		do_action(user)

	used = TRUE
	spawn(cooldown)
		used = FALSE

/obj/machinery/reactor_button/proc/do_action(mob/user)
	return


/obj/machinery/reactor_button/rswitch
	name = "switch"
	icon_state = "light3"
	var/state = 0 //0-1
	var/on_icon_state = "light3-on"
	var/off_icon_state = "light3"

/obj/machinery/reactor_button/rswitch/do_action(mob/user)
	if(state)
		state = 0
		icon_state = off_icon_state
	else
		state = 1
		icon_state = on_icon_state