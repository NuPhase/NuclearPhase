/decl/material/liquid/antirads
	name = "antirads"
	lore_text = "A synthetic recombinant protein, derived from entolimod, used in the treatment of radiation poisoning."
	taste_description = "bitterness"
	color = "#408000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5
	uid = "chem_antirads"

/decl/material/liquid/antirads/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	M.radiation = max(M.radiation - 30 * removed, 0)

/decl/material/liquid/antitoxins
	name = "antitoxins"
	lore_text = "A mix of broad-spectrum antitoxins used to neutralize poisons before they can do significant harm."
	taste_description = "a roll of gauze"
	color = "#00a000"
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5
	fruit_descriptor = "astringent"
	uid = "chem_antitoxins"
	var/remove_generic = 1
	var/list/remove_toxins = list(
		/decl/material/liquid/zombiepowder
	)

/decl/material/liquid/antitoxins/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	if(remove_generic)
		ADJ_STATUS(M, STAT_DROWSY, -6 * removed)
		M.adjust_hallucination(-9 * removed)
		M.add_chemical_effect(CE_ANTITOX, 1)

	var/removing = (4 * removed)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	for(var/R in ingested.reagent_volumes)
		var/decl/material/chem = GET_DECL(R)
		if((remove_generic && chem.toxicity) || (R in remove_toxins))
			M.reagents.remove_reagent(R, removing)
			return

	for(var/R in M.reagents?.reagent_volumes)
		var/decl/material/chem = GET_DECL(R)
		if((remove_generic && chem.toxicity) || (R in remove_toxins))
			M.reagents.remove_reagent(R, removing)
			return

/decl/material/liquid/antitoxins/charcoal
	name = "charcoal"
	taste_description = "carbon"
	color = "#161a16"
	uid = "chem_charcoal"
	metabolism = 0.5
	overdose = 600
	drug_category = DRUG_CATEGORY_TOX

/decl/material/liquid/potassium_iodide
	name = "potassium iodide"
	lore_text = "A common radiation protector."
	taste_description = "metal"
	color = "#322235"
	uid = "chem_potassium_iodide"
	metabolism = 0.05
	drug_category = DRUG_CATEGORY_TOX

/decl/material/liquid/pentenate_calcium_trisodium
	name = "pentenate calcium trisodium"
	lore_text = "A strong radiation chelator that removes isotopes from the body."
	taste_description = "acid"
	color = "#cecece"
	uid = "chem_pentenate_calcium_trisodium"
	metabolism = 0.1
	drug_category = DRUG_CATEGORY_TOX

/decl/material/liquid/pentenate_calcium_trisodium/affect_blood(mob/living/carbon/human/H, removed, datum/reagents/holder)
	H.bloodstr.remove_reagent(/decl/material/solid/metal/plutonium, 1)
	H.radiation -= 10

/decl/material/solid/sodium_bicarbonate
	name = "sodium bicarbonate"
	lore_text = "A special chelator that binds and removes potassium. Useful for treating septic shock."
	taste_description = "alkaline"
	color = "#e2e2e2"
	uid = "sodium_bicarbonate"
	metabolism = 0.1
	drug_category = DRUG_CATEGORY_TOX

/decl/material/solid/sodium_bicarbonate/affect_blood(mob/living/carbon/human/H, removed, datum/reagents/holder)
	H.bloodstr.remove_reagent(/decl/material/solid/potassium, removed)

/decl/material/liquid/metoclopramide
	name = "metoclopramide"
	lore_text = "A common antiemetic. Antiemetics prevent people from vomiting."
	color = "#e2e2e2"
	uid = "metoclopramide"
	overdose = 15
	metabolism = REM*2
	drug_category = DRUG_CATEGORY_TOX

/decl/material/liquid/naloxone
	name = "naloxone"
	lore_text = "An opioid antidote."
	color = "#1a6181"
	uid = "naloxone"
	overdose = 8
	metabolism = REM * 0.2
	drug_category = DRUG_CATEGORY_TOX