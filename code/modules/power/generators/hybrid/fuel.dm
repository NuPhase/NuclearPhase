/obj/item/chems/fuel_cell
	name = "fuel cell"
	desc = "An unique container for fuel with built-in divertors for filtering."
	icon = 'icons/obj/fuel_rods.dmi'
	icon_state = "cell"
	w_class = ITEM_SIZE_LARGE
	volume = 2000
	var/sealed = FALSE
	var/list/initial_reagents
	weight = 12

/obj/item/chems/fuel_cell/Initialize()
	. = ..()
	if(LAZYLEN(initial_reagents))
		for(var/R in initial_reagents)
			reagents.add_reagent(R, initial_reagents[R])

/obj/item/chems/fuel_cell/deuterium_tritium
	name = "D-T fuel cell"
	desc = "This fuel cell contains a simple D-T fuel mixture. You are boring."
	initial_reagents = list(
		/decl/material/gas/hydrogen/deuterium = 1600,
		/decl/material/gas/hydrogen/tritium = 400
	)

/obj/item/chems/fuel_cell/hydrogen
	name = "H2 fuel cell"
	desc = "This fuel cell contains purely hydrogen, like in the cores of juvenile stars."
	initial_reagents = list(
		/decl/material/gas/hydrogen = 2000
	)

/obj/item/chems/fuel_cell/helium3
	name = "3He2 fuel cell"
	desc = "This fuel cell contains an isotope of helium, an extremely potent fusion fuel. Good luck igniting it, though."
	initial_reagents = list(
		/decl/material/gas/helium/isotopethree = 2000
	)

/obj/item/chems/fuel_cell/fissionclassic
	name = "U_235-Pu fuel cell"
	desc = "This fuel cell contains fissilable uranium and highly fissile plutonium mixed with xenon for safety."
	initial_reagents = list(
		/decl/material/solid/metal/uranium = 1500,
		/decl/material/solid/metal/plutonium = 500
	)

/obj/item/chems/fuel_cell/fissionbreeder
	name = "U_238 fuel cell"
	desc = "This fuel cell contains an almost useless isotope of uranium. Best used in tandem with fusion."
	initial_reagents = list(
		/decl/material/solid/metal/depleted_uranium = 2000
	)

/obj/machinery/reactor_fuelport
	name = "fuel port"
	desc = "A special hole for putting lubricated stuff into."
	icon = 'icons/obj/antimatter.dmi'
	icon_state = "control_on"
	anchored = 1
	density = 1
	var/obj/item/chems/fuel_cell/inserted = null
	var/sealed = FALSE
	var/melted = FALSE
	var/injection_ratio = 0 //0-0.001

/obj/machinery/reactor_fuelport/examine(mob/user)
	. = ..()
	if(inserted)
		if(sealed)
			to_chat(user, SPAN_NOTICE("It is soundly locked with a fuel cell in it."))
		else
			to_chat(user, SPAN_WARNING("It is unlocked and has a fuel cell in it."))
		to_chat(user, SPAN_NOTICE("Its volume gauge is at [inserted.reagents.total_volume / inserted.reagents.maximum_volume * 100]%."))

/obj/machinery/reactor_fuelport/Process()
	if(!inserted || !sealed)
		return

	var/obj/machinery/power/hybrid_reactor/reactor = reactor_components["core"]
	var/datum/gas_mixture/core_environment = reactor.loc.return_air()

	if(inserted.reagents.total_volume != inserted.reagents.maximum_volume) //we're not full of sticky white liquid some engineer left in us
		for(var/g in core_environment.gas)
			if(g in rcontrol.unwanted_materials)
				var/removed = core_environment.gas[g] * 0.1 + 0.1
				core_environment.adjust_gas(g, removed * -1)
				inserted.reagents.add_reagent(g, removed * REAGENT_UNITS_PER_GAS_MOLE)

	if(!injection_ratio)
		return
	var/removing = inserted.reagents.total_volume * injection_ratio
	var/adding_gas = removing / REAGENT_UNITS_PER_GAS_MOLE
	for(var/moving in inserted.reagents.reagent_volumes)
		core_environment.adjust_gas(moving, adding_gas)
		inserted.reagents.remove_reagent(moving, removing)

