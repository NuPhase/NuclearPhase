/obj/machinery/reactor_monitor/general
	name = "general stats monitor"
	program_overlay = "warnings"

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
	var/datum/gas_mixture/core_air = rcore.return_air()
	var/list/data = list(
		"alarmlist" = assemble_tgui_alarm_list(),
		"power_load" = (rcontrol.generator1?.last_load + rcontrol.generator2?.last_load),
		"thermal_load" = (rcontrol.turbine1?.kin_total + rcontrol.turbine2?.kin_total),
		"neutron_rate" = round(rcore.neutron_rate*100-100),
		"radiation" = round(rcore.last_radiation),
		"chamber_temperature" = core_air.temperature,
		"containment_consumption" = round(rcore.field_power_consumption),
		"containment_temperature" = round(rcore.shield_temperature),
		"containment_charge" = 100 //not implemented
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
	var/obj/reactor = reactor_components["core"]
	print_atmos_analysis(user, get_chamber_analysis(reactor.loc))

/obj/machinery/reactor_monitor/general/proc/get_chamber_analysis(var/atom/target)
	. = list()
	. += "Results of the analysis of the chamber interior:"
	var/datum/gas_mixture/mixture = target.return_air()

	if(mixture)
		var/total_moles = mixture.total_moles

		if (total_moles>0)
			var/perGas_add_string = ""
			for(var/mix in mixture.gas)
				var/percentage = round(mixture.gas[mix]/total_moles * 100, 0.01)
				if(!percentage)
					continue
				var/decl/material/mat = GET_DECL(mix)
				. += "[capitalize(mat.gas_name)]: [percentage]%[perGas_add_string]"
			var/totalGas_add_string = "Total mass: [round(mixture.get_mass(), 0.01)]kg"
			. += "[totalGas_add_string]"
			return
	return "<span class='warning'>\The chamber has no gases!</span>"

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