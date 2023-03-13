GLOBAL_GETTER_PROTECTED(connect_whitelist, /datum/whitelist/connection, new)
GLOBAL_GETTER_PROTECTED(job_whitelist, /datum/whitelist/job, new)

#define WHITELIST_ASSOC 1
#define WHITELIST_DATA 2

/datum/whitelist
	var/name = "Meta whitelist"
	var/filename = null
	var/stat = 0

	var/list/datalist = list()
	var/list/assoclist = list()

/datum/whitelist/New()
	. = ..()
	get_from_file()

/datum/whitelist/proc/get_from_file()
	if(!filename)
		return
	switch(stat)
		if(0)
			return
		if(WHITELIST_ASSOC)
			var/list/entries = file2list(filename)
			for(var/entry in entries)
				if(!entry)
					continue
				entry = trim(entry)
				if(!length(entry))
					continue
				var/list/data = splittext(entry, "=")
				var/path = replacetext(data[1], " ", "")
				check_and_place_if_list_dosnt_have_entry(assoclist, path)
				if(!data[2])
					continue
				var/list/users = splittext(data[2], ";")
				for(var/user in users)
					assoclist[path] += ckey(user)
		if(WHITELIST_DATA)
			var/list/entries = file2list(filename)
			for(var/entry in entries)
				if(!entry)
					continue
				entry = trim(entry)
				datalist += ckey(entry)


/datum/whitelist/proc/add_entry(var/value)
	datalist += value

/datum/whitelist/proc/add_assoc_entry(var/key, var/value)
	check_and_place_if_list_dosnt_have_entry(assoclist, key)
	assoclist[key] += value

/datum/whitelist/proc/check_entry(var/key)
	return key in datalist

/datum/whitelist/proc/check_entry_assoc(var/key, var/value)
	return (key in assoclist) ? (value in assoclist[key]) : FALSE

/datum/whitelist/connection
	name = "Connection whitelist"
	filename = "whitelist/join.txt"
	stat = WHITELIST_DATA

/datum/whitelist/job
	name = "Job whitelist"
	filename = "whitelist/jobs.txt"
	stat = WHITELIST_ASSOC

/datum/whitelist/job/check_entry_assoc(var/key, var/value)
	return (key in assoclist) ? (value in assoclist[key]) : TRUE


/client/New()
	var/datum/whitelist/wl = get_global_connect_whitelist()
	if(!wl.check_entry(ckey(key)))
		src << link("https://discord.gg/mgV35Qw7t4")
		qdel(src)

	. = ..()

/client/proc/debug_whitelist()
	set name = "Debug Whitelist"
	set category = "Debug"

	if(!check_rights(R_VAREDIT | R_DEBUG))
		return

	var/datum/whitelist/choosen = input("Select whitelist type") as null|anything in list(get_global_job_whitelist(), get_global_connect_whitelist())
	if(!choosen)
		return
	debug_variables(choosen)
