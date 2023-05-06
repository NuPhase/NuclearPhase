/obj/item/organ/internal/heart
	name = "heart"
	organ_tag = "heart"
	parent_organ = BP_CHEST
	icon_state = "heart-on"
	dead_icon = "heart-off"
	prosthetic_icon = "heart-prosthetic"
	var/pulse = 60
	var/heartbeat = 0
	var/beat_sound = 'sound/effects/singlebeat.ogg'
	var/tmp/next_blood_squirt = 0
	damage_reduction = 0.7
	relative_size = 5
	max_damage = 45
	oxygen_consumption = 0.2
	var/open
	var/external_pump = 0 //simulated beats per minute
	var/cardiac_output = 1
	var/instability = 0
	var/list/arrythmias = list()
	var/list/cardiac_output_modifiers = list()
	var/list/bpm_modifiers = list()
	var/list/stability_modifiers = list()
	var/last_arrythmia_appearance //world time

/obj/item/organ/internal/heart/open
	open = 1

/obj/item/organ/internal/heart/Process()
	if(owner)
		calculate_instability()
		apply_instability()
		get_modifiers()
		handle_pulse()
		bpm_modifiers.Cut()
		cardiac_output_modifiers.Cut()
		stability_modifiers.Cut()
		if(pulse)
			handle_heartbeat()
			if(pulse > 160 && prob(1))
				take_internal_damage(0.5)
			if(pulse > 220 && prob(5))
				take_internal_damage(0.5)
		handle_blood()
	..()

/obj/item/organ/internal/heart/proc/get_modifiers()
	bpm_modifiers["hypoperfusion"] = (1 - owner.get_blood_perfusion()) * 100
	bpm_modifiers["shock"] = owner.shock_stage * 0.3
	for(var/decl/arrythmia/A in arrythmias)
		bpm_modifiers[A.name] = A.get_pulse_mod()
		cardiac_output_modifiers[A.name] = A.cardiac_output_mod

/obj/item/organ/internal/heart/proc/calculate_instability()
	var/ninstability = 0

	if(owner.get_blood_perfusion() < 0.5)
		ninstability += 20
	if(pulse > 250)
		ninstability += 20
	if(cardiac_output < 0.5)
		ninstability += 20
	if(owner.tpvr > 280)
		ninstability += 20

	ninstability += damage * 0.3
	ninstability += oxygen_deprivation * 0.1
	ninstability -= sumListAndCutAssoc(stability_modifiers)
	instability = max(Interpolate(instability, ninstability, 0.1), 0)

/obj/item/organ/internal/heart/proc/apply_instability()
	if(instability > 10)
		for(var/req_A in subtypesof(/decl/arrythmia))
			var/decl/arrythmia/A = GET_DECL(req_A)
			if(A.can_appear(src) && A.required_instability < instability && prob(5))
				add_arrythmia(A)
				break
		for(var/decl/arrythmia/A in arrythmias)
			if(A.evolves_into && (last_arrythmia_appearance + A.evolve_time) > world.time && prob(10))
				add_arrythmia(GET_DECL(A.evolves_into))
				remove_arrythmia(A)

/obj/item/organ/internal/heart/proc/add_arrythmia(var/decl/arrythmia/A)
	for(var/decl/arrythmia/existing_A in arrythmias)
		if(existing_A.severity > A.severity)
			return
		else
			arrythmias -= existing_A
	A.on_spawn(owner)
	last_arrythmia_appearance = world.time
	LAZYDISTINCTADD(arrythmias, A)

/obj/item/organ/internal/heart/proc/remove_arrythmia(var/decl/arrythmia/A)
	arrythmias -= A

/obj/item/organ/internal/heart/proc/handle_pulse()
	if(BP_IS_PROSTHETIC(src))
		pulse = 60	//that's it, you're dead (or your metal heart is), nothing can influence your pulse
		return

	if(pulse)
		var/target_pulse = initial(pulse) + sumListAndCutAssoc(bpm_modifiers)
		pulse = max(Interpolate(pulse, target_pulse, 0.2), 0)
		external_pump = 0

	cardiac_output = initial(cardiac_output) * mulListAndCutAssoc(cardiac_output_modifiers)

/*	//If heart is stopped, it isn't going to restart itself randomly.
	if(pulse == 0)
		return
	else //and if it's beating, let's see if it should
		var/should_stop = prob(instability * 0.05)
		//should_stop = should_stop || prob(max(0, owner.getBrainLoss() - owner.maxHealth * 0.75)) //brain failing to work heart properly
		if(should_stop) // The heart has stopped due to going into traumatic or cardiovascular shock.
			to_chat(owner, "<span class='danger'>Your heart has stopped!</span>")
			pulse = PULSE_NONE
			current_pattern = HEART_PATTERN_ASYSTOLE
			return
*/
/obj/item/organ/internal/heart/proc/handle_heartbeat()
	if(pulse >= BPM_AUDIBLE_HEARTRATE || owner.shock_stage >= 10 || is_below_sound_pressure(get_turf(owner)))
		//PULSE_THREADY - maximum value for pulse, currently it 5.
		//High pulse value corresponds to a fast rate of heartbeat.
		//Divided by 2, otherwise it is too slow.
		var/rate = (BPM_AUDIBLE_HEARTRATE - pulse)/2
		if(owner.has_chemical_effect(CE_PULSE, 2))
			heartbeat++

		if(heartbeat >= rate)
			heartbeat = 0
			sound_to(owner, sound(beat_sound,0,0,0,50))
		else
			heartbeat++

