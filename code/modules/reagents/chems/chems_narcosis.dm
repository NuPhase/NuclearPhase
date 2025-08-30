/decl/material/liquid/propofol
	name = "propofol"
	lore_text = "A powerful sedative."
	taste_description = "metallic"
	color = "#fdf0f5"
	metabolism = 0.05
	overdose = 20
	value = 1.5
	uid = "chem_propofol"
	drug_category = DRUG_CATEGORY_PAIN_SLEEP

/decl/material/liquid/propofol/affect_ingest(mob/living/M, removed, datum/reagents/holder)
	. = ..()
	affect_overdose(M, holder)

/decl/material/liquid/propofol/affect_blood(var/mob/living/carbon/human/H, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	H.custom_pain("You feel your veins burning!", 450)
	if(volume > 2)
		H.add_chemical_effect(CE_PAINKILLER, 400)
		H.add_chemical_effect(CE_PRESSURE, (volume * -10))
		SET_STATUS_MAX(H, STAT_ASLEEP, volume * 1.1)
	else if(volume > 0.1)
		SET_STATUS_MAX(H, STAT_SLUR, 10)
		SET_STATUS_MAX(H, STAT_DRUGGY, 10)

/decl/material/liquid/propofol/affect_overdose(mob/living/M, datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	M.add_chemical_effect(CE_BREATHLOSS, volume * -0.5)
	M.add_chemical_effect(CE_PRESSURE, (volume * -10))
	M.add_chemical_effect(CE_PULSE, (volume * -5))

/decl/material/liquid/suxamethonium
	name = "suxamethonium"
	lore_text = "A powerful paralytic agent, commonly known as 'sux' in the medical field."
	taste_description = "metallic"
	color = "#962850"
	metabolism = REM * 3
	overdose = REAGENTS_OVERDOSE
	value = 1.5
	uid = "chem_suxamethonium"
	molar_mass = 0.3613
	drug_category = DRUG_CATEGORY_PAIN_SLEEP

/decl/material/liquid/suxamethonium/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/threshold = 2
	var/dose = LAZYACCESS(M.chem_doses, type)
	if(dose >= metabolism * threshold * 0.5)
		SET_STATUS_MAX(M, STAT_CONFUSE, 2)
		M.add_chemical_effect(CE_VOICELOSS, 1)
	if(dose > threshold * 0.5)
		ADJ_STATUS(M, STAT_DIZZY, 3)
		SET_STATUS_MAX(M, STAT_WEAK, 2)
	if(dose == round(threshold * 0.5, metabolism))
		to_chat(M, SPAN_WARNING("Your muscles slacken and cease to obey you."))
	if(dose >= threshold)
		M.add_chemical_effect(CE_SEDATE, 1)
		SET_STATUS_MAX(M, STAT_BLURRY, 10)
	M.add_chemical_effect(CE_BREATHLOSS, -dose)
	M.add_chemical_effect(CE_PULSE, dose * -2)

	if(dose > 1 * threshold)
		M.adjustToxLoss(removed)