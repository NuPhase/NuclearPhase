/datum/ai/human/hostile
	name = "hostile human"
	processing_modules = list(
		/decl/ai_module/find_target_ff,
		/decl/ai_module/find_path,
		/decl/ai_module/interact_with_objects,
		/decl/ai_module/combat/ranged,
		/decl/ai_module/search_room
	)
