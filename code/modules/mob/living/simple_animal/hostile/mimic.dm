//
// Abstract Class
//

var/global/list/protected_objects = list(/obj/machinery,
										 /obj/structure/table,
										 /obj/structure/cable,
										 /obj/structure/window,
										 /obj/structure/wall_frame,
										 /obj/structure/grille,
										 /obj/structure/catwalk,
										 /obj/structure/ladder,
										 /obj/structure/stairs,
										 /obj/structure/sign,
										 /obj/structure/railing,
										 /obj/item/modular_computer,
										 /obj/item/projectile/animate)

/mob/living/simple_animal/hostile/mimic
	name = "crate"
	desc = "A rectangular steel crate."
	icon =  'icons/obj/storage/bases/crate.dmi'
	color = COLOR_STEEL
	icon_state = "crate"

	meat_type = /obj/item/chems/food/fish
	speed = 4
	maxHealth = 100
	health = 100

	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite

	min_gas = null
	max_gas = null
	minbodytemp = 0

	faction = "mimic"
	move_to_delay = 8

	var/weakref/copy_of
	var/weakref/creator // the creator
	var/destroy_objects = 0
	var/knockdown_people = 0
	pass_flags = PASS_FLAG_TABLE

/mob/living/simple_animal/hostile/mimic/on_update_icon()
	SHOULD_CALL_PARENT(FALSE)
	if(copy_of && copy_of.resolve())
		appearance = copy_of.resolve()
	else
		icon = initial(icon)
		icon_state = initial(icon_state)

/mob/living/simple_animal/hostile/mimic/Initialize(mapload, var/obj/o, var/mob/living/creator)
	. = ..()
	if(o)
		if(ispath(o))
			o = new o(loc)
		CopyObject(o,creator)

/mob/living/simple_animal/hostile/mimic/FindTarget()
	. = ..()
	if(.)
		audible_emote("growls at [.]")

/mob/living/simple_animal/hostile/mimic/ListTargets(var/dist = 7)
	// Return a list of targets that isn't the creator
	. = ..()
	if(creator)
		. -= creator.resolve()

/mob/living/simple_animal/hostile/mimic/proc/CopyObject(var/obj/O, var/mob/living/creator)

	if((istype(O, /obj/item) || istype(O, /obj/structure)) && !is_type_in_list(O, protected_objects))
		O.forceMove(src)
		copy_of = weakref(O)

		var/obj/item/W = get_natural_weapon()
		if(istype(O, /obj/structure))
			health = (anchored * 50) + 50
			destroy_objects = 1
			if(O.density && O.anchored)
				knockdown_people = 1
				W.force = 2 * initial(W.force)
		else if(istype(O, /obj/item))
			var/obj/item/I = O
			health = 15 * I.w_class
			W.force = 2 + initial(I.force)
			move_to_delay = 2 * I.w_class

		maxHealth = health
		if(creator)
			src.creator = weakref(creator)
			faction = "\ref[creator]" // very unique

		update_icon()
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/mimic/death()
	if(!copy_of)
		return
	var/atom/movable/C = copy_of.resolve()
	..(null, "dies!")
	if(C)
		C.forceMove(src.loc)

		if(istype(C,/obj/structure/closet))
			for(var/atom/movable/M in src)
				M.forceMove(C)

		if(istype(C,/obj/item/storage))
			var/obj/item/storage/S = C
			for(var/atom/movable/M in src)
				if(S.can_be_inserted(M,null,1))
					S.handle_item_insertion(M)
				else
					M.forceMove(src.loc)

		for(var/atom/movable/M in src)
			M.dropInto(loc)
		qdel(src)


/mob/living/simple_animal/hostile/mimic/DestroySurroundings()
	if(destroy_objects)
		..()

/mob/living/simple_animal/hostile/mimic/AttackingTarget()
	. =..()
	if(knockdown_people)
		var/mob/living/L = .
		if(istype(L))
			if(prob(15))
				SET_STATUS_MAX(L, STAT_WEAK, 1)
				L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

/mob/living/simple_animal/hostile/mimic/Destroy()
	copy_of = null
	creator = null
	..()

/mob/living/simple_animal/hostile/mimic/sleeping
	wander = 0
	stop_automated_movement = 1

	var/awake = 0

/mob/living/simple_animal/hostile/mimic/sleeping/ListTargets(var/dist = 7)
	. = awake && ..()

/mob/living/simple_animal/hostile/mimic/sleeping/proc/trigger()
	if(!awake)
		src.visible_message("<b>\The [src]</b> starts to move!")
		awake = 1

/mob/living/simple_animal/hostile/mimic/sleeping/adjustBruteLoss(var/damage)
	trigger()
	..(damage)

/mob/living/simple_animal/hostile/mimic/sleeping/attack_hand()
	trigger()
	..()

/mob/living/simple_animal/hostile/mimic/sleeping/DestroySurroundings()
	if(awake)
		..()