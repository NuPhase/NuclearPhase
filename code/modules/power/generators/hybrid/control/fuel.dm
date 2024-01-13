/obj/machinery/reactor_button/fuel
	name = "FUEL V-MAIN"

/obj/machinery/reactor_button/fuel/do_action(mob/user)
	. = ..()
	var/injection_setting = tgui_input_number(user, "Select a new injection speed in %/s.", "Fuel Injection Speed", min_value = 0, max_value = 99)
	if(isnull(injection_setting))
		return
	var/list/ids_to_check = list("fuel1", "fuel2", "fuel3")
	for(var/id_to_check in ids_to_check)
		var/obj/machinery/reactor_fuelport/fuelport = reactor_components[id_to_check]
		fuelport.injection_ratio = injection_setting * 0.01

/obj/machinery/reactor_button/moderator
	name = "MOD MAIN"

/obj/machinery/reactor_button/turn_switch/regvalve/moderator
	name = "MOD V-GAS"
	id = "MOD V-GAS"

/obj/machinery/reactor_button/rswitch/intake_valves
	name = "COMBUSTION V-INTAKE"
	desc = "A switch. It controls reactor combustion intake valves."