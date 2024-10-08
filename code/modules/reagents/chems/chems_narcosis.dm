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
	H.add_chemical_effect(CE_PAINKILLER, 400)
	H.add_chemical_effect(CE_PRESSURE, (volume * -10))
	ADJ_STATUS(H, STAT_ASLEEP, volume * 1.1)

/decl/material/liquid/propofol/affect_overdose(mob/living/M, datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	M.add_chemical_effect(CE_BREATHLOSS, volume * -0.5)
	M.add_chemical_effect(CE_PRESSURE, (volume * -10))
	M.add_chemical_effect(CE_PULSE, (volume * -5))