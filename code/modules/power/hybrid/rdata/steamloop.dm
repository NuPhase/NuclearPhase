/obj/machinery/reactor_display/group/steamloop
	name = "turbine loop displays"

/obj/machinery/reactor_display/group/steamloop/get_display_data()
	. = ..()
	var/data = ""
	data = "HEATEXCHANGER-M IN|Pressure:[rcontrol.get_meter_pressure("HEATEXCHANGER-M IN")]kPa|Temperature:[rcontrol.get_meter_temperature("HEATEXCHANGER-M IN")]K|Mass:[rcontrol.get_meter_mass("HEATEXCHANGER-M IN")]KG.<br>\
			T-M-TURB IN|Pressure:[rcontrol.get_meter_pressure("T-M-TURB IN")]kPa|Temperature:[rcontrol.get_meter_temperature("T-M-TURB IN")]K|Mass:[rcontrol.get_meter_mass("T-M-TURB IN")]KG.<br>\
			T-M-TURB EX|Pressure:[rcontrol.get_meter_pressure("T-M-TURB EX")]kPa|Temperature:[rcontrol.get_meter_temperature("T-M-TURB EX")]K|Mass:[rcontrol.get_meter_mass("T-M-TURB EX")]KG.<br>\
			T-M-COOLANT|Pressure:[rcontrol.get_meter_pressure("T-M-COOLANT")]kPa|Temperature:[rcontrol.get_meter_temperature("T-M-COOLANT")]K|Mass:[rcontrol.get_meter_mass("T-M-COOLANT")]KG."
	return data