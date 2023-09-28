/obj/machinery/reactor_monitor/general
	name = "general stats monitor"
	program_overlay = "warnings"

/obj/machinery/reactor_monitor/general/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/tload = rcontrol.generator1.last_load + rcontrol.generator2.last_load
	tload = watts_to_text(tload)

	var/mload = rcontrol.turbine1.kin_total + rcontrol.turbine2.kin_total
	mload = watts_to_text(mload)

	var/obj/machinery/power/hybrid_reactor/rcore = reactor_components["core"]

	var/datum/gas_mixture/core_air = rcore.return_air()
	var/temp_readout = core_air.temperature
	switch(temp_readout)
		if(0 to 1 MEGAKELVIN)
			temp_readout = "[round(temp_readout / 1000, 0.1)]KK"
		if(1.1 MEGAKELVIN to 1 GIGAKELVIN)
			temp_readout = "[round(temp_readout / 1000000, 0.1)]MK"
		if(1.1 GIGAKELVIN to INFINITY)
			temp_readout = "[round(temp_readout / 1000000000, 0.1)]GK"

	data["var1"] = "GENERAL STATISTICS:"
	data["var2"] = "Total Power Generation: [tload]"
	data["var3"] = "Total Energy Flow: [mload]"
	data["var4"] = "Neutron Rate: [round(rcore.neutron_rate*100-100)]%"
	data["var5"] = "Radiation Emission: [round(rcore.last_radiation)] Roentgen/Hour"
	data["var6"] = "Chamber Temperature: [temp_readout]"
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "reactor_monitor.tmpl", "Digital Monitor", 450, 270)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

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
			var/totalGas_add_string = ", Total weight: [round(mixture.get_mass(), 0.01)]kg"
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