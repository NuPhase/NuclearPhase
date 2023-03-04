/obj/item/chems/fuel_cell
	name = "fuel cell"
	desc = "Is it drinkable?"
	icon = 'icons/obj/fuel_rods.dmi'
	icon_state = "cell"
	w_class = ITEM_SIZE_LARGE
	volume = 600
	var/sealed = FALSE
	var/list/initial_reagents

/obj/item/chems/fuel_cell/Initialize()
	. = ..()
	if(LAZYLEN(initial_reagents))
		for(var/R in initial_reagents)
			reagents.add_reagent(R, initial_reagents[R])

/obj/machinery/reactor_fuelport
	name = "fuel port"
	desc = "A special hole for putting lubricated stuff into."
	icon = 'icons/obj/antimatter.dmi'
	icon_state = "control_on"
	anchored = 1
	density = 1
	var/obj/item/chems/fuel_cell/inserted = null

/obj/machinery/reactor_fuelport/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/chems/fuel_cell))
		if(!inserted)
			if(!do_after(user, 5 SECONDS, I))
				return
			inserted = I
			user.drop_from_inventory(inserted, src)
			playsound(loc, 'sound/machines/fuelportinsert.ogg', 50)
			spawn(20)
				playsound(loc, 'sound/machines/fuelportlock.ogg', 50)
	. = ..()

/obj/machinery/reactor_fuelport/physical_attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!inserted)
		return
	if(!do_after(user, 10 SECONDS, src))
		return
	user.put_in_hands(inserted)
	inserted = null
	playsound(loc, 'sound/machines/fuelportunlock.ogg', 50)