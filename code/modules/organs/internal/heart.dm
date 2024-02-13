#define ARRYTHMIAS_GRACE_PERIOD 5 SECONDS

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
	damage_reduction = 0.7
	relative_size = 5
	max_damage = 45
	oxygen_consumption = 0.96
	oxygen_deprivation_tick = 0.3
	var/open
	var/external_pump = 0 //simulated beats per minute
	var/cardiac_output = 1
	var/instability = 0
	var/list/arrythmias = list()
	var/list/cardiac_output_modifiers = list()
	var/list/bpm_modifiers = list()
	var/list/stability_modifiers = list()
	var/last_arrythmia_appearance //world time

/obj/item/organ/internal/heart/die()
	. = ..()
	pulse = 0
	cardiac_output = 0
	arrythmias.Cut()
	add_arrythmia(GET_DECL(/decl/arrythmia/asystole))

/obj/item/organ/internal/heart/open
	open = 1

/obj/item/organ/internal/heart/Process()
	if(owner)
		if(BP_IS_PROSTHETIC(src))
			pulse = 0
			if(is_usable())
				cardiac_output = initial(cardiac_output) - damage * 0.01
			else
				cardiac_output = 0
		else
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
	..()

/obj/item/organ/internal/heart/proc/get_modifiers()
	bpm_modifiers["hypoperfusion"] = (1 - owner.get_blood_perfusion()) * 120
	bpm_modifiers["ischemia"] = oxygen_deprivation * -2.4
	bpm_modifiers["shock"] = clamp(owner.shock_stage * 0.35, 0, 110)
	bpm_modifiers["toxins"] = owner.getToxLoss() * -0.15
	for(var/decl/arrythmia/A in arrythmias)
		bpm_modifiers[A.name] = A.get_pulse_mod()
		cardiac_output_modifiers[A.name] = A.cardiac_output_mod

/obj/item/organ/internal/heart/proc/calculate_instability()
	var/ninstability = 0

	if(owner.mcv > 10000)
		ninstability += 20
	if(owner.mcv < 400)
		ninstability += 60
	if(owner.get_blood_perfusion() < 0.5)
		ninstability += 20
	if(cardiac_output < 0.5)
		ninstability += 20
	if(owner.tpvr > 280)
		ninstability += 20

	var/pulse_over_norm = max(pulse - 110, 0)
	ninstability += pulse_over_norm * 0.5
	ninstability += damage * 0.3
	ninstability += oxygen_deprivation * 0.25
	ninstability -= sumListAndCutAssoc(stability_modifiers)
	instability = max(Interpolate(instability, ninstability, 0.1), 0)

/obj/item/organ/internal/heart/proc/apply_instability()
	if(instability > 10)
		if(!pulse)
			add_arrythmia(GET_DECL(/decl/arrythmia/asystole))
		if(last_arrythmia_appearance + ARRYTHMIAS_GRACE_PERIOD < world.time && prob(instability * 0.15))
			for(var/req_A in SSmobs.arrythmias_sorted_list)
				var/decl/arrythmia/A = GET_DECL(req_A)
				if(A in arrythmias)
					continue
				if(A.can_appear(src) && A.required_instability < instability)
					add_arrythmia(A)
					break
			for(var/decl/arrythmia/A in arrythmias)
				if(A.evolves_into && (last_arrythmia_appearance + A.evolve_time) < world.time)
					add_arrythmia(GET_DECL(A.evolves_into))
					remove_arrythmia(A)
	else if(instability == 0)
		if(prob(10))
			for(var/decl/arrythmia/A in arrythmias)
				if(!A.can_be_shocked)
					remove_arrythmia(A)
					if(A.degrades_into)
						add_arrythmia(GET_DECL(A.degrades_into))

/obj/item/organ/internal/heart/proc/add_arrythmia_by_type(arr_type) // for testing
	if(!ispath(arr_type, /decl/arrythmia))
		return "Wrong type"
	if(add_arrythmia(GET_DECL(arr_type)))
		return "Success"
	else
		return "Failure"

/obj/item/organ/internal/heart/proc/add_arrythmia(var/decl/arrythmia/A)
	for(var/decl/arrythmia/existing_A in arrythmias)
		if(existing_A.severity > A.severity)
			return 0
		else
			arrythmias -= existing_A
	A.on_spawn(owner)
	last_arrythmia_appearance = world.time
	LAZYDISTINCTADD(arrythmias, A)
	return 1

/obj/item/organ/internal/heart/proc/remove_arrythmia(var/decl/arrythmia/A)
	arrythmias -= A

/obj/item/organ/internal/heart/proc/handle_pulse()
	var/oxygen_deprivation_coef = 1 - oxygen_deprivation / 100

	if(pulse)
		var/target_pulse = (initial(pulse) + sumListAndCutAssoc(bpm_modifiers)) * oxygen_deprivation_coef
		pulse = max(Interpolate(pulse, target_pulse, HEMODYNAMICS_INTERPOLATE_FACTOR), 0)
		external_pump = 0

	if(!pulse)
		return
	var/cardiac_output_pulse_modifier = Clamp(130 / pulse, 0.7, 1)
	var/cardiac_output_oxygen_modifier = min(1, oxygen_deprivation_coef)
	cardiac_output = initial(cardiac_output) * mulListAndCutAssoc(cardiac_output_modifiers) * cardiac_output_pulse_modifier * cardiac_output_oxygen_modifier

/obj/item/organ/internal/heart/proc/handle_heartbeat()
	if(pulse >= BPM_AUDIBLE_HEARTRATE || owner.shock_stage >= 10 || is_below_sound_pressure(get_turf(owner)))
		//PULSE_THREADY - maximum value for pulse, currently it 5.
		//High pulse value corresponds to a fast rate of heartbeat.
		//Divided by 2, otherwise it is too slow.
		var/rate = (BPM_AUDIBLE_HEARTRATE - pulse)/2
		if(owner.has_chemical_effect(CE_PULSE, 30))
			heartbeat++

		if(heartbeat >= rate)
			heartbeat = 0
			sound_to(owner, sound(beat_sound,0,0,0,50))
		else
			heartbeat++

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

	var/mob/living/carbon/human/H = owner
	if(!H.pulse() || (owner.status_flags & FAKEDEATH))
		return "no pulse"

	var/speed = "normal"

	switch(pulse)
		if(0 to 40)
			speed = "slow"
		if(90 to 140)
			speed = "fast"
		if(140 to 170)
			speed = "very fast"
		if(170 to 220)
			speed = "extremely fast"
		if(220 to INFINITY)
			speed = "thready"

	var/regularity = "steady"
	if(length(arrythmias))
		regularity = "irregular"

	. = "[speed] and [regularity] pulse"

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