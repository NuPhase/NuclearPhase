/obj/machinery/reactor_display/group/reactorloop
	name = "reactor loop displays"

/obj/machinery/reactor_display/group/reactorloop/get_display_data()
	. = ..()
	var/data = ""
	data = "F-M HEATEXCHANGER|Pressure:[rcontrol.get_meter_pressure("F-M HEATEXCHANGER")]kPa|Temperature:[rcontrol.get_meter_temperature("F-M HEATEXCHANGER")]K|Mass:[rcontrol.get_meter_mass("F-M HEATEXCHANGER")]KG.<br>\
			F-M IN|Pressure:[rcontrol.get_meter_pressure("F-M IN")]kPa|Temperature:[rcontrol.get_meter_temperature("F-M IN")]K|Mass:[rcontrol.get_meter_mass("F-M IN")]KG.<br>\
			F-M OUT|Pressure:[rcontrol.get_meter_pressure("F-M OUT")]kPa|Temperature:[rcontrol.get_meter_temperature("F-M OUT")]K|Mass:[rcontrol.get_meter_mass("F-M OUT")]KG.<br>\
			REACTOR-M CHAMBER|Pressure:[rcontrol.get_meter_pressure("REACTOR-M CHAMBER")]kPa|Temperature:[rcontrol.get_meter_temperature("REACTOR-M CHAMBER")]K|Mass:[rcontrol.get_meter_mass("REACTOR-M CHAMBER")]KG."
	return data