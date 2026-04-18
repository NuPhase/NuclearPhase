/obj/machinery/reactor_button/fuel
	name = "FUEL V-MAIN"

/obj/machinery/reactor_button/fuel/do_action(mob/user)
	. = ..()
	var/injection_setting = tgui_input_number(user, "Select a new injection speed in milligrams per second.", "Fuel Injection Speed", min_value = 0, max_value = 1000)
	if(isnull(injection_setting))
		return
	rcontrol.make_log("FUEL INJECTION RATE SET TO [injection_setting]mg/s.", 1)
	var/list/ids_to_check = list("fuel1", "fuel2", "fuel3")
	for(var/id_to_check in ids_to_check)
		var/obj/machinery/reactor_fuelport/fuelport = reactor_components[id_to_check]
		fuelport.injection_ratio = injection_setting

/obj/machinery/reactor_button/fuel_select
	name = "FUEL V-SELECT"

/obj/machinery/reactor_button/fuel_select/do_action(mob/user)
	. = ..()
	var/list/ids_to_check = tgui_input_checkboxes(user, "Select the fuel ports to affect.", "Fuel Port Selection", list("fuel1", "fuel2", "fuel3"))
	if(!LAZYLEN(ids_to_check))
		return
	var/injection_setting = tgui_input_number(user, "Select a new injection speed in milligrams per second.", "Fuel Injection Speed", min_value = 0, max_value = 1000)
	if(isnull(injection_setting))
		return
	for(var/id_to_check in ids_to_check)
		rcontrol.make_log("FUEL INJECTION FOR [id_to_check] SET TO [injection_setting]mg/s.", 1)
		var/obj/machinery/reactor_fuelport/fuelport = reactor_components[id_to_check]
		fuelport.injection_ratio = injection_setting

/obj/machinery/reactor_button/fuel_read
	name = "FUEL READ"

/obj/machinery/reactor_button/fuel_read/do_action(mob/user)
	. = ..()
	var/selected_port_id = tgui_input_list(user, "Select the fuel port to read.", "Fuel Port Selection", list("fuel1", "fuel2", "fuel3"))
	if(isnull(selected_port_id))
		return
	var/obj/machinery/reactor_fuelport/fuelport = reactor_components[selected_port_id]
	if(!fuelport.inserted)
		to_chat(user, SPAN_WARNING("No cell in port."))
		return
	if(!fuelport.sealed)
		to_chat(user, SPAN_WARNING("Cell not locked."))
		return
	to_chat(user, SPAN_NOTICE("Port '[selected_port_id]' injection speed: [round(fuelport.injection_ratio, 0.1)]mg/s"))
	var/scan_data = reagent_scan_results(fuelport.inserted, TRUE)
	scan_data = jointext(scan_data, "<br>")
	user.show_message(SPAN_NOTICE(scan_data))

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
	rcontrol.make_log("[capitalize(panel_type)] EXPOSURE SWITCHED TO [panel_setting]%.", 1)

/obj/machinery/reactor_button/turn_switch/regvalve/moderator
	name = "MOD V-GAS"
	id = "MOD V-GAS"

/obj/machinery/reactor_button/rswitch/intake_valves
	name = "COMBUSTION V-INTAKE"
	desc = "A switch. It controls reactor combustion intake valves."