/datum/facility_ai/proc/add_server(obj/machinery/ai_server/target)
	servers += target
	computational_power = check_all_servers()

/datum/facility_ai/proc/remove_server(obj/machinery/ai_server/target)
	servers -= target
	computational_power = check_all_servers()

// Returns the server corruption ratio (0-1)
/datum/facility_ai/proc/get_server_corruption(obj/machinery/ai_server/target)
	return target.corruption

// Whether the server has power
/datum/facility_ai/proc/check_server(obj/machinery/ai_server/target)
	return target.powered()

// Returns the amount of server power available and updates server_corruption.
/datum/facility_ai/proc/check_all_servers()
	var/working_servers = 0
	server_corruption = 0
	for(var/obj/machinery/ai_server/target in servers)
		server_corruption += target.corruption / length(servers)
		if(check_server(target))
			working_servers++
	return working_servers * COMP_POWER_PER_SERVER