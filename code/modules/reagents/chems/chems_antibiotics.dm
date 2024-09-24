/decl/material/liquid/antibiotics
	name = "antibiotics"
	lore_text = "An all-purpose antibiotic agent."
	taste_description = "bitterness"
	color = "#c1c1c1"
	metabolism = REM * 0.1
	overdose = 5
	scannable = 1
	value = 1.5
	uid = "chem_antibiotics"
	var/strength = 0.3 //per unit
	drug_category = DRUG_CATEGORY_ANTIBIOTICS

/decl/material/liquid/antibiotics/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return
	var/volume = REAGENT_VOLUME(holder, type)
	H.immunity = max(H.immunity - 0.1, 0)
	H.add_chemical_effect(CE_ANTIBIOTIC, strength*volume)
	if(volume > 10)
		H.immunity = max(H.immunity - 0.3, 0)
	if(LAZYACCESS(H.chem_doses, type) > 15)
		H.immunity = max(H.immunity - 0.25, 0)

/decl/material/liquid/antibiotics/affect_overdose(mob/living/carbon/human/H, datum/reagents/holder)
	H.immunity = 0 //crash that

/decl/material/liquid/antibiotics/penicillin
	name = "penicillin"
	lore_text = "A weak but cheap antibiotic."
	uid = "chem_antibiotics_penicillin"
	strength = 0.75
	overdose = 30

/decl/material/liquid/antibiotics/amicile
	name = "amicile"
	lore_text = "A run-of-the-mill antibiotic with few side effects."
	uid = "chem_antibiotics_amicile"
	strength = 1.4
	overdose = 15

/decl/material/liquid/antibiotics/ceftriaxone
	name = "ceftriaxone"
	lore_text = "A very strong antibiotic with major side effects."
	uid = "chem_antibiotics_ceftriaxone"
	strength = 5
	overdose = 3

/decl/material/liquid/antibiotics/ceftriaxone/affect_blood(mob/living/M, removed, datum/reagents/holder)
	. = ..()
	M.adjustToxLoss(10*removed)

/decl/material/liquid/antibiotics/ceftriaxone/affect_overdose(mob/living/carbon/human/H, datum/reagents/holder)
	. = ..()
	H.bloodstr.add_reagent(/decl/material/solid/potassium, 0.1)