/obj/item/organ/internal/heart/proc/handle_blood()

	if(!owner)
		return

	//Dead or cryosleep people do not pump the blood.
	if(!owner || owner.InStasis() || owner.stat == DEAD || owner.bodytemperature < 170)
		return

	if(pulse != PULSE_NONE || BP_IS_PROSTHETIC(src))
		//Bleeding out
		var/blood_max = 0
		var/list/do_spray = list()
		for(var/obj/item/organ/external/temp in owner.get_external_organs())

			if(BP_IS_PROSTHETIC(temp))
				continue

			var/open_wound
			if(temp.status & ORGAN_BLEEDING)

				for(var/datum/wound/W in temp.wounds)

					if(!open_wound && (W.damage_type == CUT || W.damage_type == PIERCE) && W.damage && !W.is_treated())
						open_wound = TRUE

					if(W.bleeding())
						if(temp.applied_pressure)
							if(ishuman(temp.applied_pressure))
								var/mob/living/carbon/human/H = temp.applied_pressure
								H.bloody_hands(src, 0)
							//somehow you can apply pressure to every wound on the organ at the same time
							//you're basically forced to do nothing at all, so let's make it pretty effective
							var/min_eff_damage = max(0, W.damage - 10) / 6 //still want a little bit to drip out, for effect
							blood_max += max(min_eff_damage, W.damage - 30) / 40
						else
							blood_max += W.damage / 40

			if(temp.status & ORGAN_ARTERY_CUT)
				var/bleed_amount = FLOOR((owner.vessel.total_volume / (temp.applied_pressure || !open_wound ? 400 : 250))*temp.arterial_bleed_severity)
				if(bleed_amount)
					if(open_wound)
						blood_max += bleed_amount
						do_spray += "[temp.name]"
					else
						owner.vessel.remove_any(bleed_amount)

		blood_max *= owner.mcv / NORMAL_MCV

		blood_max *= 1 + GET_CHEMICAL_EFFECT(owner, CE_BLOOD_THINNING) * 0.5

		if(GET_CHEMICAL_EFFECT(owner, CE_STABLE))
			blood_max *= 0.8

		if(world.time >= next_blood_squirt && isturf(owner.loc) && do_spray.len)
			var/spray_organ = pick(do_spray)
			owner.visible_message(
				SPAN_DANGER("Blood sprays out from \the [owner]'s [spray_organ]!"),
				FONT_HUGE(SPAN_DANGER("Blood sprays out from your [spray_organ]!"))
			)
			SET_STATUS_MAX(owner, STAT_STUN, 1)
			owner.set_status(STAT_BLURRY, 2)

			//AB occurs every heartbeat, this only throttles the visible effect
			next_blood_squirt = world.time + 80
			var/turf/sprayloc = get_turf(owner)
			blood_max -= owner.drip(CEILING(blood_max/3), sprayloc)
			if(blood_max > 0)
				blood_max -= owner.blood_squirt(blood_max, sprayloc)
				if(blood_max > 0)
					owner.drip(blood_max, get_turf(owner))
		else
			owner.drip(blood_max)

/obj/item/organ/internal/heart/proc/is_working()
	if(!is_usable())
		return FALSE

	return pulse > PULSE_NONE || BP_IS_PROSTHETIC(src) || (owner.status_flags & FAKEDEATH)

/obj/item/organ/internal/heart/listen()
	if(BP_IS_PROSTHETIC(src) && is_working())
		if(is_bruised())
			return "sputtering pump"
		else
			return "steady whirr of the pump"

	if(!pulse || (owner.status_flags & FAKEDEATH))
		return "no pulse"

	var/pulsesound = "normal"
	if(length(arrythmias))
		pulsesound = "irregular"

	switch(pulse)
		if(PULSE_SLOW)
			pulsesound = "slow"
		if(PULSE_FAST)
			pulsesound = "fast"
		if(PULSE_2FAST)
			pulsesound = "very fast"
		if(PULSE_THREADY)
			pulsesound = "extremely fast and faint"

	. = "[pulsesound] pulse"

/obj/item/organ/internal/heart/get_mechanical_assisted_descriptor()
	return "pacemaker-assisted [name]"

/obj/item/organ/internal/heart/rejuvenate(ignore_prosthetic_prefs)
	. = ..()
	if(!BP_IS_PROSTHETIC(src))
		pulse = PULSE_NORM
		arrythmias.Cut()
	else
		pulse = PULSE_NONE

/obj/item/organ/internal/heart/proc/get_rhythm_fluffy()
	var/list/rhythmes = list()
	for(var/decl/arrythmia/A in arrythmias)
		rhythmes += A.name
	if(rhythmes.len)
		return english_list(rhythmes)
	else
		return "Normal Rhythm"