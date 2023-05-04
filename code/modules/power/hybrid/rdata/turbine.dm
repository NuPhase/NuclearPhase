/obj/machinery/reactor_monitor/turbine
	name = "turbine monitoring computer"
	program_overlay = "turbine"

/obj/machinery/reactor_monitor/turbine/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/breaks_engaged1 = ""
	var/breaks_engaged2 = ""
	if(rcontrol.turbine1.braking)
		breaks_engaged1 = "EMERGENCY BRAKING IN EFFECT.<br>"
	if(rcontrol.turbine2.braking)
		breaks_engaged2 = "EMERGENCY BRAKING IN EFFECT.<br>"
	data["var1"] = "Turbine #1:"
	data["var2"] = "RPM: [round(rcontrol.turbine1.rpm)]."
	data["var3"] = "Vibration: [rcontrol.turbine1.get_vibration_flavor()]."
	data["var4"] = "Mass flow: [round(rcontrol.turbine1.total_mass_flow)]kg/s."
	data["var5"] = "Steam Velocity: [round(rcontrol.turbine1.steam_velocity)]m/s."
	data["var6"] = "[breaks_engaged1]"
	data["var7"] = "Turbine #2:"
	data["var8"] = "RPM: [round(rcontrol.turbine2.rpm)]."
	data["var9"] = "Vibration: [rcontrol.turbine2.get_vibration_flavor()]."
	data["var10"] = "Mass flow: [round(rcontrol.turbine2.total_mass_flow)]kg/s."
	data["var11"] = "Steam Velocity: [round(rcontrol.turbine2.steam_velocity)]m/s."
	data["var12"] = "[breaks_engaged2]"
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "reactor_monitor.tmpl", "Digital Monitor", 450, 270)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/obj/machinery/reactor_display/group/turbine
	name = "turbine monitoring displays"

/obj/machinery/reactor_display/group/turbine/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/breaks_engaged1 = ""
	var/breaks_engaged2 = ""
	if(rcontrol.turbine1.braking)
		breaks_engaged1 = "EMERGENCY BRAKING IN EFFECT.<br>"
	if(rcontrol.turbine2.braking)
		breaks_engaged2 = "EMERGENCY BRAKING IN EFFECT.<br>"
	data["var1"] = "Turbine #1:"
	data["var2"] = "RPM: [round(rcontrol.turbine1.rpm)]."
	data["var3"] = "Vibration: [rcontrol.turbine1.get_vibration_flavor()]."
	data["var4"] = "Mass flow: [round(rcontrol.turbine1.total_mass_flow)]kg/s."
	data["var5"] = "Steam Velocity: [round(rcontrol.turbine1.steam_velocity)]m/s."
	data["var6"] = "[breaks_engaged1]"
	data["var7"] = "Turbine #2:"
	data["var8"] = "RPM: [round(rcontrol.turbine2.rpm)]."
	data["var9"] = "Vibration: [rcontrol.turbine2.get_vibration_flavor()]."
	data["var10"] = "Mass flow: [round(rcontrol.turbine2.total_mass_flow)]kg/s."
	data["var11"] = "Steam Velocity: [round(rcontrol.turbine2.steam_velocity)]m/s."
	data["var12"] = "[breaks_engaged2]"
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "reactor_monitor.tmpl", "Digital Monitor", 450, 270)
		ui.set_initial_data(data)
		ui.open()