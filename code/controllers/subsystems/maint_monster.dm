// Handles maintenance ambience and the monster itself
SUBSYSTEM_DEF(maint_monster)
	name = "Maint Monster"
	wait = 8 SECONDS
	priority = SS_PRIORITY_MONSTER
	init_order = SS_INIT_MONSTER
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	flags = SS_BACKGROUND
	var/list/mobs_to_weight = list()

// The weights are 1-1000
/datum/controller/subsystem/maint_monster/fire(resumed)
	for(var/mob/M in mobs_to_weight)
		var/weight = mobs_to_weight[M]
		var/area/serenity/maintenance/A = get_area(M)
		mobs_to_weight[M] += rand(A.weight_low, A.weight_high)
		if(prob(weight * 0.025) || (weight > 600 && weight < 650))
			play_ambience(M, weight)

/datum/controller/subsystem/maint_monster/proc/play_ambience(mob/M, weight)
	if(weight > 600 && weight < 700)
		M.playsound_local(M, 'sound/ambience/maint/threshold_passed.ogg', 60)
		mobs_to_weight[M] = 700
		return
	if(weight < 900)
		M.playsound_local(M, pick('sound/ambience/maint/spec_amb1.ogg', 'sound/ambience/maint/spec_amb2.ogg', 'sound/ambience/maint/spec_amb3.ogg'), 40)
	else if(weight < 1000)
		M.playsound_local(M, 'sound/ambience/maint/pre_attack.ogg', 60)
	else
		if(prob(50))
			M.playsound_local(M, 'sound/ambience/maint/attack_cancelled.ogg', 40)
			to_chat(M, SPAN_ERP("Huge pressure comes off your shoulders."))
			mobs_to_weight[M] = 200
		else
			attack(M)
	return

/datum/controller/subsystem/maint_monster/proc/attack(mob/M)
	var/turf/picked_turf
	var/list/possible_spawn_turfs = oview(6, M)
	possible_spawn_turfs.Remove(oview(3, M))
	for(var/turf/T in possible_spawn_turfs)
		if(T.density)
			continue
		picked_turf = T
		break
	if(!picked_turf)
		return
	new /mob/living/simple_animal/hostile/maint_monster(picked_turf)
	mobs_to_weight[M] = 200
	M.playsound_local(M, 'sound/ambience/maint/attack.ogg', 50)