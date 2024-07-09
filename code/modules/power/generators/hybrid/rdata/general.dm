/obj/machinery/reactor_monitor/general
	name = "general stats monitor"
	program_overlay = "warnings"

/obj/machinery/reactor_monitor/general/Initialize()
	. = ..()
	rcontrol.announcement_monitors += src

/obj/machinery/reactor_monitor/general/physical_attack_hand(user)
	. = ..()
	tgui_interact(user)

/obj/machinery/reactor_monitor/general/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GeneralReactorMonitor", "Reactor Monitoring")
		ui.open()
		ui.set_autoupdate(1)

/obj/machinery/reactor_monitor/general/tgui_data(mob/user)
	var/obj/machinery/power/hybrid_reactor/rcore = reactor_components["core"]
	var/datum/gas_mixture/core_air = rcore.containment_field
	var/list/data = list(
		"alarmlist" = assemble_tgui_alarm_list(),
		"power_load" = (rcontrol.generator1?.last_load + rcontrol.generator2?.last_load),
		"thermal_load" = (rcontrol.turbine1?.kin_total + rcontrol.turbine2?.kin_total),
		"neutron_rate" = round(rcore.neutron_rate, 0.01),
		"energy_rate" = round(rcore.energy_rate, 0.01),
		"xray_flux" = round(rcore.xray_flux, 0.01),
		"radiation" = round(rcore.last_radiation * 0.01),
		"chamber_temperature" = core_air.temperature,
		"containment_consumption" = round(rcore.field_power_consumption),
		"containment_temperature" = round(rcore.shield_temperature),
		"containment_charge" = round(rcore.field_battery_charge / MAX_MAGNET_CHARGE * 100, 0.1), //not implemented
		"moderator_position" = rcore.moderator_position,
		"reflector_position" = rcore.reflector_position
	)
	return data

/obj/machinery/reactor_monitor/general/proc/assemble_tgui_alarm_list()
	var/alarm_list = list()
	for(var/message in rcontrol.all_messages)
		var/mcolor = COLOR_BLUE_LIGHT
		var/is_bold = FALSE
		if(rcontrol.all_messages[message] == 2)
			mcolor = COLOR_RED
		else if(rcontrol.all_messages[message] == 3)
			mcolor = COLOR_RED
			is_bold = TRUE
		alarm_list += list(list("content" = message, "alarm_color" = mcolor, "is_bold" = is_bold))
	return alarm_list

/obj/machinery/reactor_monitor/general/examine(mob/user)
	. = ..()
	var/obj/machinery/power/hybrid_reactor/reactor = reactor_components["core"]
	print_atmos_analysis(user, get_chamber_analysis(reactor.containment_field))

/obj/machinery/reactor_monitor/general/proc/get_chamber_analysis(datum/gas_mixture/mixture)
	. = list()
	. += "Results of the analysis of the chamber interior:"

	if(mixture)
		var/total_moles = mixture.total_moles
		if (total_moles>0)
			for(var/mix in mixture.gas)
				var/percentage = round(mixture.gas[mix]/total_moles * 100, 0.01)
				if(!percentage)
					continue
				var/decl/material/mat = GET_DECL(mix)
				. += "[capitalize(mat.gas_name)]: [round(mixture.gas[mix] * mat.molar_mass * 1000, 0.1)]g | [round(mixture.gas[mix] * mat.molar_volume)]ml | [percentage]%"
			var/totalGas_add_string = "Total mass: [round(mixture.get_mass(), 0.01)]kg"
			. += "[totalGas_add_string]"
			return
	return "<span class='warning'>The chamber has no gases!</span>"

/obj/machinery/reactor_monitor/general/proc/chat_report(message, urgency)
	switch(urgency)
		if(1)
			loc.visible_message("[src] declares: [SPAN_NOTICE(message)].")
		if(2)
			loc.visible_message("[src] beeps: [SPAN_WARNING(message)].")
		if(3)
			loc.visible_message("[src] buzzes: [SPAN_DANGER(message)]!")

/obj/machinery/reactor_monitor/containment
	name = "containment monitoring computer"
	program_overlay = "containment"

/obj/machinery/reactor_monitor/containment/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/obj/machinery/power/hybrid_reactor/rcore = reactor_components["core"]
	data["var1"] = "CONTAINMENT MONITORING:"
	data["var2"] = "Power Consumption: [watts_to_text(rcore.field_power_consumption)]."
	data["var3"] = "Shield Temperature: [round(rcore.shield_temperature)]K."
	data["var4"] = "Shield Battery Charge: 100%"
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "reactor_monitor.tmpl", "Digital Monitor", 450, 270)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)