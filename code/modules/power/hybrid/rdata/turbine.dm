/obj/machinery/reactor_monitor/turbine
	name = "turbine monitoring computer"
	program_overlay = "turbine"

/obj/machinery/reactor_monitor/turbine/get_display_data()
	. = ..()
	var/breaks_engaged1 = ""
	var/breaks_engaged2 = ""
	if(rcontrol.turbine1.braking)
		breaks_engaged1 = "EMERGENCY BRAKING IN EFFECT.<br>"
	if(rcontrol.turbine2.braking)
		breaks_engaged2 = "EMERGENCY BRAKING IN EFFECT.<br>"
	var/data = ""
	data = "Turbine #1:<br>\
			RPM: [round(rcontrol.turbine1.rpm)].<br>\
			Isentropic Efficiency: [round(rcontrol.turbine1.efficiency * 100)]%.<br>\
			Vibration: [rcontrol.turbine1.get_vibration_flavor()].<br>\
			Mass flow: [round(rcontrol.turbine1.total_mass_flow)]kg/s.<br>\
			Steam Velocity: [round(rcontrol.turbine1.steam_velocity)]m/s<br>\
			[breaks_engaged1]<br>\
			Turbine #2:<br>\
			RPM: [round(rcontrol.turbine2.rpm)].<br>\
			Isentropic Efficiency: [round(rcontrol.turbine2.efficiency * 100)]%.<br>\
			Vibration: [rcontrol.turbine2.get_vibration_flavor()].<br>\
			Mass flow: [round(rcontrol.turbine2.total_mass_flow)]kg/s.<br>\
			Steam Velocity: [round(rcontrol.turbine2.steam_velocity)]m/s<br>\
			[breaks_engaged2]"
	return data

/obj/machinery/reactor_display/group/turbine
	name = "turbine monitoring displays"

/obj/machinery/reactor_display/group/turbine/get_display_data()
	. = ..()
	var/breaks_engaged1 = ""
	var/breaks_engaged2 = ""
	if(rcontrol.turbine1.braking)
		breaks_engaged1 = "EMERGENCY BRAKING IN EFFECT.<br>"
	if(rcontrol.turbine2.braking)
		breaks_engaged2 = "EMERGENCY BRAKING IN EFFECT.<br>"
	var/data = ""
	data = "Turbine #1:<br>\
			RPM: [round(rcontrol.turbine1.rpm)].<br>\
			Vibration: [rcontrol.turbine1.get_vibration_flavor()].<br>\
			Mass flow: [round(rcontrol.turbine1.total_mass_flow)]kg/s.<br>\
			Steam Velocity: [round(rcontrol.turbine1.steam_velocity)]m/s<br>\
			[breaks_engaged1]<br>\
			Turbine #2:<br>\
			RPM: [round(rcontrol.turbine2.rpm)].<br>\
			Vibration: [rcontrol.turbine2.get_vibration_flavor()].<br>\
			Mass flow: [round(rcontrol.turbine2.total_mass_flow)]kg/s.<br>\
			Steam Velocity: [round(rcontrol.turbine2.steam_velocity)]m/s<br>\
			[breaks_engaged2]"
	return data