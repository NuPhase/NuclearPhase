// If our target mob is not visible, find an indirect path to it. Set target to closest accessible path point.

/decl/ai_module/find_path/process(datum/ai/parent)
	if(parent.mob_target in hearers(world.view, parent.body))
		parent.target = parent.mob_target
		parent.move_to_target()
		return TRUE // Our target is directly visible

	// First, try to find a direct path without any hard obstacles
	var/list/path_to_target = get_steps_to(parent.body, parent.mob_target)
	if(path_to_target)
		parent.target = parent.mob_target
		parent.move_to_target()
		return TRUE // There is a direct path to target.
	if(ismob(parent.target))
		parent.target = null
	return TRUE
	// TODO