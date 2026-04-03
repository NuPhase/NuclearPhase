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
	current_switch = reactor_buttons["T-CP 2V-IN"]
	current_switch.do_action()
	current_switch = reactor_buttons["T-CP 2V-EX"]
	current_switch.do_action()
	current_switch = reactor_buttons["F-CP 2V-IN"]
	current_switch.do_action()
	current_switch = reactor_buttons["F-CP 2V-EX"]
	current_switch.do_action()
	current_switch = reactor_buttons["perimeter"] //lights
	current_switch.do_action()

	var/obj/machinery/atmospherics/binary/pump/adv/P
	P = rcontrol.reactor_pumps["T-CP 1"]
	P.update_mode(REACTOR_PUMP_MODE_MAX)
	P.rpm = REACTOR_PUMP_RPM_MAX
	P = rcontrol.reactor_pumps["T-CP 2"]
	P.update_mode(REACTOR_PUMP_MODE_MAX)
	P.rpm = REACTOR_PUMP_RPM_MAX

	P.air2.adjust_gas_temp(/decl/material/liquid/water, 300000, 350) //add wotah to the loop

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

	var/obj/machinery/power/hybrid_reactor/R = reactor_components["core"]
	R.containment_field.adjust_gas(/decl/material/gas/hydrogen/deuterium, 5, 0)
	R.containment_field.adjust_gas(/decl/material/gas/hydrogen/tritium, 2, 0)
	R.containment_field.temperature = 115 MEGAKELVIN
	R.fast_neutrons = 0.0007
	R.moderator_position = 0.05

	turbine1.kin_energy = 94298145000.0
	turbine1.feeder_valve_openage = 0.2
	var/datum/gas_mixture/air1 = turbine1.port_gases["Steam In"]
	air1.adjust_gas_temp(/decl/material/liquid/water, 90000, 1200)
	mode = REACTOR_CONTROL_MODE_SEMIAUTO

	spawn(30 SECONDS)
		current_switch = reactor_buttons["AUTOSCRAM"]
		current_switch.do_action()
		current_switch = reactor_buttons["BATTERY CHARGER"]
		current_switch.do_action()
		current_switch = reactor_buttons["generator1"]
		current_switch.do_action()