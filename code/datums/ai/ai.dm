/*
***** ИСТОКИ НУФАЗЫ                                                 ИСТОКИ НУФАЗЫ *****
* На седьмой день bog создал систему ИИ мобов нуфазы;
* И велел бог никогда не ПРИДУМАЙТЕ САМИ СУКА;
* Храни веру всяк сюда входящий, сохрани рассудок перед страшнейшими [REDACTED].
***** ИСТОКИ НУФАЗЫ                                                 ИСТОКИ НУФАЗЫ *****

{P.S. молиться на адрес 2040 Blvd. Marcel-Laurin Unit 280, Montreal, Quebec H4R 1J9}
*/

// Define whichever of these to get debug messages ingame.
#define AI_DEBUG // Main debug
#define AI_DEBUG_MODULES // For modules
#define AI_DEBUG_SUBMODULES

/*
TODO:
Movement:
-Make it follow the target(if not a turf, stay near it)
-Add a bit of randomness to the motion
-Perhaps a panic variable?
Abilities:
-Open or break doors if not possible
-If the target is not visible, start patrolling in its general vicinity. If not found for TARGET_TIMEOUT, reset the target
*/

/datum/ai
	var/name
	var/mob/living/body             // The parent mob we control.
	var/expected_type = /mob/living // Type of mob this AI applies to.
	var/wait_for = 0                // The next time we can process.
	var/run_interval = 1            // How long to wait between processes.
	var/move_to_delay = 3 //delay for the automated movement.
	var/motion_overriden = FALSE

	var/list/processing_modules = list() //Sorted from first to last in execution. Don't suck BBQ
	var/mob/mob_target // An actual mob target to attack
	var/atom/target // A target to walk to
	var/last_seen_mob = 0 // world.time of last mob being assigned to target

	var/faction = "AI" // FF faction

/datum/ai/New(var/mob/living/target_body)
	body = target_body
	if(expected_type && !istype(body, expected_type))
		PRINT_STACK_TRACE("AI datum [type] received a body ([body ? body.type : "NULL"]) of unexpected type ([expected_type]).")
	START_PROCESSING(SSai, src)

/datum/ai/proc/can_process()
	if(!body || ((body.client || body.mind) && !(body.status_flags & ENABLE_AI)))
		return FALSE
	if(wait_for > world.time)
		return FALSE
	if(body.stat == DEAD)
		return FALSE
	return TRUE

/datum/ai/Process()
	if(!can_process())
		return

	var/time_elapsed = wait_for - world.time
	wait_for = world.time + run_interval
	do_process(time_elapsed)

// This is the place to actually do work in the AI.
/datum/ai/proc/do_process(var/time_elapsed)
	if(body.incapacitated())
		return
	motion_overriden = FALSE
	process_modules()
	if(mob_target)
		last_seen_mob = world.time
	if(target)
		if(motion_overriden)
			return
		move_to_target()
	else
		idle()

/datum/ai/proc/process_modules()
	for(var/module in processing_modules)
		var/decl/ai_module/cur_module = GET_DECL(module)
		if(!cur_module.process(src))
			#ifdef AI_DEBUG
			log_error("AI module failed to handle process().")
			#endif
			continue

/datum/ai/proc/move_to_target()
	set waitfor = FALSE
	if(prob(5)) // horrible randomized movement
		step(body, pick(alldirs))
	walk_to(body, target, 1, move_to_delay)

/datum/ai/proc/attack(atom/A)
	to_world("AI attacked [A].")
	return

/datum/ai/proc/idle()
	return

/datum/ai/Destroy()
	STOP_PROCESSING(SSai, src)
	if(body.ai == src) body.ai = null
	body = null
	. = ..()