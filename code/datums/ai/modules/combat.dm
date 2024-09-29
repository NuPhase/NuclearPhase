/decl/ai_module/combat/process(datum/ai/parent)
	if(!(parent.mob_target in oview(1, parent.body)))
		return TRUE
	parent.attack(parent.mob_target)