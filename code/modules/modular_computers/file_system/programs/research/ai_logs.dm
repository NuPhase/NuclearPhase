/datum/computer_file/program/ailogs
	filename = "ailogs"
	filedesc = "AI Logs"
	program_icon_state = "generic"
	program_key_state = "mining_key"
	program_menu_icon = "person"
	extended_desc = "Prints out FAI logs."
	size = 3
	read_access = list(access_bridge)
	nanomodule_path = /datum/nano_module/program/ailogs/

// Nano module the program uses.
// This can be either /datum/nano_module/ or /datum/nano_module/program. The latter is intended for nano modules that are suposed to be exclusively used with modular computers,
// and should generally not be used, as such nano modules are hard to use on other places.
/datum/nano_module/program/ailogs/
	name = "AI Logs"

// ui_interact handles transfer of data to NanoUI. Keep in mind that data you pass from here is actually sent to the client. In other words, don't send anything you don't want a client
// to see, and don't send unnecessarily large amounts of data (due to laginess).
/datum/nano_module/program/ailogs/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = host.initial_data()

	data["log_body"] = fcontrol.compile_logs()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ailogs.tmpl", "Facility AI Logs", 500, 350, state = state)
		ui.set_initial_data(data)
		ui.open()