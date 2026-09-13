/decl/control_program
	var/name = "Program One"
	var/code = "P1"

/decl/control_program/proc/can_initiate()
	return TRUE
/decl/control_program/proc/initiated()
	return
/decl/control_program/proc/process()
	return
/decl/control_program/proc/abrupted()
	return
/decl/control_program/proc/end()
	return

/decl/control_program/idle
	name = "Idle"
	code = "P00"

/decl/control_program/full_power
	name = "Full Power Operation"
	code = "P11"
	var/target_power = 3000000000
	var/target_temp = 110000000 // D-T best temp

/decl/control_program/full_power/can_initiate()
	var/obj/machinery/power/hybrid_reactor/R = reactor_components["core"]
	return (rcontrol.turbine1.rpm > 3000 && rcontrol.turbine2.rpm > 3000 && R.containment_field.temperature > 90000000)

/decl/control_program/reduced_power
	name = "Reduced Power Operation"
	code = "P12"
	var/target_power = 1500000000
	var/target_temp = 110000000 // D-T best temp

/decl/control_program/reduced_power/can_initiate()
	var/obj/machinery/power/hybrid_reactor/R = reactor_components["core"]
	return (rcontrol.turbine1.rpm > 3000 && R.containment_field.temperature > 90000000)

/decl/control_program/reduced_power/process()
	var/obj/machinery/power/hybrid_reactor/R = reactor_components["core"]
	// If not enough thermal, open reflectors(up to 80%). Do not open if thermal margin is low.
	if(R.radiative_heat_loss < target_power && R.containment_field.temperature > target_temp)
		R.reflector_position = max(0.8, R.reflector_position - 0.001)
	else
		R.reflector_position = min(1, R.reflector_position + 0.001)
	// If not enough thermal and reflectors are closed, add fuel
	if(R.radiative_heat_loss < target_power && R.reflector_position > 0.9)
		var/list/ids_to_check = list("fuel1", "fuel2", "fuel3")
		for(var/id_to_check in ids_to_check)
			var/obj/machinery/reactor_fuelport/fuelport = reactor_components[id_to_check]
			fuelport.injection_ratio = 5 //mg/s
	else
		var/list/ids_to_check = list("fuel1", "fuel2", "fuel3")
		for(var/id_to_check in ids_to_check)
			var/obj/machinery/reactor_fuelport/fuelport = reactor_components[id_to_check]
			fuelport.injection_ratio = 0 //mg/s

/decl/control_program/startup
	name = "Cold Startup"
	code = "P21"

/decl/control_program/reignition
	name = "Reignition"
	code = "P22"

/decl/control_program/scram
	name = "Emergency Shutdown"
	code = "P31"

/decl/control_program/shutdown
	name = "Full Shutdown"
	code = "P32"