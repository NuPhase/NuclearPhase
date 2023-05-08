/obj/item/paper/reactor/coldstart
	name = "Manual Cold Start Checklist"
	info = "\
	<center><h3>REACTOR MANUAL COLD START</h3></center><BR>\
	<center><b>Last revised: (10/01/2206)</b></center><BR>\
	<i>Not recommended for execution by a team of 2 or less. Rewritten to accomodate the newest modifications.</i><BR>\
	<i>Lines that are <u>underlined</u> should not be executed for unmentioned reasons.</i><BR>\
	<BR>\
	<BR>\
	<BR>\
	-START PREPARATIONS-<BR>\
	<u>-Report to Planetary Energy Suplemmentation Agency</u><BR>\
	-Conduct mandatory wellness checks on team members<BR>\
	-File the start attempt in the Reactor Logbook<BR>\
	-Lock all doors and ensure lack of tresspassers<BR>\
	<BR>\
	-PRE FEED START-<BR>\
	-T-PRES-CONTROL to 4ATM<BR>\
	-T-CP 1V-IN to OPEN<BR>\
	-T-FEEDWATER-CP MAKEUP to IDLE<BR>\
	WAIT 10s<BR>\
	-T-FEEDWATER V-MAKEUP to OPEN<BR>\
	WAIT 15s<BR>\
	-T-FEEDWATER V-MAKEUP to CLOSED<BR>\
	-T-CP 1 MODE to IDLE<BR>\
	AFTER T-CP 1 RPM > 300<BR>\
	-T-CP 1V-OUT to OPEN<BR>\
	VERIFY T-FEEDWATER FLOW > 150kgs<BR>\
	<BR>\
	-FEED START-<BR>\
	-F-PREHEAT to START<BR>\
	AFTER F-M CHAMBER > 3700K<BR>\
	-F-CP 1V-IN to OPEN<BR>\
	-F-CP 1 MODE to IDLE<BR>\
	AFTER F-CP 1 RPM > 70<BR>\
	-F-CP 1V-OUT to OPEN<BR>\
	-REACTOR-F-V-IN to OPEN<BR>\
	-REACTOR-F-V-OUT to OPEN<BR>\
	VERIFY REACTOR CHAMBER TEMPERATURE RISING<BR>\
	VERIFY F-FLOW > 40kgs<BR>\
	TURB V-BYPASS to OPEN<BR>\
	-HEATEXCHANGER V-IN to OPEN 10%<BR>\
	CONTROL HEAT EXCHANGER GAS PRESSURE<BR>\
	<BR>\
	-TURBINE START-<BR>\
	-T-TURB TURNING GEAR to 20RPM<BR>\
	AFTER T-MAIN-PRES  > 3000kPa<BR>\
	-TURB 1V-IN to OPEN 10%<BR>\
	-TURB 2V-IN to OPEN 10%<BR>\
	ADJUST TURBINE EXPANSION RATIO<BR>\
	<BR>\
	-PRE IGNITION-<BR>\
	-F-CP 1 MODE to MAX<BR>\
	-LAS-OMODE to IGNITION<BR>\
	-LAS-NMODE to BOMBARDMENT<BR>\
	VERIFY LASER CAPACITOR CHARGE<BR>\
	<u>REQUEST CLEARANCE FROM FESS</u><BR>\
	<BR>\
	-IGNITION-<BR>\
	-LAS-ARM to ARMED<BR>\
	-REACTOR-PREBURN START<BR>\
	-FUEL V-MAIN to 1%<BR>\
	-MOD V-TARG to 3ATM<BR>\
	WAIT 13s<BR>\
	-LAS-PRIMER to PRIME<BR>\
	VERIFY FUSION START<BR>\
	<BR>\
	-AFTER IGNITION-<BR>\
	PUMPS AND VALVES AS NECESSARY<BR>\
	-LAS-OMODE to CONTINUOUS<BR>\
	-LAS-NMODE to MODERATION<BR>\
	-T-TURB TURNING GEAR to OFF<BR>\
	-HE V-IN to OPEN 40%<BR>\
	-HE V-OUT to OPEN 95%<BR>\
	-F-PREHEAT to OFF<BR>\
	ADJUST TURBINE EXPANSION RATIO<BR>\
	<BR>\
	-AFTER START-<BR>\
	-Assume normal operation<BR>\
	-Unlock doors<BR>\
	-Check computer systems integrity<BR>"
