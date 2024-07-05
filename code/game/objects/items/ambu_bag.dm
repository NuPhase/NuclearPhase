/obj/item/intubation_bag
	name = "ambu bag"
	desc = "A pumping bag used in medical environments."
	icon = 'icons/obj/items/ambu_bag.dmi'
	icon_state = ICON_STATE_WORLD
	var/pumping = FALSE
	var/pumping_rate = 20
	matter = list(
		/decl/material/solid/plastic = MATTER_AMOUNT_PRIMARY
	)

/obj/item/intubation_bag/attack(mob/living/M, mob/living/user, target_zone, animate)
	if(!ishuman(M))
		return
	if(pumping)
		. = ..()
		return
	do_pump(M, user)

/obj/item/intubation_bag/attack_self(mob/user)
	var/new_pumping_rate = tgui_input_number(user, "Choose a new pumping rate per minute.", "Pumping Rate", 0, 30, 1, 1 MINUTE)
	pumping_rate = new_pumping_rate

/obj/item/intubation_bag/proc/do_pump(mob/living/M, mob/living/user)
	pumping = TRUE
	if(!do_after(user, 20, M, 0))
		pumping = FALSE
		return
	pumping = FALSE
	var/obj/item/organ/internal/lungs/L = GET_INTERNAL_ORGAN(M, BP_LUNGS)
	var/turf/T = get_turf(user)
	var/datum/gas_mixture/environment = T.return_air()
	L.handle_breath(environment.remove_air_volume(STD_BREATH_VOLUME), pumping_rate)
	do_pump(M, user)