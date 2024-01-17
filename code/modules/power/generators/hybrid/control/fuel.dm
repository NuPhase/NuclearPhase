/obj/machinery/reactor_button/fuel
	name = "FUEL V-MAIN"

/obj/machinery/reactor_button/fuel/do_action(mob/user)
	. = ..()
	var/injection_setting = tgui_input_number(user, "Select a new injection speed in %/s.", "Fuel Injection Speed", min_value = 0, max_value = 99)
	if(isnull(injection_setting))
		return
	var/list/ids_to_check = list("fuel1", "fuel2", "fuel3")
	for(var/id_to_check in ids_to_check)
		var/obj/machinery/reactor_fuelport/fuelport = reactor_components[id_to_check]
		fuelport.injection_ratio = injection_setting * 0.01

/obj/machinery/reactor_button/moderator
	name = "MOD MAIN"

/obj/machinery/reactor_button/moderator/do_action(mob/user)
	. = ..()
	var/panel_type = tgui_input_list(user, "Select a panel type.", "Reactor Moderation", list("Reflectors", "Moderators"))
	if(isnull(panel_type))
		return
	var/panel_setting = tgui_input_number(user, "Select a new panel exposure percentage.", "Panel Configuration", min_value = 0, max_value = 100)
	if(isnull(panel_setting))
		return
	var/obj/machinery/power/hybrid_reactor/rcore = reactor_components["core"]
	if(panel_type == "Reflectors")
		rcore.reflector_position = panel_setting * 0.01
	else
		rcore.moderator_position = panel_setting * 0.01

/obj/machinery/reactor_button/turn_switch/regvalve/moderator
	name = "MOD V-GAS"
	id = "MOD V-GAS"

/obj/machinery/reactor_button/rswitch/intake_valves
	name = "COMBUSTION V-INTAKE"
	desc = "A switch. It controls reactor combustion intake valves."