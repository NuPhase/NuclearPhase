/mob/living/carbon/human
	var/bpm = 60
	var/metabolic_coefficient = 1 //TODO: CALCULATE THIS
	var/syspressure = 120
	var/dyspressure = 80
	var/meanpressure = 100
	var/mcv = 3900 //Minute Circulation Volume
	var/tpvr = 0 //Total Peripherial Vascular Resistance
	var/max_oxygen_capacity = 120
	var/oxygen_amount = 120
	var/add_mcv = 0

/mob/living/carbon/human/proc/get_blood_volume_hemo()
	. = vessel.total_volume / species.blood_volume

/mob/living/carbon/human/proc/get_cardiac_output()
	var/obj/item/organ/internal/heart/heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
	. = heart?.cardiac_output

/mob/living/carbon/human/proc/get_blood_saturation()
	if(stat == DEAD)
		return 0
	if(status_flags & GODMODE)
		return 1
	. = oxygen_amount / max_oxygen_capacity

/mob/living/carbon/human/proc/get_blood_perfusion()
	if(stat == DEAD)
		return 0

	. = CLAMP01((mcv / (NORMAL_MCV * metabolic_coefficient)) * get_blood_saturation())

/mob/living/carbon/human/proc/process_hemodynamics()
	var/obj/item/organ/internal/heart/heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
	bpm = heart.pulse + heart.external_pump

	if(bpm < 10)
		dyspressure = 0
		syspressure = 0
		mcv = 0
		tpvr = metabolic_coefficient * 218.50746
		return

	var/ccp = 0 //cardiac cycle period
	if(bpm > 0)
		ccp = 60/bpm

	tpvr = metabolic_coefficient * 218.50746
	tpvr += syspressure * (0.0008 * syspressure - 0.8833) + 94
	tpvr += LAZYACCESS0(chem_effects, CE_PRESSURE)

	var/bpmd = ccp * 0.109 + 0.159
	var/coeff = get_blood_volume_hemo() * get_cardiac_output() * (bpmd * 3.73134328)
	var/bpm53 = bpm * coeff * 53.0
	dyspressure = max(0, Interpolate(dyspressure, (tpvr * (2180 + bpm53))/(metabolic_coefficient * (17820 - bpm53)), HEMODYNAMICS_INTERPOLATE_FACTOR))
	syspressure = Clamp(Interpolate(syspressure, (50 * mcv) / (27 * bpm) + 2.0 * dyspressure - (7646.0 * metabolic_coefficient)/54.0, HEMODYNAMICS_INTERPOLATE_FACTOR), 0, 413)
	dyspressure = min(dyspressure, max(10, syspressure)-10)

	meanpressure = (syspressure + dyspressure) / 2

	mcv = Clamp((((syspressure + dyspressure) * 4000) / tpvr) * coeff + add_mcv, 0, 12000)
	add_mcv = 0
	//mcv = meanpressure * 132.32 * 60 / tpvr

/mob/living/carbon/human/proc/consume_oxygen(amount)
	var/available_oxygen = oxygen_amount * get_blood_perfusion()
	if(available_oxygen > amount)
		oxygen_amount -= amount
		return 1
	return 0

/mob/living/carbon/human/proc/add_oxygen(amount)
	oxygen_amount = Clamp(oxygen_amount + amount, 0, max_oxygen_capacity)
	if(oxygen_amount < max_oxygen_capacity - 10)
		return 0
	return 1

/mob/living/carbon/human/proc/get_blood_pressure_fluffy()
	if(syspressure < 30)
		return "0/0"
	return "[round(syspressure) + rand(-10, 10)]/[round(dyspressure) + rand(-10, 10)]"
