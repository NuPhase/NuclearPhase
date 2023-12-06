/obj/machinery/reactor_monitor/turbine
	name = "turbine monitoring computer"
	program_overlay = "turbine"

/obj/machinery/reactor_monitor/turbine/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TurbineMonitor", "Turbine Monitoring")
		ui.open()
		ui.set_autoupdate(1)

/obj/machinery/reactor_monitor/turbine/tgui_data(mob/user)
	var/list/data = list(
		"turb1" = list(
						"rpm" = round(rcontrol.turbine1.rpm),
						"efficiency" = round(rcontrol.turbine1.efficiency, 0.01),
						"vibration" = rcontrol.turbine1.get_vibration_flavor(),
						"mass_flow" = round(rcontrol.turbine1.total_mass_flow),
						"steam_velocity" = round(rcontrol.turbine1.steam_velocity),
						"breaks_engaged" = rcontrol.turbine1.braking
						),
		"turb2" = list(
						"rpm" = round(rcontrol.turbine2.rpm),
						"efficiency" = round(rcontrol.turbine2.efficiency, 0.01),
						"vibration" = rcontrol.turbine2.get_vibration_flavor(),
						"mass_flow" = round(rcontrol.turbine2.total_mass_flow),
						"steam_velocity" = round(rcontrol.turbine2.steam_velocity),
						"breaks_engaged" = rcontrol.turbine2.braking
						)
	)
	return data

/obj/machinery/reactor_monitor/turbine/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("braketurb1")
			rcontrol.turbine1.braking = TRUE
			return
		if("braketurb2")
			rcontrol.turbine2.braking = TRUE
			return

/obj/machinery/reactor_display/group/turbine
	name = "turbine monitoring displays"
	overlaying = "turbinecomp"

/obj/machinery/reactor_display/group/turbine/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TurbineMonitor", "Turbine Monitoring")
		ui.open()
		ui.set_autoupdate(1)

/obj/machinery/reactor_display/group/turbine/tgui_data(mob/user)
	var/list/data = list(
		"turb1" = list(
						round(rcontrol.turbine1.rpm),
						round(rcontrol.turbine1.efficiency),
						rcontrol.turbine1.get_vibration_flavor(),
						round(rcontrol.turbine1.total_mass_flow),
						round(rcontrol.turbine1.steam_velocity),
						rcontrol.turbine1.braking
						),
		"turb2" = list(
						round(rcontrol.turbine2.rpm),
						round(rcontrol.turbine2.efficiency),
						rcontrol.turbine2.get_vibration_flavor(),
						round(rcontrol.turbine2.total_mass_flow),
						round(rcontrol.turbine2.steam_velocity),
						rcontrol.turbine2.braking
						)
	)
	return data

/obj/machinery/reactor_display/group/turbine/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("braketurb1")
			rcontrol.turbine1.braking = TRUE
			return
		if("braketurb2")
			rcontrol.turbine2.braking = TRUE
			return