/obj/machinery/reactor_control_node
	name = "primary reactor control node"
	desc = "Reads and interprets signals transferred from the control room to the reactor."
	icon = 'icons/obj/machines/tcomms/hub.dmi'
	icon_state = "hub"
	anchored = 1
	density = 1
	var/operable = TRUE
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 100
	active_power_usage = 50000 //powerful computing system

/obj/machinery/reactor_control_node/Process()
	rcontrol.control()

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

/obj/machinery/reactor_server //would contribute to how well the control system works in the future
	name = "large server"
	desc = "A large mainframe with a logo on it. It reads: 'H.S.S.R. SUPPORT SYSTEMS'."
	icon = 'icons/obj/machines/tcomms/hub.dmi'
	icon_state = "hub"
	anchored = 1
	density = 1
	use_power = POWER_USE_IDLE
	idle_power_usage = 100
	active_power_usage = 45000 //a huge rack

/obj/machinery/reactor_button
	name = "button"
	anchored = 1
	icon = 'icons/obj/power.dmi'
	icon_state = "button1"
	layer = ABOVE_WINDOW_LAYER
	power_channel = ENVIRON
	idle_power_usage = 30 //control systems eat a lot
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES
	var/cooldown = 10
	var/used = FALSE
	var/needs_control_node = TRUE
	var/id
	var/action_sounds = list(
	'sound/machines/button1.ogg',
	'sound/machines/button2.ogg',
	'sound/machines/button3.ogg',
	'sound/machines/button4.ogg'
)

/obj/machinery/reactor_button/protected
	desc = "This button has a protective cover on."
	icon_state = "button1-cover_closed"
	var/cover_status = FALSE //is open
	var/covered_state = "button1-cover_closed"
	var/uncovered_state = "button1-cover_open"

/obj/machinery/reactor_button/Initialize()
	. = ..()
	if(id)
		reactor_buttons[id] = src

/obj/machinery/reactor_button/physical_attack_hand(user)
	. = ..()
	if(used)
		return

	var/obj/machinery/reactor_control_node/cnode = reactor_components["control_node"]
	if(needs_control_node && cnode && !cnode.check_controllability())
		return

	do_action(user)
	if(action_sounds)
		playsound(loc, pick(action_sounds), 50, 1)

	used = TRUE
	spawn(cooldown)
		used = FALSE

/obj/machinery/reactor_button/proc/do_action(mob/user)
	return


/obj/machinery/reactor_button/rswitch
	name = "switch"
	icon_state = "switch1-off"
	var/state = 0 //0-1
	var/on_icon_state = "switch1-on"
	var/off_icon_state = "switch1-off"
	action_sounds = list(
	'sound/machines/switch1.ogg',
	'sound/machines/switch2.ogg',
	'sound/machines/switch3.ogg',
	'sound/machines/switch4.ogg'
)

/obj/machinery/reactor_button/rswitch/proc/handle_icon()
	if(state)
		state = 0
		icon_state = off_icon_state
	else
		state = 1
		icon_state = on_icon_state

/obj/machinery/reactor_button/rswitch/do_action(mob/user)
	handle_icon()


/obj/machinery/reactor_button/turn_switch
	name = "switch"
	icon_state = "switch4-0"
	action_sounds = list(
	'sound/machines/switch1.ogg',
	'sound/machines/switch2.ogg',
	'sound/machines/switch3.ogg',
	'sound/machines/switch4.ogg'
)

/obj/machinery/reactor_button/turn_switch/on_update_icon(open_value)
	switch(open_value)
		if(0)
			icon_state = "switch4-0"
		if(0 to 0.25)
			icon_state = "switch4-25"
		if(0.25 to 0.5)
			icon_state = "switch4-50"
		if(0.5 to 1)
			icon_state = "switch4-75"