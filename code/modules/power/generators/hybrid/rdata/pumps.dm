/obj/machinery/reactor_display/group/pumps
	name = "pumps monitoring display"
	overlaying = "area_atmos"

/obj/machinery/reactor_display/group/pumps/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/obj/machinery/atmospherics/binary/pump/adv/pump1 = rcontrol.reactor_pumps["F-CP 1"]
	var/obj/machinery/atmospherics/binary/pump/adv/pump2 = rcontrol.reactor_pumps["F-CP 2"]
	var/obj/machinery/atmospherics/binary/pump/adv/pump3 = rcontrol.reactor_pumps["T-CP 1"]
	var/obj/machinery/atmospherics/binary/pump/adv/pump4 = rcontrol.reactor_pumps["T-CP 2"]
	var/obj/machinery/atmospherics/binary/pump/adv/pump5 = rcontrol.reactor_pumps["T-FEEDWATER CP-MAKEUP"]
	data["var1"] = "Name|Status|Speed|Mass Flow"
	data["var2"] = "[pump1.uid]|[pump1.mode]|[pump1.rpm]RPM|[round(pump1.last_mass_flow)]KG/S"
	data["var3"] = "[pump2.uid]|[pump2.mode]|[pump2.rpm]RPM|[round(pump2.last_mass_flow)]KG/S"
	data["var4"] = "[pump3.uid]|[pump3.mode]|[pump3.rpm]RPM|[round(pump3.last_mass_flow)]KG/S"
	data["var5"] = "[pump4.uid]|[pump4.mode]|[pump4.rpm]RPM|[round(pump4.last_mass_flow)]KG/S"
	data["var6"] = "[pump5.uid]|[pump5.mode]|[pump5.rpm]RPM|[round(pump5.last_mass_flow)]KG/S"
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "reactor_monitor.tmpl", "Digital Monitor", 450, 270)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)