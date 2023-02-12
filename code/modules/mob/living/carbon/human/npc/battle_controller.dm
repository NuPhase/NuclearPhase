/datum/npc_controller/combat
	var/mob/living/carbon/human/target = null
	var/list/target_path = list()
	var/target_distance
	var/optimal_distance
	var/on_delay = FALSE
	var/attack_on_cooldown = FALSE

/datum/npc_controller/combat/trigger()
	if(owner.stat)
		owner.drop_from_inventory(current_weapon, owner.loc)
		current_weapon = null
		return
	target = null
	for(var/mob/living/carbon/human/potential_target in view(world.view, owner))
		if(potential_target.stat == CONSCIOUS && potential_target.faction != owner.faction)
			target = potential_target
			break
	if(!target)
		return
	if(target.stat)
		target = null
		return
	target_distance = get_dist(owner, target)
	if(!current_weapon)
		optimal_distance = 1
	else if(!get_dist(current_weapon, owner))
		optimal_distance = current_weapon.npc_optimal_distance
	else
		current_weapon = null
		optimal_distance = 1
	if(optimal_distance < target_distance)
		if(!target_path.len || get_turf(target) != target_path[target_path.len])
			target_path = AStar(get_turf(owner), get_turf(target), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30)
		if(target_path)
			do_step()
	else if(optimal_distance > target_distance)
		var/turf/T = get_step_away(owner, target)
		step_in(T)
	if(istype(current_weapon, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/ngun = current_weapon
		if(!ngun.getAmmo())
			owner.drop_from_inventory(current_weapon, owner.loc)
			current_weapon = null
		else
			for(var/mob/living/carbon/human/shooting_target in view(world.view, owner))
				if(shooting_target == target)
					spawn(2)
						ngun.Fire(target, owner)
	else if(target_distance == 1)
		if(!attack_on_cooldown)
			target.default_hurt_interaction(owner)
			attack_on_cooldown = TRUE
			spawn(15)
				attack_on_cooldown = FALSE
	return

/datum/npc_controller/combat/proc/do_step()
	if(!target_path.len)
		return 0
	var/turf/T = target_path[1]
	if(get_turf(owner) == T)
		target_path -= T
		return do_step()

	return step_in(T)

/datum/npc_controller/combat/proc/step_in(turf/T)
	if(on_delay)
		return
	on_delay = TRUE
	spawn(owner.get_movement_delay())
		on_delay = FALSE
	step_towards(owner, T)