/obj/item/fire_hose
	name = "fire hose"
	icon = 'icons/obj/items/tool/welders/welder_arc.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_HUGE
	var/obj/structure/fire_hydrant_manual/hydrant = null
	weight = 3
	var/last_use = 1.0

/obj/item/fire_hose/Process()
	if(get_dist(src, hydrant) > 15)
		var/mob/living/curloc = loc
		if(ismob(curloc))
			visible_message(SPAN_WARNING("The [src] slips back into the [hydrant], it was pulled too far!"))
			curloc.drop_from_inventory(src, hydrant)
			hydrant.hose_taken = FALSE
			STOP_PROCESSING(SSobj, src)

/obj/item/fire_hose/proc/use_gas()
	if(!hydrant.stored_tank)
		return 0
	var/datum/gas_mixture/takeup = hydrant.stored_tank.air_contents.remove(6)
	if(takeup.total_moles == 6)
		var/datum/gas_mixture/environment = loc.return_air()
		environment.merge(takeup)
		return 1
	return 0

/obj/item/fire_hose/attack(var/mob/living/M, var/mob/user)
	if(user.a_intent == I_HELP)
		if((world.time < src.last_use + 20)) // We still catch help intent to not randomly attack people
			return
		if(!use_gas())
			to_chat(user, SPAN_NOTICE("\The [hydrant] is empty."))
			return

		src.last_use = world.time
		var/datum/reagents/newreg = new(60, src)
		newreg.add_reagent(/decl/material/gas/carbon_dioxide, 60)
		reagents.splash(M, 60)
		qdel(reagents)
		user.visible_message(SPAN_NOTICE("\The [user] sprays \the [M] with \the [src]."))
		playsound(src.loc, 'sound/items/steam_blast.ogg', 75, 1, -3)

		return 1 // No afterattack
	return ..()

/obj/item/fire_hose/afterattack(var/atom/target, var/mob/user, var/flag)
	if(istype(target,/obj/structure/fire_hydrant_manual))
		return
	if (!use_gas())
		to_chat(usr, SPAN_NOTICE("\The [hydrant] is empty."))
		return
	if (world.time < src.last_use + 10)
		return
	src.last_use = world.time
	playsound(src.loc, 'sound/items/steam_blast.ogg', 75, 1, -3)
	addtimer(CALLBACK(src, .proc/do_spray, target), 0)

/obj/item/fire_hose/proc/do_spray(var/atom/Target)
	var/turf/T = get_turf(Target)
	var/per_particle = 20
	for(var/a = 1 to 3)
		if(!src || !use_gas()) return
		var/obj/effect/effect/water/W = new /obj/effect/effect/water(get_turf(src))
		W.create_reagents(per_particle)
		W.reagents.add_reagent(/decl/material/gas/carbon_dioxide, per_particle)
		W.set_color()
		W.set_up(T, 5, 2)



/obj/structure/fire_hydrant_manual
	name = "fire hydrant"
	desc = "A cryogenic fire hydrant. This one is manual and requires tank restocking."
	icon =  'icons/obj/storage/bases/wall.dmi'
	icon_state = "base"
	color = COLOR_NT_RED
	density = 0
	anchored = 1
	var/obj/item/tank/firefighting/stored_tank = new
	var/obj/item/fire_hose/hose = new
	var/hose_taken = FALSE

/obj/structure/fire_hydrant_manual/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	hose.hydrant = src

/obj/structure/fire_hydrant_manual/examine(mob/user, distance)
	. = ..()
	if(stored_tank)
		to_chat(user, SPAN_NOTICE("The gauge shows that there is [round(stored_tank.air_contents.get_mass())]kg of CO2 left."))

/obj/structure/fire_hydrant_manual/attack_hand(mob/user)
	. = ..()
	if(!hose_taken)
		user.put_in_hands(hose)
		hose_taken = TRUE
		playsound(src.loc, 'sound/effects/extout.ogg', 50, 0)
		START_PROCESSING(SSobj, hose)
		return
	if(stored_tank)
		user.put_in_hands(stored_tank)
		visible_message(SPAN_NOTICE("[user] removes the [stored_tank] from [src]."))
		stored_tank = null

/obj/structure/fire_hydrant_manual/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/fire_hose))
		user.drop_from_inventory(O, src)
		hose_taken = FALSE
		to_chat(user, "<span class='notice'>You place \the [O] in [src].</span>")
		playsound(src.loc, 'sound/effects/extin.ogg', 50, 0)
		STOP_PROCESSING(SSobj, hose)
		return
	if(istype(O, /obj/item/tank/firefighting) && !stored_tank)
		user.drop_from_inventory(O, src)
		stored_tank = O
		playsound(loc, 'sound/effects/spray3.ogg', 50)
		to_chat(usr, "<span class='notice'>You insert \the [stored_tank] into the [src].</span>")
		return
	. = ..()