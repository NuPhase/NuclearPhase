/obj/item/paper/reactor/general
	name = "Abbreviations and Codes"
	info = "<center><h3> Common Reactor Abbreviations and Codes</h3></center><BR>\
		V - Valve<BR>\
		EX - Exhaust<BR>\
		IN - Intake<BR>\
		L - Lights<BR>\
		FL - Floodlights<BR>\
		F - Feed loop<BR>\
		T - Turbine loop<BR>\
		CP - Coolant Pump<BR>\
		EP - Emergency Protocol<BR>\
		RPM - Rotations Per Minute<BR>\
		kgs - kg per second<BR>\
		<BR>\
		<BR>\
		<BR>\
		Examples:<BR>\
		F-CP 1V-IN - Feed loop-Coolant Pump 1 Valve-Intake<BR>\
		FL-MAIN - Floodlights-MAIN<BR>"

/obj/item/clipboard/reactor
	name = "personal reactor operations clipboard"
	papers = list(/obj/item/paper/reactor/general)

/obj/item/clipboard/reactor/Initialize()
	. = ..()
	for(var/obj/item/paper/P in papers)
		P = new