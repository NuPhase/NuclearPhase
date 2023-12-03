#define ROBOT_MODE_IDLE "idle"
#define ROBOT_MODE_MOVEMENT "movement"
#define ROBOT_MODE_ASSEMBLE "assemble"
#define ROBOT_MODE_COMBAT "combat"

#define ROBOT_TIMEOUT_TIME 5 MINUTES

/datum/ai/robot
	name = "robot"
	expected_type = /mob/living/silicon/robot

	var/current_mode = ROBOT_MODE_IDLE

	var/last_action_time = 0 //world.time assigned at each action. Used for timeout.
	var/on_delay = FALSE //movement delay

	var/list/target_turf_path = list()

	var/target_turf //for movement, construction
	var/target_obj //for pulling, interacting, etc

/datum/ai/robot/do_process(time_elapsed)
	if(world.time > last_action_time + ROBOT_TIMEOUT_TIME)
		switch_mode(ROBOT_MODE_IDLE)
		return
	switch(current_mode)
		if(ROBOT_MODE_MOVEMENT)
			if(target_turf && get_turf(body) != target_turf)
				if(!length(target_turf_path))
					target_turf_path = AStar(get_turf(body), target_turf, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30)
				if(target_turf_path)
					do_step()
			else
				target_turf_path = null
			if(target_obj && body.Adjacent(target_obj))
				log_action()
				body.try_make_grab(target_obj)
			else
				target_obj = null

/datum/ai/robot/proc/do_step()
	if(!length(target_turf_path))
		return 0
	log_action()
	var/turf/T = target_turf_path[1]
	if(get_turf(body) == T)
		target_turf_path -= T
		return do_step()
	return step_in(T)

/datum/ai/robot/proc/step_in(turf/T)
	if(on_delay)
		return
	on_delay = TRUE
	spawn(body.get_movement_delay())
		on_delay = FALSE
	step_towards(body, T)

/datum/ai/robot/proc/switch_mode(new_mode)
	log_action()
	current_mode = new_mode
	if(new_mode == ROBOT_MODE_IDLE)
		STOP_PROCESSING(SSai, src)
	else
		START_PROCESSING(SSai, src)

/datum/ai/robot/proc/log_action()
	last_action_time = world.time