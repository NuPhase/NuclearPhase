/obj/machinery/crusher
	name = "delivery chute"
	desc = "A chute for big and small packages alike!"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/atmospherics/pipes/disposal.dmi'
	icon_state = "intake"
	var/list/stored_material = list()

/obj/machinery/crusher/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	. = (get_dir(src, mover) != dir) && ..()

/obj/machinery/crusher/Bumped(var/atom/movable/AM) //Go straight into the chute

	if(istype(AM, /obj/item/projectile) || istype(AM, /obj/effect))
		return

	if(get_dir(src, AM) != dir)
		return

	var/mob/living/L = AM
	if (istype(L) && L.ckey)
		log_and_message_admins("has flushed themselves down \the [src].", L)
	if(istype(AM, /obj))
		var/obj/O = AM
		O.forceMove(src)
	else if(istype(AM, /mob))
		var/mob/M = AM
		M.forceMove(src)

/obj/machinery/crusher/onDropInto(atom/movable/AM)
	return

/obj/machinery/crusher/proc/crush()
	flick("intake-closing", src)
	sleep(10)
	playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
	sleep(5)
	for(var/mob/living/carbon/human/L in src)
		L.emote("scream")
		L.gib(do_gibs = FALSE)
	for(var/obj/structure/S in src)
		S.dump_contents()
		qdel(S)
	for(var/obj/item/I in src)
		destroy_item(I)
	for(var/obj/item/I in src)
		destroy_item(I)
	for(var/obj/item/I in src)
		destroy_item(I)
	var/turf/T = get_turf(src)
	for(var/obj/O in src)
		O.forceMove(T)

/obj/machinery/crusher/proc/eject_materials()
	for(var/mat_type in stored_material)
		var/decl/material/mat = GET_DECL(mat_type)
		var/sheets_produced = floor(stored_material[mat_type] / SHEET_MATERIAL_AMOUNT)
		if(!sheets_produced)
			continue
		SSmaterials.create_object(mat_type, get_turf(src), sheets_produced, mat.default_solid_form)
		stored_material[mat_type] -= sheets_produced * SHEET_MATERIAL_AMOUNT

/obj/machinery/crusher/proc/destroy_item(var/obj/item/thing)
	. = SUBSTANCE_TAKEN_NONE
	for(var/mat in thing.matter)
		var/decl/material/material_def = GET_DECL(mat)
		if(!material_def)
			continue
		var/taking_material = thing.matter[mat]
		if(taking_material <= 0)
			continue
		stored_material[material_def.type] += taking_material
	if(thing.reagents)
		for(var/reagent_type in thing.reagents.reagent_volumes)
			stored_material[reagent_type] += thing.reagents.reagent_volumes[reagent_type]
	thing.dump_contents()
	qdel(thing)

/obj/machinery/crusher/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/crusher_start)
	LAZYADD(., /decl/interaction_handler/crusher_eject)

/decl/interaction_handler/crusher_start
	name = "Start"
	expected_target_type = /obj/machinery/crusher

/decl/interaction_handler/crusher_start/invoked(obj/machinery/crusher/target, mob/user)
	if(!do_after(user, 5, target))
		return
	target.crush()

/decl/interaction_handler/crusher_eject
	name = "Eject"
	expected_target_type = /obj/machinery/crusher

/decl/interaction_handler/crusher_eject/invoked(obj/machinery/crusher/target, mob/user)
	if(!do_after(user, 5, target))
		return
	target.eject_materials()