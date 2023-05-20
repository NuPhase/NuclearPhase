/obj/machinery/reactor_display/group/steamloop
	name = "turbine loop display"
	overlaying = "tank"

/obj/machinery/reactor_display/group/steamloop/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	data["var1"] = "T-M-TURB IN|Pressure:[rcontrol.get_meter_pressure("T-M-TURB IN")]kPa|Temperature:[rcontrol.get_meter_temperature("T-M-TURB IN")]K|Mass:[rcontrol.get_meter_mass("T-M-TURB IN")]KG."
	data["var2"] = "T-M-TURB EX|Pressure:[rcontrol.get_meter_pressure("T-M-TURB EX")]kPa|Temperature:[rcontrol.get_meter_temperature("T-M-TURB EX")]K|Mass:[rcontrol.get_meter_mass("T-M-TURB EX")]KG."
	data["var3"] = "T-M-COOLANT|Pressure:[rcontrol.get_meter_pressure("T-M-COOLANT")]kPa|Temperature:[rcontrol.get_meter_temperature("T-M-COOLANT")]K|Mass:[rcontrol.get_meter_mass("T-M-COOLANT")]KG."
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "reactor_monitor.tmpl", "Digital Monitor", 500, 270)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)