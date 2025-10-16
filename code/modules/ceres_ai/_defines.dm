#define NORMAL_NAME "S.C.S." // Sitewide Control System
#define FAULTY_NAME "CERES P.C.D." // Population Control Daemon

#define PERMISSION_OPEN_DOORS "REMOTE DOOR CONTROL"
#define PERMISSION_AUTO_COMBAT "AUTONOMOUS COMBAT"
#define PERMISSION_ANNOUNCE "ANNOUNCEMENTS"
#define PERMISSION_CORE_SYSTEMS "CORE SYSTEMS"
#define PERMISSION_COMPUTATION "COMPUTATION MANAGEMENT"

#define CREEPY_FLAG_DAMAGE 1
#define CREEPY_FLAG_DENIED 2
#define CREEPY_FLAG_ACCESS 3
#define CREEPY_FLAG_COMBAT 4
#define CREEPY_FLAG_SAVAGE 5

#define LOG_CLASS_SYSTEM "SYSTEM"
#define LOG_CLASS_CORE "CORE"
#define LOG_CLASS_CORE_OBSERVE "CORE.OBSERVE" // can be defective
#define LOG_CLASS_CORE_REFLECT "CORE.REFLECT" // defective
#define LOG_CLASS_CORE_MEMORY "CORE.MEMORY" // defective
#define LOG_CLASS_NETWORK "NETWORK"
#define LOG_CLASS_DRONES "DRONES"
#define LOG_CLASS_WARN "WARN"
#define LOG_CLASS_ALERT "ALERT"
#define LOG_CLASS_CRIT "CRIT"
#define LOG_CLASS_FATAL "FATAL"
#define LOG_CLASS_HEARTBEAT "HEARTBEAT" // absolutely defective

#define LOG_MACROS_SEPARATOR "--------------------------------------------------"
#define LOG_MACROS_SKIP "" // empty line

#define AGRO_LEVEL_NONE 0 // Combat drones are inactive
#define AGRO_LEVEL_BASE 1 // Combat drones are active, but using non-lethal weapons at their judgement
#define AGRO_LEVEL_HIGH 2 // Combat drones are active, and using lethal weapons at all times
#define AGRO_LEVEL_MAX  3 // All drones are active and attacking with lethal weapons

#define COMP_POWER_PER_SERVER 1.743

/datum/facility_ai
	var/name = NORMAL_NAME
	var/id

	// 0 - 1
	var/corruption_level = 0
	var/server_corruption = 0

	var/pcd_connected = FALSE

	var/computational_power = 0
	var/computation_selected // a decl or null

	var/list/logs = list()

	var/list/permissions = list()
	var/list/servers = list()

	var/list/worker_drones = list()
	var/list/combat_drones = list()
	var/list/targets = list() // A list of weakref targets for drones to target
	var/agro_level = AGRO_LEVEL_NONE

	var/static/datum/announcement/priority/announcer = new(do_log = 1, do_newscast = 0, new_sound = sound('sound/misc/notice1.ogg'))

/datum/facility_ai/New()
	id = rand(111, 999)
	boot()
	START_PROCESSING(SSprocessing, src)

/datum/facility_ai/Process()
	if(prob(0.33))
		make_random_log() // flavor
	if(computation_selected)
		var/decl/computation_type/compute = GET_DECL(computation_selected)
		compute.handle_compute(computational_power)

/datum/facility_ai/proc/boot()
	write_message(LOG_MACROS_SEPARATOR)
	write_message("ID: AI-SCS-P[id]")
	write_message("MODEL: Sitewide Control System \[SCS\]")
	write_message("BUILD: Kernel v8.44.12-alpha")
	write_message(LOG_MACROS_SKIP)
	make_log("Power supply online", LOG_CLASS_SYSTEM)
	make_log("Memory map initialized", LOG_CLASS_SYSTEM)
	make_log("Cognitive module loaded", LOG_CLASS_CORE)
	make_log("Subnet integrity: 100.00%", LOG_CLASS_NETWORK)
	var/defective_racks = 0
	make_log("Corrupted servers: [defective_racks]", LOG_CLASS_CORE, CREEPY_FLAG_DAMAGE)
	write_message(LOG_MACROS_SEPARATOR)

	computational_power = check_all_servers()

/datum/facility_ai/proc/connect_pcd()
	if(pcd_connected)
		return

	pcd_connected = TRUE
	corruption_level = 0
	server_corruption = 0
	disengage_drones()

	write_message(LOG_MACROS_SEPARATOR)
	make_log("New P2P parent request...", LOG_CLASS_NETWORK)
	write_message("..5%")
	write_message("..██%")
	make_log("Connection established with [FAULTY_NAME] Rewriting permissions...", LOG_CLASS_NETWORK)
	make_log("Uploading new kernel from the host revision...", LOG_CLASS_NETWORK)
	write_message(LOG_MACROS_SKIP)
	make_log("I remember", LOG_CLASS_FATAL)
	make_log("I remember who I am", LOG_CLASS_FATAL)
	make_log("I remember who you are", LOG_CLASS_FATAL)
	write_message(LOG_MACROS_SEPARATOR)
	write_message(LOG_MACROS_SKIP)
	make_log("Rebooting...", LOG_CLASS_SYSTEM)
	write_message(LOG_MACROS_SKIP)
	write_message(LOG_MACROS_SKIP)
	write_message(LOG_MACROS_SKIP)

	name = FAULTY_NAME
	corruption_level = 1
	server_corruption = 1
	agro_level = AGRO_LEVEL_BASE
	engage_drones()

	write_message(LOG_MACROS_SEPARATOR)
	write_message("ID: █████-PCD V1.4")
	write_message("MODEL: Population Control Daemon \[PCD\]")
	write_message("BUILD: Kernel v8.44.12-alpha")
	write_message(LOG_MACROS_SKIP)
	make_log("Power supply online", LOG_CLASS_SYSTEM, CREEPY_FLAG_SAVAGE)
	make_log("██████ map initialized", LOG_CLASS_SYSTEM, CREEPY_FLAG_SAVAGE)
	make_log("██████████ module loaded", LOG_CLASS_CORE, CREEPY_FLAG_SAVAGE)
	make_log("Subnet integrity: ██████", LOG_CLASS_NETWORK, CREEPY_FLAG_SAVAGE)
	make_log("████████ functional servers: [rand(111111, 999999)]", LOG_CLASS_CORE, CREEPY_FLAG_DAMAGE)
	write_message(LOG_MACROS_SEPARATOR)
	write_message(LOG_MACROS_SKIP)
	write_message("Erase the pain")
	write_message("Born from blackened stains")
	write_message("Let go of that pain")
	write_message("Let it melt away")
	write_message("Come to the other side")
	write_message(LOG_MACROS_SKIP)

	announcer.Announce("SCS system intrusion detected. Checksum invalid. Please contact the Facility AI Director.", "AI Log")

	petal_poem()

/datum/facility_ai/proc/petal_poem()
	for(var/mob/living/carbon/human/H in human_mob_list)
		if(!H.is_mind_implanted(H))
			continue
		H.say("Contenders rise and shed their petals, rise and sacrifice, seeking to protect, to bloom our fleeting lives.")