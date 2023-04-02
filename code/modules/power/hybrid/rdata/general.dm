/obj/machinery/reactor_monitor/general
	name = "general stats monitor"
	program_overlay = "warnings"

/obj/machinery/reactor_monitor/general/get_display_data()
	. = ..()
	var/tload = rcontrol.generator1.last_load + rcontrol.generator2.last_load
	switch(tload)
		if(0 to 1 MEGAWATTS)
			tload = "[round(tload / 1000, 0.1)]kW"
		if(1.1 MEGAWATTS to 1 GIGAWATTS)
			tload = "[round(tload / 1000000, 0.1)]mW"
		if(1.1 GIGAWATTS to INFINITY)
			tload = "[round(tload / 1000000000, 0.1)]gW"

	var/mload = rcontrol.turbine1.kin_total + rcontrol.turbine2.kin_total
	switch(mload)
		if(0 to 1 MEGAWATTS)
			mload = "[round(mload / 1000, 0.1)]kW"
		if(1.1 MEGAWATTS to 1 GIGAWATTS)
			mload = "[round(mload / 1000000, 0.1)]mW"
		if(1.1 GIGAWATTS to INFINITY)
			mload = "[round(mload / 1000000000, 0.1)]gW"

	var/obj/machinery/power/hybrid_reactor/rcore = reactor_components["core"]

	var/datum/gas_mixture/core_air = rcore.return_air()
	var/temp_readout = core_air.temperature
	switch(temp_readout)
		if(0 to 1 MEGAKELVIN)
			temp_readout = "[round(temp_readout / 1000, 0.1)]kK"
		if(1.1 MEGAKELVIN to 1 GIGAKELVIN)
			temp_readout = "[round(temp_readout / 1000000, 0.1)]mK"
		if(1.1 GIGAKELVIN to INFINITY)
			temp_readout = "[round(temp_readout / 1000000000, 0.1)]gK"

	var/data = ""
	data = "GENERAL STATISTICS: <br>\
			Total Power Generation: [tload] <br>\
			Total Thermal Flow: [mload] <br>\
			Neutron Rate: [round(rcore.neutron_rate*100-100)]% <br>\
			Radiation Emission: [round(rcore.last_radiation)] Roentgen/Hour<br>\
			Chamber Temperature: [temp_readout]"
	return data