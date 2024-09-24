/obj/machinery/reactor_monitor/maintenance
	name = "maintenance monitor"
	program_overlay = "error"

/obj/machinery/reactor_monitor/maintenance/physical_attack_hand(user)
	. = ..()
	tgui_interact(user)

/obj/machinery/reactor_monitor/maintenance/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MaintenanceReactorMonitor", "Reactor Maintenance")
		ui.open()
		ui.set_autoupdate(1)

/obj/machinery/reactor_monitor/maintenance/tgui_data(mob/user)
	var/obj/machinery/power/hybrid_reactor/rcore = reactor_components["core"]
	var/list/data = list(
		"loglist" = assemble_tgui_log_list(),
		"blanket_integrity" = round(rcore.blanket_integrity * 100),
		"divertor_integrity" = round(rcore.divertor_integrity * 100),
		"magnet_integrity" = round(rcore.magnet_integrity * 100),
		"structure_integrity" = round(rcore.structure_integrity * 100)
	)
	return data

/obj/machinery/reactor_monitor/maintenance/proc/assemble_tgui_log_list()
	var/list_length = length(rcontrol.operation_log)
	var/needed_logs = rcontrol.operation_log.Copy(list_length - 20, list_length)
	var/log_list = list()
	for(var/message in needed_logs)
		var/mcolor = COLOR_BLUE_LIGHT
		var/is_bold = FALSE
		if(needed_logs[message] == 2)
			mcolor = COLOR_RED
		else if(needed_logs[message] == 3)
			mcolor = COLOR_RED
			is_bold = TRUE
		log_list += list(list("content" = message, "color" = mcolor, "is_bold" = is_bold))
	return log_list