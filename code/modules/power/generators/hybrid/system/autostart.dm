//This is for roundstart starting
/datum/reactor_control_system/proc/autostart()
	var/obj/machinery/reactor_button/rswitch/current_switch
	current_switch = reactor_buttons["T-CP 1V-IN"]
	current_switch.do_action()
	current_switch = reactor_buttons["T-CP 1V-EX"]
	current_switch.do_action()
	current_switch = reactor_buttons["F-CP 1V-IN"]
	current_switch.do_action()
	current_switch = reactor_buttons["F-CP 1V-EX"]
	current_switch.do_action()
	current_switch = reactor_buttons["F-CP 2V-IN"]
	current_switch.do_action()
	current_switch = reactor_buttons["F-CP 2V-EX"]
	current_switch.do_action()
	current_switch = reactor_buttons["perimeter"] //lights
	current_switch.do_action()

	var/obj/machinery/atmospherics/binary/regulated_valve/current_valve = rcontrol.reactor_valves["T-V-EXCHANGER"]
	current_valve.set_openage(100)
	current_valve = rcontrol.reactor_valves["T-V-SUPERHEATER"]
	current_valve.set_openage(100)

	var/obj/machinery/atmospherics/binary/pump/adv/P
	P = rcontrol.reactor_pumps["T-CP 1"]
	P.update_mode(REACTOR_PUMP_MODE_MAX)
	P.rpm = REACTOR_PUMP_RPM_MAX

	P.air2.adjust_gas_temp(/decl/material/liquid/water, 40000, 350) //add wotah to the loop

	P = rcontrol.reactor_pumps["F-CP 1"]
	P.update_mode(REACTOR_PUMP_MODE_MAX)
	P.rpm = REACTOR_PUMP_RPM_MAX
	P = rcontrol.reactor_pumps["F-CP 2"]
	P.update_mode(REACTOR_PUMP_MODE_MAX)
	P.rpm = REACTOR_PUMP_RPM_MAX

	var/obj/machinery/reactor_button/current_button
	current_button = reactor_buttons["T-CP 1"]
	current_button.icon_state = "switch3-max"
	current_button = reactor_buttons["F-CP 1"]
	current_button.icon_state = "switch3-max"
	current_button = reactor_buttons["F-CP 2"]
	current_button.icon_state = "switch3-max"

	var/obj/machinery/power/hybrid_reactor/R = reactor_components["core"]
	R.containment_field.adjust_gas(/decl/material/gas/hydrogen/deuterium, 4, 0)
	R.containment_field.adjust_gas(/decl/material/gas/hydrogen/tritium, 4, 0)
	R.containment_field.temperature = 160 MEGAKELVIN
	R.containment_field.update_values()
	R.fast_neutrons = 0.0007
	R.moderator_position = 0

	var/list/ids_to_check = list("fuel1", "fuel2", "fuel3")
	for(var/id_to_check in ids_to_check)
		var/obj/machinery/reactor_fuelport/fuelport = reactor_components[id_to_check]
		QDEL_NULL(fuelport.inserted)
		var/obj/item/chems/fuel_cell/deuterium_tritium/new_cell = new
		fuelport.inserted = new_cell
		new_cell.forceMove(fuelport)

	turbine1.kin_energy = 94298145000.0
	turbine1.feeder_valve_openage = 0.2
	var/datum/gas_mixture/air1 = turbine1.port_gases["Steam In"]
	air1.adjust_gas_temp(/decl/material/liquid/water, 40000, OPTIMAL_REACTOR_STEAM_TEMP)

	autocontrol_available = TRUE
	mode = REACTOR_CONTROL_MODE_AUTO

	spawn(30 SECONDS)
		current_switch = reactor_buttons["AUTOSCRAM"]
		current_switch.do_action()
		current_switch = reactor_buttons["BATTERY CHARGER"]
		current_switch.do_action()
		current_switch = reactor_buttons["generator1"]
		current_switch.do_action()
		switch_program(/decl/control_program/reduced_power)