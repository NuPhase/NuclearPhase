/obj/item/intubation_bag
	name = "intubation bag"
	desc = "A pumping bag used in medical environments."
	icon = 'icons/obj/items/ambu_bag.dmi'
	icon_state = "default"
	var/pumping = FALSE

/obj/item/intubation_bag/attack(mob/living/M, mob/living/user, target_zone, animate)
	if(!ishuman(M))
		return
	if(pumping)
		. = ..()
		return
	do_pump(M, user)

/obj/item/intubation_bag/proc/do_pump(mob/living/M, mob/living/user)
	pumping = TRUE
	if(!do_after(user, 10, M, 0))
		pumping = FALSE
		return
	pumping = FALSE
	var/obj/item/organ/internal/lungs/L = GET_INTERNAL_ORGAN(M, BP_LUNGS)
	var/turf/T = get_turf(user)
	var/datum/gas_mixture/environment = T.return_air()
	L.handle_breath(environment, 1)
	do_pump(M, user)