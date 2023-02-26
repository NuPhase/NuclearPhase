/obj/machinery/reactor_monitor/turbine
	name = "turbine monitoring computer"
	program_overlay = "turbine"

/obj/machinery/reactor_monitor/turbine/get_display_data()
	. = ..()
	var/data = ""
	data = "Turbine #1:<br>\
			RPM: [round(rcontrol.turbine1.rpm)].<br>\
			Vibration: [rcontrol.turbine1.get_vibration_flavor()].<br>\
			Mass flow: [round(rcontrol.turbine1.total_mass_flow)]kg/s.<br>\
			Steam Velocity: [round(rcontrol.turbine1.steam_velocity)]m/s<br><br>\
			Turbine #2:<br>\
			RPM: [round(rcontrol.turbine2.rpm)].<br>\
			Vibration: [rcontrol.turbine2.get_vibration_flavor()].<br>\
			Mass flow: [round(rcontrol.turbine2.total_mass_flow)]kg/s.<br>\
			Steam Velocity: [round(rcontrol.turbine2.steam_velocity)]m/s<br>"
	return data

/obj/machinery/reactor_display/group/turbine
	name = "turbine monitoring displays"

/obj/machinery/reactor_display/group/turbine/get_display_data()
	. = ..()
	var/data = ""
	data = "Turbine #1:<br>\
			RPM: [round(rcontrol.turbine1.rpm)].<br>\
			Vibration: [rcontrol.turbine1.get_vibration_flavor()].<br>\
			Mass flow: [round(rcontrol.turbine1.total_mass_flow)]kg/s.<br>\
			Steam Velocity: [round(rcontrol.turbine1.steam_velocity)]m/s<br><br>\
			Turbine #2:<br>\
			RPM: [round(rcontrol.turbine2.rpm)].<br>\
			Vibration: [rcontrol.turbine2.get_vibration_flavor()].<br>\
			Mass flow: [round(rcontrol.turbine2.total_mass_flow)]kg/s.<br>\
			Steam Velocity: [round(rcontrol.turbine2.steam_velocity)]m/s<br>"
	return data