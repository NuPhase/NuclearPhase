#define NORMAL_NAME "S.C.S." // Sitewide Control System
#define FAULTY_NAME "CERES P.C.D." // Population Control Daemon

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

	var/corruption_level = 0
	var/server_corruption = 0

	var/computational_power = 0
	var/computational_need = list() // /decl/computation_type = amount

	var/list/logs = list()

	var/list/permissions = list()
	var/list/servers = list()

	var/list/worker_drones = list()
	var/list/combat_drones = list()
	var/list/targets = list() // A list of weakref targets for drones to target
	var/agro_level = AGRO_LEVEL_NONE

/datum/facility_ai/New()
	id = rand(100, 999)
	boot()

/datum/facility_ai/Process()
	if(prob(0.33))
		make_random_log() // flavor

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