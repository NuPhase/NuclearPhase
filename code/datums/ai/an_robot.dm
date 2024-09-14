/datum/ai/an_robot
	name = "robot"
	expected_type = /mob/living/simple_animal/robot

	processing_modules = list(
		/decl/ai_module/find_target_ff,
		/decl/ai_module/find_path,
		/decl/ai_module/interact_with_objects,
		/decl/ai_module/combat,
		/decl/ai_module/search_room
	)
	faction = "silicon"

/datum/ai/an_robot/attack(atom/A)
	var/mob/living/simple_animal/robot/real_body = body
	body.face_atom(mob_target)
	body.setClickCooldown(15)
	mob_target.attackby(real_body.get_natural_weapon(), real_body)
	return