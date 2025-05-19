/obj/machinery/defibrillator
	name = "manual external defibrillator"
	desc = "A very expensive and fragile device that is capable of defibrillation, cardioversion and heart pacing."
	icon = 'icons/obj/medicine.dmi'
	icon_state = "defib_deployed"
	var/mode = "Defibrillation" //defibrillation, cardioversion, pacing

	var/joule_setting = 240

	var/shock_charged = FALSE

	var/pace_rate = 60
	var/pace_sync = FALSE
	var/pacing = FALSE

	var/obj/item/clothing/under/electrode_pads/pads = new
	var/datum/beam/connection_beam

	var/list/options = list()

/obj/machinery/defibrillator/Destroy()
	. = ..()
	QDEL_NULL(connection_beam)

/obj/machinery/defibrillator/Process()
	if(pacing && pace_sync && pads)
		var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(pads.attached, BP_HEART)
		heart.external_pump += pace_rate
		playsound(get_turf(src), "bodyfall", 25, 1)

/obj/machinery/defibrillator/proc/announce(var/message)
	visible_message(SPAN_NOTICE("The defibrillator states: '[message]'"))

/obj/machinery/defibrillator/proc/deliver_shock(mob/user)
	if(!pads)
		announce("Resistance threshold met, check the pads connection.")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		shock_charged = FALSE
		return
	if(!pads.attached)
		announce("Unable to administer shock, check connection to the patient.")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		shock_charged = FALSE
		return
	if(!user.skill_check(SKILL_MEDICAL, SKILL_BASIC))
		to_chat(user,"<span class='warning'>You don't know what to do with it!</span>")
		return

	visible_message("<span class='danger'>\The [src] weeps: STAND BACK FROM THE PATIENT!</span>")
	sleep(10)
	pads.attached.visible_message("<span class='warning'>\The [pads.attached]'s body convulses violently!</span>")
	playsound(get_turf(src), "bodyfall", 50, 1)
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 1, -1)
	pads.attached.apply_damage(rand(5, 10), BURN, BP_CHEST)
	playsound(get_turf(src), 'sound/machines/defib_success.ogg', 50, 0)
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(pads.attached, BP_HEART)
	heart.pulse = rand(15, 40)
	heart.cardiac_output_modifiers["defibrillation"] = 3
	heart.instability = max(heart.instability - rand(150, 240), 0)
	heart.cardiac_stress = max(heart.cardiac_stress - rand(50, 100))
	for(var/decl/arrythmia/A in heart.arrythmias)
		if(A.can_be_shocked && prob(95))
			heart.arrythmias.Remove(A)
	shock_charged = FALSE
	pads.attached.srec_dose *= 1.1
	log_and_message_admins("used \a [src] to electrocute [key_name(pads.attached)].")

/obj/machinery/defibrillator/proc/charge(mob/user)
	user.visible_message("<span class='notice'>\The [user] charges [src].</span>", "<span class='notice'>You charge the [src].</span>")
	playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)
	spawn(20)
		shock_charged = TRUE
		announce("Unit charged. Please administer shock.")

/obj/machinery/defibrillator/proc/cardiovert()
	if(!pads)
		announce("Resistance threshold met, check the pads connection.")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		shock_charged = FALSE
		return
	if(!pads.attached)
		announce("Unable to administer shock, check connection to the patient.")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		shock_charged = FALSE
		return

	visible_message("<span class='warning'>\The [src] weeps: STAND BACK FROM THE PATIENT!</span>")
	sleep(20)
	pads.attached.visible_message("<span class='notice'>\The [pads.attached]'s body convulses slightly.</span>")
	playsound(get_turf(src), "bodyfall", 50, 1)
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 1, -1)
	pads.attached.apply_damage(rand(1, 5), BURN, BP_CHEST)
	playsound(get_turf(src), 'sound/machines/defib_success.ogg', 50, 0)
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(pads.attached, BP_HEART)
	heart.pulse = rand(55, 65)
	heart.instability = max(heart.instability -= rand(70, 170), 0)
	heart.cardiac_stress = max(heart.cardiac_stress - rand(20, 50))
	shock_charged = FALSE
	pads.attached.srec_dose *= 1.1
	for(var/decl/arrythmia/A in heart.arrythmias)
		if(!A.can_be_shocked && prob(95))
			heart.arrythmias.Remove(A)

/obj/machinery/defibrillator/proc/change_pacing_rate(mob/user)
	var/pace_rate_new = input(user, "Select a pacing rate in beats per minute", "Pacing rate") as null|num
	pace_rate = clamp(pace_rate_new, 1, 300)
	user.visible_message("<span class='notice'>\The [user] changed the pacing rate of [src] to [pace_rate].</span>", "<span class='warning'>You change the pace rate of [src] to [pace_rate].</span>")

/obj/machinery/defibrillator/proc/sync_pacer()
	announce("Beginning pacer synchronization...")
	playsound(get_turf(src), 'sound/machines/defib_safetyOff.ogg', 50, 0)
	sleep(rand(20, 100))
	announce("Pacer synchronization complete. Automatic pacing startup...")
	playsound(get_turf(src), 'sound/machines/defib_SafetyOn.ogg', 50, 0)
	pace_sync = TRUE
	sleep(10)
	pacing = TRUE
	announce("Pacing starting at a rate of [pace_rate].")
	playsound(get_turf(src), 'sound/machines/defib_success.ogg', 50, 0)

