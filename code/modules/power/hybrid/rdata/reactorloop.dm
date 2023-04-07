/obj/machinery/reactor_display/group/reactorloop
	name = "reactor loop displays"

/obj/machinery/reactor_display/group/reactorloop/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	data["var1"] = "F-M HEATEXCHANGER|Pressure:[rcontrol.get_meter_pressure("F-M HEATEXCHANGER")]kPa|Temperature:[rcontrol.get_meter_temperature("F-M HEATEXCHANGER")]K|Mass:[rcontrol.get_meter_mass("F-M HEATEXCHANGER")]KG."
	data["var2"] = "F-M IN|Pressure:[rcontrol.get_meter_pressure("F-M IN")]kPa|Temperature:[rcontrol.get_meter_temperature("F-M IN")]K|Mass:[rcontrol.get_meter_mass("F-M IN")]KG."
	data["var3"] = "F-M OUT|Pressure:[rcontrol.get_meter_pressure("F-M OUT")]kPa|Temperature:[rcontrol.get_meter_temperature("F-M OUT")]K|Mass:[rcontrol.get_meter_mass("F-M OUT")]KG."
	data["var4"] = "REACTOR-M CHAMBER|Pressure:[rcontrol.get_meter_pressure("REACTOR-M CHAMBER")]kPa|Temperature:[rcontrol.get_meter_temperature("REACTOR-M CHAMBER")]K|Mass:[rcontrol.get_meter_mass("REACTOR-M CHAMBER")]KG."
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "reactor_monitor.tmpl", "Digital Monitor", 450, 270)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)