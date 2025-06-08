/decl/material/liquid/adrenaline
	name = "adrenaline"
	lore_text = "Increases BPM and heart output. Makes resuscitations easier."
	taste_description = "rush"
	metabolism = REM * 2
	color = "#76319e"
	scannable = 1
	overdose = 4
	value = 1.5
	uid = "chem_adrenaline"
	drug_category = DRUG_CATEGORY_RESUSCITATION

/decl/material/liquid/adrenaline/affect_blood(var/mob/living/carbon/human/H, var/removed, var/datum/reagents/holder)
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	H.add_chemical_effect(CE_BREATHLOSS, removed * 1100)
	H.add_chemical_effect(CE_PAINKILLER, removed * 12500)
	if(removed < 0.003)
		H.add_chemical_effect(CE_PRESSURE, removed * -700)
	else
		H.add_chemical_effect(CE_PRESSURE, removed * 400)
	if(removed > 0.005)
		ADJ_STATUS(H, STAT_ASLEEP, removed * -10)
		SET_STATUS_MAX(H, STAT_JITTER, removed * 1000)
	if(heart)
		heart.stability_modifiers[name] = removed * 3000
		heart.bpm_modifiers[name] = removed * 3900
		heart.cardiac_output_modifiers[name] = 1 + removed * 5.7

/decl/material/liquid/adrenaline/affect_overdose(var/mob/living/carbon/human/H, datum/reagents/holder)
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	heart.stability_modifiers["[name] overdose"] = -950

/decl/material/liquid/noradrenaline
	name = "noradrenaline"
	lore_text = "Increases BP. Wakes people up."
	taste_description = "sobriety"
	metabolism = REM * 2
	color = "#1e3c7e"
	scannable = 1
	overdose = 12
	value = 1.5
	uid = "chem_noradrenaline"
	drug_category = DRUG_CATEGORY_RESUSCITATION

/decl/material/liquid/noradrenaline/affect_blood(var/mob/living/carbon/human/H, var/removed, var/datum/reagents/holder) //UNCONFIRMED VALUES
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	H.add_chemical_effect(CE_PRESSURE, removed * 1550)
	heart.cardiac_output_modifiers[name] = 1 + removed * 0.3
	heart.bpm_modifiers[name] = removed * 200
	if(removed > 0.008)
		ADJ_STATUS(H, STAT_ASLEEP, removed * -10)

/decl/material/liquid/atropine
	name = "atropine"
	lore_text = "Rapidly increases BPM."
	mechanics_text = "Rapidly increases BPM."
	taste_description = "rush"
	color = "#ce3f2c"
	scannable = 1
	overdose = 5
	metabolism = 0.05
	value = 1.5
	uid = "chem_atropine"
	drug_category = DRUG_CATEGORY_RESUSCITATION

/decl/material/liquid/atropine/affect_blood(var/mob/living/carbon/human/H, var/removed, var/datum/reagents/holder) //UNCONFIRMED VALUES
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	heart.bpm_modifiers[name] = removed * 4000

/decl/material/liquid/dopamine
	name = "dopamine"
	lore_text = "Inreases cardiac output."
	color = "#ffd448"
	scannable = 1
	overdose = 8
	metabolism = REM * 2
	uid = "chem_dopamine"
	drug_category = DRUG_CATEGORY_RESUSCITATION

/decl/material/liquid/dopamine/affect_blood(var/mob/living/carbon/human/H, removed, datum/reagents/holder)
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	heart.cardiac_output_modifiers[name] = 1 + removed * 3

/decl/material/liquid/nitroglycerin
	name = "nitroglycerin"
	lore_text = "Reduces cardiac output, increases heart oxygen uptake."
	taste_description = "oil"
	color = "#ceb02c"
	scannable = 1
	overdose = 15
	metabolism = 0.05
	value = 1.5
	uid = "chem_nitroglycerin"
	drug_category = DRUG_CATEGORY_RESUSCITATION

/decl/material/liquid/nitroglycerin/affect_blood(mob/living/carbon/human/H, removed, datum/reagents/holder)
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	heart.cardiac_output_modifiers[name] = 1 - removed * 3
	heart.oxygen_deprivation = max(0, heart.oxygen_deprivation - removed * 5)

/decl/material/solid/betapace
	name = "betapace"
	lore_text = "Decreases BPM, increases cardiac stability."
	taste_description = "burning"
	color = "#353535"
	scannable = 1
	overdose = 15
	metabolism = 0.05
	value = 1.5
	uid = "chem_betapace"
	drug_category = DRUG_CATEGORY_CARDIAC

/decl/material/solid/betapace/affect_blood(mob/living/carbon/human/H, removed, datum/reagents/holder)
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	heart.bpm_modifiers[name] = removed * -20
	heart.stability_modifiers[name] = removed * 700

/decl/material/liquid/dronedarone
	name = "dronedarone"
	lore_text = "Increases cardiac stability."
	taste_description = "comfort"
	color = "#321f35"
	scannable = 1
	overdose = 10
	metabolism = 0.05
	value = 1.5
	uid = "chem_dronedarone"
	drug_category = DRUG_CATEGORY_CARDIAC

/decl/material/liquid/dronedarone/affect_blood(mob/living/carbon/human/H, removed, datum/reagents/holder)
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	heart.stability_modifiers[name] = removed * 1000

/decl/material/liquid/heparin
	name = "heparin"
	lore_text = "Prevents blood clots."
	color = "#d6d6d6"
	scannable = 1
	overdose = 10
	metabolism = 0.01
	value = 1.5
	uid = "chem_heparin"
	drug_category = DRUG_CATEGORY_MISC

/decl/material/liquid/heparin/affect_blood(var/mob/living/carbon/human/H, var/removed, var/datum/reagents/holder) //UNCONFIRMED VALUES
	H.add_chemical_effect(CE_BLOOD_THINNING, removed)

/decl/material/liquid/adenosine
	name = "adenosine"
	lore_text = "Removes weak arrythmias in doses above 3mg."
	color = "#d6d6d6"
	scannable = 1
	overdose = 10
	metabolism = 0.9
	value = 1.5
	uid = "adenosine"
	drug_category = DRUG_CATEGORY_CARDIAC

/decl/material/liquid/adenosine/affect_blood(mob/living/carbon/human/H, removed, datum/reagents/holder)
	if(removed > 2)
		var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
		heart.bpm_modifiers[name] = -140
		for(var/decl/arrythmia/A in heart.arrythmias)
			if(!A.can_be_shocked && prob(90))
				heart.arrythmias.Remove(A)