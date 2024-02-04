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
						"vibration" = round(rcontrol.turbine1.vibration, 0.1),
						"mass_flow" = round(rcontrol.turbine1.total_mass_flow),
						"steam_velocity" = round(rcontrol.turbine1.steam_velocity),
						"breaks_engaged" = rcontrol.turbine1.braking,
						"inlet_temperature" = round(rcontrol.turbine1.inlet_temperature, 0.1),
						"inlet_pressure" = round(rcontrol.turbine1.inlet_pressure, 0.1),
						"exhaust_temperature" = round(rcontrol.turbine1.exhaust_temperature, 0.1),
						"exhaust_pressure" = round(rcontrol.turbine1.exhaust_pressure, 0.1),
						"static_expansion" = round(rcontrol.turbine1.expansion_ratio, 0.01),
						"real_expansion" = round(rcontrol.turbine1.real_expansion, 0.01),
						"kinetic_delta" = round(rcontrol.turbine1.kinetic_energy_delta, 1),
						"valve_position" = round(rcontrol.turbine1.feeder_valve_openage * 100, 0.01)
						),
		"turb2" = list(
						"rpm" = round(rcontrol.turbine2.rpm),
						"efficiency" = round(rcontrol.turbine2.efficiency, 0.01),
						"vibration" = round(rcontrol.turbine2.vibration, 0.1),
						"mass_flow" = round(rcontrol.turbine2.total_mass_flow),
						"steam_velocity" = round(rcontrol.turbine2.steam_velocity),
						"breaks_engaged" = rcontrol.turbine2.braking,
						"inlet_temperature" = round(rcontrol.turbine2.inlet_temperature, 0.1),
						"inlet_pressure" = round(rcontrol.turbine2.inlet_pressure, 0.1),
						"exhaust_temperature" = round(rcontrol.turbine2.exhaust_temperature, 0.1),
						"exhaust_pressure" = round(rcontrol.turbine2.exhaust_pressure, 0.1),
						"static_expansion" = round(rcontrol.turbine2.expansion_ratio, 0.01),
						"real_expansion" = round(rcontrol.turbine2.real_expansion, 0.01),
						"kinetic_delta" = round(rcontrol.turbine2.kinetic_energy_delta, 1),
						"valve_position" = round(rcontrol.turbine2.feeder_valve_openage * 100, 0.01)
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
		if("tripturb1")
			rcontrol.turbine1.feeder_valve_openage = 0
			return
		if("tripturb2")
			rcontrol.turbine2.feeder_valve_openage = 0
			return
		if("turb1adjust")
			rcontrol.turbine1.feeder_valve_openage = params["entry"] * 0.01
		if("turb2adjust")
			rcontrol.turbine2.feeder_valve_openage = params["entry"] * 0.01

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

/obj/machinery/reactor_display/group/turbine/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("braketurb1")
			rcontrol.turbine1.braking = TRUE
			return
		if("braketurb2")
			rcontrol.turbine2.braking = TRUE
			return