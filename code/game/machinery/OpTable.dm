/obj/structure/optable
	name = "operating table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table"
	density = 1
	anchored = 1
	throwpass = 1
	mob_offset = 5

	var/mob/living/victim
	var/strapped = 0.0

/obj/structure/optable/examine(mob/user)
	. = ..()

/obj/structure/optable/attackby(var/obj/item/O, var/mob/user)
	if (istype(O, /obj/item/grab))
		var/obj/item/grab/G = O
		if(isliving(G.affecting) && check_table(G.affecting))
			take_victim(G.affecting,usr)
			qdel(O)
			return
	return ..()

/obj/structure/optable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	. = (air_group || height == 0 || (istype(mover) && mover.checkpass(PASS_FLAG_TABLE)))

/obj/structure/optable/receive_mouse_drop(atom/dropping, mob/user)
	. = ..()
	if(!.)
		if(istype(dropping, /obj/item) && user.get_active_hand() == dropping && user.unEquip(dropping, loc))
			return FALSE
		if(isliving(dropping) && check_table(dropping))
			take_victim(dropping, user)
			return FALSE

/obj/structure/optable/proc/check_victim()
	if(!victim || !victim.lying || victim.loc != loc)
		victim = null
		for(var/mob/living/carbon/human/H in loc)
			if(H.lying)
				victim = H
				break
	. = !!victim

/obj/structure/optable/Process()
	check_victim()

/obj/structure/optable/proc/take_victim(mob/living/target, mob/living/user)
	if (target == user)
		user.visible_message( \
		SPAN_NOTICE("\The [user] climbs on \the [src]."), \
		SPAN_NOTICE("You climb on \the [src]."))
	else
		visible_message(SPAN_NOTICE("\The [target] has been laid on \the [src] by \the [user]."))
	target.resting = 1
	target.dropInto(loc)
	add_fingerprint(user)

/obj/structure/optable/climb_on()
	if(usr.stat || !ishuman(usr) || usr.restrained() || !check_table(usr))
		return
	take_victim(usr,usr)

/obj/structure/optable/proc/check_table(mob/living/patient)
	check_victim()
	if(src.victim && get_turf(victim) == get_turf(src) && victim.lying)
		to_chat(usr, "<span class='warning'>\The [src] is already occupied!</span>")
		return FALSE
	if(patient.buckled)
		to_chat(usr, "<span class='notice'>Unbuckle \the [patient] first!</span>")
		return FALSE
	if(patient.anchored)
		return FALSE
	return TRUE