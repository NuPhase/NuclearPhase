/decl/ai_module/interact_with_objects
	submodules = list(
					/decl/ai_module/interaction_door,
					/decl/ai_module/interaction_closet
					)

/decl/ai_module/interact_with_objects/process(datum/ai/parent)
	if(ismob(parent.target))
		return TRUE // we're chasing
	if(get_dist(parent.body, parent.target) > 1)
		return TRUE

	for(var/module in submodules)
		var/decl/ai_module/cur_module = GET_DECL(module)
		cur_module.process(parent)
	return TRUE

// Try to open a door, breach it if not possible.
/decl/ai_module/interaction_door/process(datum/ai/parent)
	if(istype(parent.target, /obj/machinery/door))
		var/obj/machinery/door/D = parent.target
		if(D.operating && D.allowed(parent.body) && D.can_operate(parent.body))
			D.open()
			parent.target = null
			return TRUE
		else // СЛОМАЙ ДВЕРЬ СУКА.
			parent.attack(D)
			return TRUE
	else if(istype(parent.target, /obj/structure/door))
		var/obj/structure/door/SD = parent.target
		if(SD.open(parent.body))
			parent.target = null
			return TRUE
		else // СЛОМАЙ ДВЕРЬ СУКА.
			parent.attack(SD)
			return TRUE
	return TRUE

/decl/ai_module/interaction_closet/process(datum/ai/parent)
	if(istype(parent.target, /obj/structure/closet))
		var/obj/structure/closet/C = parent.target
		C.open()
		parent.target = null
		return TRUE
	return TRUE