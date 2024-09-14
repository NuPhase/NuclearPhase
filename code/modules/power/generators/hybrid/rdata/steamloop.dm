/obj/machinery/reactor_display/group/steamloop
	name = "turbine loop display"
	overlaying = "tank"

/obj/machinery/reactor_display/group/steamloop/physical_attack_hand(user)
	. = ..()
	tgui_interact(user)

/obj/machinery/reactor_display/group/steamloop/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosMeterList", "Reactor Monitoring")
		ui.open()
		ui.set_autoupdate(1)

/obj/machinery/reactor_display/group/steamloop/tgui_data(mob/user)
	var/list/data = list(
		"meterlist" = assemble_tgui_meter_list()
	)
	return data

/obj/machinery/reactor_display/group/steamloop/proc/assemble_tgui_meter_list()
	var/return_list = list()
	var/meter_list = list(
		"T-M EXCHANGER" = "Reactor heat exchanger.",
		"T-M-TURB IN" = "Turbine inlet.",
		"T-M-TURB EX" = "Turbine condenser.",
		"T-M-COOLANT" = "Condenser cooling circuit."
	)
	for(var/meter_id in meter_list)
		return_list += list(list("name" = meter_id,
								"description" = meter_list[meter_id],
								"pressure" = rcontrol.get_meter_pressure(meter_id),
								"temperature" = rcontrol.get_meter_temperature(meter_id),
								"mass" = rcontrol.get_meter_mass(meter_id)))
	return return_list