/obj/machinery/reactor_fuelport/Initialize()
	. = ..()
	reactor_components[uid] = src

/obj/machinery/reactor_fuelport/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/chems/fuel_cell))
		if(!inserted)
			if(!do_after(user, 5 SECONDS, I))
				return
			inserted = I
			user.drop_from_inventory(inserted, src)
			playsound(loc, 'sound/machines/fuelportinsert.ogg', 50)
		return
	if(IS_WELDER(I))
		if(melted)
			var/obj/item/weldingtool/WT = I
			if(!WT.isOn())
				to_chat(user, "<span class='notice'>The welding tool needs to be of any use here.</span>")
				return
			visible_message(SPAN_DANGER("[user] starts cutting through [src]'s locking mechanism with the [I]!"))
			playsound(src, 'sound/items/Welder.ogg', 50, 1)
			if(!do_after(user, 5 SECONDS, src))
				return
			visible_message(SPAN_DANGER("[user] cuts through [src]'s locking mechanism with the [I]!"))
			melted = FALSE
			playsound(src, 'sound/items/Welder2.ogg', 50, 1)
		return
	. = ..()

/obj/machinery/reactor_fuelport/physical_attack_hand(mob/living/carbon/human/user)
	. = ..()
	try_handle_interactions(user, get_alt_interactions(user))

/obj/machinery/reactor_fuelport/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/fuelport_remove)
	if(sealed)
		LAZYADD(., /decl/interaction_handler/fuelport_unlock)
	else
		LAZYADD(., /decl/interaction_handler/fuelport_lock)

/decl/interaction_handler/fuelport_unlock
	name = "Unlock Fuel Cell"
	expected_target_type = /obj/machinery/reactor_fuelport

/decl/interaction_handler/fuelport_unlock/invoked(obj/machinery/reactor_fuelport/target, mob/user)
	if(target.melted)
		to_chat(user, SPAN_WARNING("\The [target] locking mechanisms are melted shut, you'll have to cut through them!"))
		return
	if(!do_after(user, 5 SECONDS, target))
		return
	playsound(target.loc, 'sound/machines/fuelportunlock.ogg', 50)
	target.sealed = FALSE
	target.visible_message(SPAN_NOTICE("[user] unlocks \the [target]."))

/decl/interaction_handler/fuelport_lock
	name = "Lock Fuel Cell"
	expected_target_type = /obj/machinery/reactor_fuelport

/decl/interaction_handler/fuelport_lock/invoked(obj/machinery/reactor_fuelport/target, mob/user)
	if(!target.inserted)
		to_chat(user, SPAN_WARNING("\The [target] doesn't have a fuel cell in it!"))
		return
	if(!do_after(user, 2 SECONDS, target))
		return
	playsound(target.loc, 'sound/machines/fuelportlock.ogg', 50)
	target.sealed = TRUE
	target.visible_message(SPAN_NOTICE("[user] locks \the [target]."))

/decl/interaction_handler/fuelport_remove
	name = "Remove Fuel Cell"
	expected_target_type = /obj/machinery/reactor_fuelport
	icon = 'icons/obj/fuel_rods.dmi'
	icon_state = "cell"

/decl/interaction_handler/fuelport_remove/invoked(obj/machinery/reactor_fuelport/target, mob/user)
	if(!target.inserted)
		to_chat(user, SPAN_WARNING("\The [target] doesn't have a fuel cell in it!"))
		return
	if(target.sealed)
		to_chat(user, SPAN_WARNING("\The [target] is locked!"))
		return
	if(!do_after(user, 3 SECONDS, target))
		return
	user.put_in_hands(target.inserted)
	target.inserted = null