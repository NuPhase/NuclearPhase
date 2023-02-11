/obj/machinery/chemistry
	var/obj/item/chemical_vessel/chemical_vessel  = new

/obj/machinery/chemistry/Initialize()
	. = ..()

/obj/machinery/chemistry/proc/adjust_volume(new_volume)
	if(!chemical_vessel)
		return
	chemical_vessel.internal.volume = clamp(new_volume, 0.1, 10)
	chemical_vessel.internal.update_values()

/obj/machinery/chemistry/proc/add_energy(energy)
	if(!chemical_vessel)
		return
	chemical_vessel.internal.add_thermal_energy(energy)
	chemical_vessel.internal.update_values()

/obj/item/chemical_vessel
	var/datum/gas_mixture/internal = null
	var/starting_volume = 1
	var/sealed = FALSE
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = @"[5,10,15,25,30]"

/obj/item/chemical_vessel/Initialize(ml, material_key)
	. = ..()
	if(!possible_transfer_amounts)
		src.verbs -= /obj/item/chems/verb/set_amount_per_transfer_from_this

/obj/item/chemical_vessel/Initialize(ml, material_key)
	. = ..()
	internal = new
	internal.holder = src
	internal.volume = starting_volume
	internal.update_values()

/obj/item/chemical_vessel/sealable/attack_hand(mob/user)
	. = ..()
	if(sealed)
		sealed = FALSE
		user.visible_message(SPAN_NOTICE("[user] removes the lid from [src]"))
	else
		sealed = TRUE
		user.visible_message(SPAN_NOTICE("[user] puts a lid on [src]"))

/obj/item/chemical_vessel/verb/set_amount_per_transfer_from_this()
	set name = "Set Transfer Amount"
	set category = "Object"
	set src in range(1)
	var/N = input("How much do you wish to transfer per use?", "Set Transfer Amount") as null|anything in cached_json_decode(possible_transfer_amounts)
	amount_per_transfer_from_this = N

/obj/item/chemical_vessel/proc/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target) // This goes into afterattack
	if(!istype(target))
		return 0

	if(!target.reagents || !target.reagents.total_volume)
		to_chat(user, "<span class='notice'>[target] is empty.</span>")
		return 1

	if(reagents && !REAGENTS_FREE_SPACE(reagents))
		to_chat(user, "<span class='notice'>[src] is full.</span>")
		return 1

	var/trans = target.reagents.trans_to_obj(src, target:amount_per_transfer_from_this)
	to_chat(user, "<span class='notice'>You fill [src] with [trans] units of the contents of [target].</span>")
	return 1