/decl/control_program
	var/name = "Program One"
	var/code = "P1"

/decl/control_program/proc/initiated()
	return
/decl/control_program/proc/process()
	return
/decl/control_program/proc/abrupted()
	return
/decl/control_program/proc/end()
	return

/decl/control_program/startup
	name = "Cold Startup"
	code = "P11"

/decl/control_program/reignition
	name = "Reignition"
	code = "P12"

/decl/control_program/scram
	name = "Emergency Shutdown"
	code = "P13"

/decl/control_program/shutdown
	name = "Full Shutdown"
	code = "P14"