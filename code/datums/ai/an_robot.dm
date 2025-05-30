/datum/ai/an_robot
	name = "robot"
	expected_type = /mob/living/simple_animal/robot

	processing_modules = list(
		/decl/ai_module/find_target_from_list,
		/decl/ai_module/find_path,
		/decl/ai_module/interact_with_objects,
		/decl/ai_module/combat/ranged,
		/decl/ai_module/search_room
	)
	faction = "silicon"
	var/lethal_mode = FALSE

/datum/ai/an_robot/attack(atom/A)
	if(!lethal_mode)
		return
	var/mob/living/simple_animal/robot/real_body = body
	body.face_atom(mob_target)
	body.setClickCooldown(15)
	mob_target.attackby(real_body.get_natural_weapon(), real_body)
	return

/datum/ai/an_robot/attack_ranged(atom/A)
	if(mob_target.stat != CONSCIOUS)
		return
	var/mob/living/simple_animal/robot/real_body = body
	if(lethal_mode)
		real_body.lethal_rifle.Fire(mob_target, real_body)
	else
		real_body.nonlethal_rifle.Fire(mob_target, real_body)