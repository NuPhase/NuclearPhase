/obj/item/paper/reactor/reignition
	name = "Fusion Reignition Checklist"
	info = "\
<center><h3>FUSION REIGNITION PROCEDURE</h3></center><BR>\
<center><b>Last revised: (10/01/2206)</b></center><BR>\
<i>Rewritten to accomodate the newest modifications.</i><BR>\
<i>Lines that are <u>underlined</u> should not be executed for unmentioned reasons.</i><BR>\
<BR>\
<BR>\
<BR>\
<u>REQUEST CLEARANCE FROM FESS</u><BR>\
VERIFY BAT CHARGE<BR>\
VERIFY CONTAINMENT STATUS<BR>\
-LAS-ARM to ARMED<BR>\
-LAS-OMODE to IGNITION<BR>\
<u>-REALIGN SHOCK DAMPERS</u><BR>\
<BR>\
-AFTER CAPACITORS CHARGED-<BR>\
-LAR-PRIMER to PRIME<BR>\
<BR>\
-AFTER IGNITION-<BR>\
-LAS-ARM to DISARMED<BR>"

/obj/item/paper/reactor/turbinerunup
	name = "Turbine Runup Checklist"
	info = "\
	<center><h3>TURBINE RUNUP PROCEDURE</h3></center><BR>\
	<center><b>Last revised: (10/01/2206)</b></center><BR>\
	<i>Rewritten to accomodate the newest modifications.</i><BR>\
	<i>Lines that are <u>underlined</u> should not be executed for unmentioned reasons.</i><BR>\
	<BR>\
	<BR>\
	<BR>\
	-START PREPARATIONS-<BR>\
	Verify:<BR>\
	-Steam pressure 6000-7500kPa<BR>\
	-Steam temperature >980K<BR>\
	-Coolant level >80%<BR>\
	At all times during runup, maintain:<BR>\
	-Steam pressure >6000kPa<BR>\
	-Steam temperature >980K<BR>\
	-Turbine exhaust temperature >340K<BR>\
	<BR>\
	-INITIAL RUNUP-<BR>\
	Skip to HOT RUNUP if RPM > 800.<BR>\
	-TURB V-GRATES to OPEN<BR>\
	-TURB V-BYPASS to OPEN<BR>\
	-TURB 1-EXPANSION to 26%<BR>\
	-TURB 1V-IN to 10%<BR>\
	Adjust expansion during runup to maintain an exhaust temperature of 375K<BR>\
	If enabled, autocontrol will do this for you.<BR>\
	Above 200RPM:<BR>\
	-TURB V-BYPASS to CLOSED<BR>\
	-TURB 1V-IN to 50%<BR>\
	Above 800RPM:<BR>\
	-TURB V-GRATES to CLOSED<BR>\
	<BR>\
	-HOT RUNUP-<BR>\
	-TURB 1V-IN to 100%<BR>\
	Above 1800RPM:<BR>\
	-TURB 1-GRID to ON<BR>\
	Adjust inlet valve to maintain an energy balance of 0<BR>\
	If enabled, autocontrol will do this for you.<BR>\
	<BR>\
	"