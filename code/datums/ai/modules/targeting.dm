//This should find our target MOB

/decl/ai_module/find_target_simple/process(datum/ai/parent)
	if(world.time > parent.last_seen_mob + AI_TARGET_TIMEOUT)
		parent.mob_target = null // forget about them
	for(var/mob/living/L in oview(world.view, parent.body))
		if(L == parent.mob_target)
			parent.last_seen_mob = world.time
			return TRUE
		parent.mob_target = L
		parent.last_seen_mob = world.time
		return TRUE

/decl/ai_module/find_target_ff/process(datum/ai/parent)
	if(world.time > parent.last_seen_mob + AI_TARGET_TIMEOUT)
		parent.mob_target = null // forget about them
	for(var/mob/living/L in oview(world.view, parent.body))
		if(L == parent.mob_target)
			parent.last_seen_mob = world.time
			return TRUE
		if(L.faction == parent.faction)
			continue
		parent.mob_target = L
		parent.last_seen_mob = world.time
	return TRUE

/decl/ai_module/find_target_from_list/process(datum/ai/parent) // weakref list
	if(world.time > parent.last_seen_mob + AI_TARGET_TIMEOUT)
		parent.mob_target = null // forget about them
	for(var/mob/living/L in oview(world.view, parent.body))
		if(L == parent.mob_target)
			parent.last_seen_mob = world.time
			return TRUE
		if(!(weakref(L) in parent.target_list))
			continue
		parent.mob_target = L
		parent.last_seen_mob = world.time
		return TRUE
	return FALSE