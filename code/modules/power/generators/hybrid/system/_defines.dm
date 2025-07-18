#define MAX_REACTOR_VESSEL_PRESSURE 500000 //kPa
#define ALARM_REACTOR_TUNGSTEN_TEMP 3700
#define MAX_REACTOR_TUNGSTEN_TEMP 3800
#define OPERATIONAL_REACTOR_TUNGSTEN_TEMP 3550

#define OPTIMAL_REACTOR_STEAM_TEMP 1430
#define MAX_REACTOR_STEAM_TEMP 2200
#define OPTIMAL_TURBINE_MASS_FLOW 2500
#define OPTIMAL_TURBINE_PRESSURE 7100
#define OPTIMAL_TURBINE_EXHAUST_TEMP 400

/datum/reactor_control_system
	var/name = "'Velocity' Control System"
	var/mode = REACTOR_CONTROL_MODE_MANUAL
	var/semiautocontrol_available = TRUE
	var/autocontrol_available = FALSE
	var/scram_control = FALSE //should we autoscram?
	var/closed_governor_cycle = FALSE

	var/list/all_messages = list()
	var/list/cleared_messages = list()

	var/list/spinning_lights = list()
	var/list/control_spinning_lights = list() //these are specifically inside the control room and similiar areas
	var/list/radlocks = list()

	var/list/reactor_pumps = list()
	var/list/reactor_meters = list()
	var/list/reactor_valves = list()
	var/list/announcement_monitors = list() //list of monitors we should announce warnings on
	var/obj/machinery/atmospherics/binary/turbinestage/turbine1 = null
	var/obj/machinery/atmospherics/binary/turbinestage/turbine2 = null
	var/obj/machinery/power/generator/turbine_generator/generator1 = null
	var/obj/machinery/power/generator/turbine_generator/generator2 = null
	var/last_message_clearing = 0

	var/decl/control_program/current_running_program //reference to decl

	var/should_alarm = TRUE
	var/pressure_temperature_should_alarm = FALSE

	var/list/unwanted_materials = list(
		/decl/material/gas/oxygen,
		/decl/material/gas/nitrogen,
		/decl/material/solid/caesium,
		/decl/material/solid/metal/nuclear_waste/actinides,
		/decl/material/solid/metal/beryllium
	)

	var/obj/laser_marker
	var/laser_animating = FALSE
	var/obj/neutron_marker

	var/list/pressure_valves_to_check = list(
		"T-COOLANT V-IN",
		"T-COOLANT V-OUT"
	)
	var/list/meters_to_check = list(
		"T-M-TURB IN",
		"T-M-TURB EX",
		"T-M-COOLANT",
		"F-M IN",
		"F-M OUT"
	)

	var/list/operation_log = list()

	var/log_timeout = 30 SECONDS

	//world.time of last related log
	var/last_power_surge_log = 0
	var/last_vibration_log = 0
	var/last_temperature_log = 0
	var/last_pressure_log = 0