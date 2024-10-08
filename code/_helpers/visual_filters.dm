// These involve BYOND's built in filters that do visual effects, and not stuff that distinguishes between things.

// All of this ported from TG.
// And then ported to Nebula from Polaris.
/atom
	var/list/filter_data // For handling persistent filters

/proc/cmp_filter_data_priority(list/A, list/B)
	return A["priority"] - B["priority"]

// Defining this for future proofing and ease of searching for erroneous usage.
/image/proc/add_filter(filter_name, priority, list/params)
	filters += filter(arglist(params))

/atom/proc/add_filter(filter_name, priority, list/params)
	var/list/p = params.Copy()
	p["priority"] = priority
	LAZYSET(filter_data, filter_name, p)
	update_filters()

/atom/proc/update_filters()
	filters = null
	filter_data = sortTim(filter_data, /proc/cmp_filter_data_priority, TRUE)
	for(var/f in filter_data)
		var/list/data = filter_data[f]
		var/list/arguments = data.Copy()
		arguments -= "priority"
		filters += filter(arglist(arguments))

/atom/movable/update_filters()
	. = ..()
	UPDATE_OO_IF_PRESENT

/atom/proc/get_filter(filter_name)
	var/filter_index = filter_data?.Find(filter_name)
	if(filter_index > 0 && filter_index <= length(filters))
		return filters[filter_index]

// Polaris Extensions
/atom/proc/remove_filter(filter_name)
	var/thing = get_filter(filter_name)
	if(thing)
		LAZYREMOVE(filter_data, filter_name)
		filters -= thing
		update_filters()

/// Animate a given filter on this atom. All params after the first are passed to animate().
/atom/proc/animate_filter(filter_name, list/params)
	if (!filter_data || !filter_data[filter_name])
		return

	var/list/monkeypatched_params = params.Copy()
	monkeypatched_params.Insert(1, null)
	var/index = filter_data.Find(filter_name)

	// First, animate ourselves.
	monkeypatched_params[1] = filters[index]
	animate(arglist(monkeypatched_params))
	return monkeypatched_params
	// If we're being copied by Z-Mimic, update mimics too.

/atom/movable/animate_filter(filter_name, list/params)
	. = ..()
	var/index = filter_data.Find(filter_name)
	if (bound_overlay)
		for (var/atom/movable/AM as anything in get_above_oo())
			.[1] = AM.filters[index]
			animate(arglist(.))