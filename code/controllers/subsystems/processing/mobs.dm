PROCESSING_SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = SS_PRIORITY_MOB
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 2 SECONDS

	process_proc = TYPE_PROC_REF(/mob, Life)

	var/list/mob_list

	//TODO: Autogenerate this in the future. From most unstable to least unstable.
	var/list/arrythmias_sorted_list = list(
		/decl/arrythmia/asystole,
		/decl/arrythmia/ventricular_flaunt,
		/decl/arrythmia/tachycardia,
		/decl/arrythmia/atrial_flaunt
	)

/datum/controller/subsystem/processing/mobs/PreInit()
	mob_list = processing // Simply setups a more recognizable var name than "processing"

/datum/controller/subsystem/processing/mobs/fire(resumed)
	. = ..()
	for(var/mob/living/carbon/human/H in human_mob_list)
		var/area/A = H.lastarea
		if(!A)
			continue
		if(!A.object_ambience)
			A.object_ambience = TRUE
			for(var/obj/O in A.ambient_objects)
				O.start_ambience()