/obj/machinery/defibrillator/proc/switch_mode(mob/user)
	var/new_mode = input(user, "Which mode to switch to?", "Mode switching") as null|anything in list("Defibrillation", "Cardioversion", "Pacing")
	if(!new_mode)
		return

	shock_charged = FALSE
	pacing = FALSE
	pace_sync = FALSE
	mode = new_mode
	announce("Mode switched to: [new_mode].")
	playsound(get_turf(src), 'sound/machines/defib_ready.ogg', 50, 0)

/obj/machinery/defibrillator/proc/detach_pads(mob/user)
	if(pads.taken_out)
		return
	pads.forceMove(src.loc)
	pads = null
	user.visible_message("<span class='notice'>\The [user] removes the [src] pads.</span>", "<span class='warning'>You remove the defibrillator pads.</span>")
	playsound(get_turf(src), 'sound/machines/defib_safetyOff.ogg', 50, 0)
	QDEL_NULL(connection_beam)

/obj/machinery/defibrillator/attack_hand(mob/user)
	. = ..()
	if(pads && pads.taken_out == FALSE)
		pads.taken_out = TRUE
		pads.loc = user.loc
		user.put_in_active_hand(pads)
		user.visible_message("<span class='notice'>\The [user] takes out the [src] pads.</span>", "<span class='warning'>You take out the defibrillator pads.</span>")
		connection_beam = Beam(pads, "1-full", time = INFINITY, beam_color = COLOR_BLUE_LIGHT)
		return

	options.Cut()
	options += "Switch mode"
	if(pads)
		options += "Disconnect pads"
	switch(mode)
		if("Defibrillation")
			if(shock_charged)
				options += "Deliver shock"
			else
				options += "Charge for shock"
		if("Cardioversion")
			if(shock_charged)
				options += "Cardiovert"
			else
				options += "Charge for shock"
		if("Pacing")
			options += "Change pacing rate"
			if(!pace_sync)
				options += "Synchronize pacer"
			if(pacing)
				options += "Stop pacing"
			if(!pacing && pace_sync)
				options += "Start pacing"
	var/setting = tgui_input_list(user, "What to do?", "MED", options)
	switch(setting)
		if("Deliver shock")
			deliver_shock(user)
		if("Charge for shock")
			charge(user)
		if("Cardiovert")
			cardiovert()
		if("Change pacing rate")
			change_pacing_rate(user)
		if("Synchronize pacer")
			sync_pacer()
		if("Stop pacing")
			pacing = FALSE
			announce("Pacer shutdown, re-synchronization required.")
			pace_sync = FALSE
		if("Start pacing")
			pacing = TRUE
			announce("Pacing starting at a rate of [pace_rate].")
		if("Switch mode")
			switch_mode(user)
		if("Disconnect pads")
			detach_pads(user)

/obj/machinery/defibrillator/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/clothing/under/electrode_pads))
		var/obj/item/clothing/under/electrode_pads/P = W
		if(P == pads)
			if(ismob(pads.loc))
				var/mob/M = pads.loc
				if(M.drop_from_inventory(pads, src))
					to_chat(user, "<span class='notice'>\The [pads] snap back into the main unit.</span>")
					playsound(get_turf(src), 'sound/machines/defib_safetyOff.ogg', 50, 0)
			else
				pads.forceMove(src)
			P.taken_out = FALSE
			P.attached = null
			QDEL_NULL(connection_beam)
		else
			if(pads)
				pads.forceMove(src.loc)
			pads = P
			user.visible_message("<span class='notice'>\The [user] replaces the [src] pads.</span>", "<span class='warning'>You replace the defibrillator pads.</span>")
			playsound(get_turf(src), 'sound/machines/defib_safetyOff.ogg', 50, 0)
			QDEL_NULL(connection_beam)
		return
	. = ..()


/obj/item/clothing/under/electrode_pads
	name = "electrode pads"
	desc = "Special single-use sticky pads used for delivering shocks in an emergency."
	icon = 'icons/clothing/suit/defib_paddles.dmi'
	body_parts_covered = null
	var/taken_out = FALSE
	var/mob/living/carbon/human/attached = null

/obj/item/clothing/under/electrode_pads/equipped(mob/user)
	..()
	attached = user

/obj/item/clothing/under/electrode_pads/dropped(mob/user)
	..()
	attached = null

/obj/item/clothing/under/electrode_pads/attack(mob/living/carbon/human/M, mob/living/user, var/target_zone)
	if(istype(M) && user.a_intent == I_HELP)
		var/obj/item/suit = M.get_equipped_item(slot_w_uniform_str)
		if(suit)
			to_chat(user, SPAN_WARNING("Their [suit] is in the way, remove it first!"))
			return 1
		user.visible_message(SPAN_NOTICE("[user] starts fitting [src] onto the [M]'s chest."))

		if(!do_mob(user, M, 2 SECONDS))
			return

		if(user.unEquip(src))
			if(!M.equip_to_slot_if_possible(src, slot_w_uniform_str, del_on_fail=0, disable_warning=1, redraw_mob=1))
				user.put_in_active_hand(src)
			else
				playsound(get_turf(src), 'sound/machines/defib_SafetyOn.ogg', 50, 0)
			return 1
	else
		return ..()