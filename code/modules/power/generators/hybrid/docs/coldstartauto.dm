/obj/item/paper/reactor/coldstartauto
	name = "Assisted Cold Start Checklist"
	info = "\
	<center><h3>REACTOR ASSISTED COLD START</h3></center><BR>\
	<center><b>Last revised: (10/01/2206)</b></center><BR>\
	<i>Rewritten to accomodate the newest modifications.</i><BR>\
	<i>Lines that are <u>underlined</u> should not be executed for unmentioned reasons.</i><BR>\
	<BR>\
	<BR>\
	<BR>\
	-START PREPARATIONS-<BR>\
	<u>-Report to Planetary Energy Suplemmentation Agency</u><BR>\
	-Conduct a mandatory wellness check on all team members<BR>\
	-Make sure the reactor is fully refueled and ready<BR>\
	-File the start attempt in the Reactor Logbook<BR>\
	-Lock all doors and ensure lack of tresspassers<BR>\
	<BR>\
	-PRE FEED START-<BR>\
	-<u>TURB V-BYPASS to OPEN</u><BR>\
	-T-CP 1V-IN to OPEN<BR>\
	-T-CP 1 MODE to IDLE<BR>\
	WAIT 10S<BR>\
	-T-CP 1V-OUT to OPEN<BR>\
	-T-FEEDWATER-CP MAKEUP to IDLE<BR>\
	WAIT 10s<BR>\
	-T-FEEDWATER V-MAKEUP to OPEN<BR>\
	VERIFY T-FEEDWATER FLOW > 150kgs<BR>\
	    If false:<BR>\
		-T-FEEDWATER-CP MAKEUP to MAX<BR>\
	WAIT UNTIL T-M-TURB IN MASS ~= 1200KG<BR>\
	-T-FEEDWATER V-MAKEUP to CLOSED<BR>\
	<BR>\
	-FEED START-<BR>\
	-T-COOLANT PREHEAT to START<BR>\
	-F-PREHEAT to START<BR>\
	-F-CP 1V-IN to OPEN<BR>\
	-F-CP 1 MODE to IDLE<BR>\
	AFTER F-CP RPM > 70<BR>\
	-F-CP 1V-OUT to OPEN<BR>\
	-REACTOR-F-V-IN to OPEN 100%<BR>\
	-REACTOR-F-V-OUT to OPEN 100%<BR>\
	VERIFY F-FLOW > 40kgs<BR>\
	<BR>\
	-PRE IGNITION-<BR>\
	<u>REQUEST CLEARANCE FROM FESS</u><BR>\
	-LAS-OMODE to IGNITION<BR>\
	-LAS-NMODE to BOMBARDMENT<BR>\
	VERIFY LASER CAPACITOR CHARGE<BR>\
	WAIT 5-7 MINUTES<BR> \
	<BR>\
	-IGNITION-<BR>\
	-FUEL V-MAIN to 1%<BR>\
	-LAS-ARM to ARMED<BR>\
	<u>-REACTOR-PREBURN START</u><BR>\
	WAIT 13s<BR>\
	-LAS-PRIMER to PRIME<BR>\
	VERIFY FUSION START<BR>\
	<BR>\
	-AFTER IGNITION-<BR>\
	-LAS-OMODE to OFF<BR>\
	-LAS-NMODE to MODERATION<BR>\
	-<u>F-PREHEAT to OFF</u><BR>\
	<BR>\
	-TURBINE START-<BR>\
	-T-COOLANT V-IN to OPEN<BR>\
	-T-COOLANT V-OUT to OPEN<BR>\
	-CONTROL MODE to SEMI-AUTO<BR>\
	-TURB 1V-IN to 15%\
	AFTER TURBINE SPEED > 3200RPM<BR>\
	-T-COOLANT PREHEAT to OFF<BR>\
	-TURB 1-GRID to ON<BR>\
	<BR>\
	-AFTER START-<BR>\
	-BATTERY CHARGER to ON<BR>\
	-Assume normal operation<BR>\
	-Unlock doors<BR>\
	-Check computer systems integrity<BR>"
