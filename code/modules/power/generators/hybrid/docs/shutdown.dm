/obj/item/paper/reactor/fueling_shutdown
	name = "Refueling Shutdown Checklist"
	info = "\
<center><h3>REFUELING SHUTDOWN</h3></center><BR>\
<center><b>Last revised: (10/01/2206)</b></center><BR>\
<i>Rewritten to accomodate the newest modifications.</i><BR>\
<i>Lines that are <u>underlined</u> should not be executed for unmentioned reasons.</i><BR>\
<BR>\
<BR>\
<BR>\
-FUEL V-MAIN to CLOSED<BR>\
EJECT ALL FUEL CELLS<BR>\
-PURGE IF NECESSARY<BR>\
-CONTROL MODE to SEMI-AUTO<BR>"

/obj/item/paper/reactor/full_shutdown
	name = "Full Shutdown Checklist"
	info = "\
<center><h3>FULL BLACK SHUTDOWN</h3></center><BR>\
<center><b>Last revised: (10/01/2206)</b></center><BR>\
<i>Rewritten to accomodate the newest modifications.</i><BR>\
<i>Lines that are <u>underlined</u> should not be executed for unmentioned reasons.</i><BR>\
<BR>\
<BR>\
<BR>\
-FUEL V-MAIN to CLOSED<BR>\
-PURGE IF NECESSARY<BR>\
-CONTROL MODE to MANUAL<BR>\
<BR>\
-FEED LOOP SHUTDOWN-<BR>\
-REACTOR-F-V-IN to CLOSED<BR>\
-REACTOR-F-V-OUT to CLOSED<BR>\
-F-CP 1V-IN to CLOSED<BR>\
-F-CP 2V-IN to CLOSED<BR>\
-F-CP 1 MODE to OFF<BR>\
-F-CP 2 MODE to OFF<BR>\
-F-CP 1V-OUT to CLOSED<BR>\
-F-CP 2V-OUT to CLOSED<BR>\
<BR>\
-TURBINE SHUTDOWN-<BR>\
-TURB 1V-IN to CLOSED<BR>\
-TURB 2V-IN to CLOSED<BR>\
-TURB 1-GRID to OFF\
-TURB 2-GRID to OFF\
-T-COOLANT V-IN to CLOSED<BR>\
-T-COOLANT V-OUT to CLOSED<BR>\
<BR>\
-TURBINE LOOP SHUTDOWN-<BR>\
-T-CP 1V-IN to CLOSED<BR>\
-T-CP 2V-IN to CLOSED<BR>\
-T-CP 1 MODE to OFF<BR>\
-T-CP 2 MODE to OFF<BR>\
-T-CP 1V-OUT to CLOSED<BR>\
-T-CP 2V-OUT to CLOSED<BR>\
T-FEEDWATER V-DRAIN to OPEN<BR>"