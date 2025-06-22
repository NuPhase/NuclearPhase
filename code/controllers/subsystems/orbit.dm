SUBSYSTEM_DEF(orbit)
	name = "Orbit"
	wait = 10 SECONDS
	priority = SS_PRIORITY_ORBIT
	flags = SS_NO_INIT | SS_NO_FIRE
	runlevels = RUNLEVEL_GAME

	var/typhos_area
	var/typhos_reached = FALSE
	var/typhos_destructing = 0

	var/icarus_area
	var/icarus_reached = FALSE
	var/icarus_broken_pylons = list()

/datum/controller/subsystem/orbit/proc/reach_typhos()
	if(typhos_reached)
		return
	typhos_reached = TRUE

/datum/controller/subsystem/orbit/proc/start_typhos_destruction()
	if(typhos_destructing)
		return
	typhos_destructing = TRUE
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos11"), 10 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos12"), 30 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos13"), 60 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos14"), 90 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos15"), 120 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos16"), 150 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos17"), 200 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos18"), 240 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos21"), 300 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos22"), 305 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos23"), 310 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos24"), 315 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos25"), 320 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos26"), 325 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos27"), 330 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos28"), 335 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos29"), 340 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos30"), 345 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos31"), 350 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(typhos_det), "typhos32"), 355 SECONDS)

/datum/controller/subsystem/orbit/proc/typhos_det(id)
	var/obj/effect/scripted_detonation/det = scripted_explosions[id]
	det.trigger()

/datum/controller/subsystem/orbit/proc/can_warp()
	if(length(icarus_broken_pylons))
		return FALSE