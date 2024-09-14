/decl/ai_module/search_room
	var/search_chance = 35 // per tick

/decl/ai_module/search_room/process(datum/ai/parent)
	if(!parent.mob_target)
		return TRUE
	if(ismob(parent.target) || isobj(parent.target))
		return TRUE // we're chasing
	if(isturf(parent.target))
		var/turf/T = parent.target
		if(!(parent.body in T.contents))
			return TRUE // We're moving somewhere
	if(!prob(search_chance)) // if not searching actual things, just wander around
		parent.target = get_turf(pick(oview(world.view, parent.body)))
		return TRUE
	var/list/view_contents = oview(world.view, parent.body)
	for(var/obj/structure/closet/our_closet in view_contents)
		if(our_closet.opened || our_closet.locked || our_closet.welded)
			continue
		parent.target = our_closet
		parent.move_to_target()
		return TRUE
	return TRUE