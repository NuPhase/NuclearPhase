/decl/ai_module/combat/process(datum/ai/parent)
	if(!(parent.mob_target in oview(1, parent.body)))
		return TRUE
	parent.attack(parent.mob_target)

/decl/ai_module/combat/ranged
	var/engagement_distance = 6

/decl/ai_module/combat/ranged/process(datum/ai/parent)
	return TRUE