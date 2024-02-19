
/decl/material/liquid/amphetamines
	name = "amphetamines"
	lore_text = "A powerful, long-lasting stimulant."
	taste_description = "acid"
	color = "#ff3300"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE * 0.5
	value = 2
	uid = "chem_amphetamines"

/decl/material/liquid/amphetamines/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.add_chemical_effect(CE_PULSE, 3)

/decl/material/liquid/narcotics
	name = "narcotics"
	lore_text = "A narcotic that impedes mental ability by slowing down the higher brain cell functions."
	taste_description = "numbness"
	color = "#c8a5dc"
	overdose = REAGENTS_OVERDOSE
	value = 2
	uid = "chem_narcotics"

/decl/material/liquid/narcotics/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	ADJ_STATUS(M, STAT_JITTER, -5)
	if(prob(80))
		M.adjustBrainLoss(5.25 * removed)
	if(prob(50))
		SET_STATUS_MAX(M, STAT_DROWSY, 3)
	if(prob(10))
		M.emote("drool")

/decl/material/liquid/nicotine
	name = "nicotine"
	lore_text = "A sickly yellow liquid sourced from tobacco leaves. Stimulates and relaxes the mind and body."
	taste_description = "peppery bitterness"
	color = "#efebaa"
	metabolism = REM * 0.2
	overdose = 60
	scannable = 1
	value = 2
	uid = "chem_nicotine"

/decl/material/liquid/nicotine/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(prob(volume*20))
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume <= 0.02 && LAZYACCESS(M.chem_doses, type) >= 0.05 && world.time > REAGENT_DATA(holder, type) + 3 MINUTES)
		LAZYSET(holder.reagent_data, type, world.time)
		to_chat(M, "<span class='warning'>You feel antsy, your concentration wavers...</span>")
	else if(world.time > REAGENT_DATA(holder, type) + 3 MINUTES)
		LAZYSET(holder.reagent_data, type, world.time)
		to_chat(M, "<span class='notice'>You feel invigorated and calm.</span>")

/decl/material/liquid/nicotine/affect_overdose(var/mob/living/M, var/datum/reagents/holder)
	..()
	var/volume = REAGENT_VOLUME(holder, type)
	M.add_chemical_effect(CE_PULSE, volume * 0.2)

/decl/material/liquid/sedatives
	name = "sedatives"
	lore_text = "A mild sedative used to calm patients and induce sleep."
	taste_description = "bitterness"
	color = "#009ca8"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	value = 2
	uid = "chem_sedatives"

/decl/material/liquid/sedatives/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	ADJ_STATUS(M, STAT_JITTER, -50)
	var/threshold = 1
	var/dose = LAZYACCESS(M.chem_doses, type)
	if(dose < 0.5 * threshold)
		if(dose == metabolism * 2 || prob(5))
			M.emote("yawn")
	else if(dose < 1 * threshold)
		SET_STATUS_MAX(M, STAT_BLURRY, 10)
	else if(dose < 2 * threshold)
		if(prob(50))
			SET_STATUS_MAX(M, STAT_WEAK, 2)
			M.add_chemical_effect(CE_SEDATE, 1)
		SET_STATUS_MAX(M, STAT_DROWSY, 20)
	else
		SET_STATUS_MAX(M, STAT_ASLEEP, 20)
		SET_STATUS_MAX(M, STAT_DROWSY, 60)
		M.add_chemical_effect(CE_SEDATE, 1)
	M.add_chemical_effect(CE_PULSE, -1)

/decl/material/liquid/psychoactives
	name = "psychoactives"
	lore_text = "An illegal chemical compound used as a psychoactive drug."
	taste_description = "bitterness"
	taste_mult = 0.4
	color = "#60a584"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	value = 2
	narcosis = 7
	fruit_descriptor = "rich"
	euphoriant = 15
	uid = "chem_psychoactives"

/decl/material/liquid/psychoactives/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	SET_STATUS_MAX(M, STAT_DRUGGY, 15)
	M.add_chemical_effect(CE_PULSE, -1)

/decl/material/liquid/hallucinogenics
	name = "hallucinogenics"
	lore_text = "A mix of powerful hallucinogens, they can cause fatal effects in users."
	taste_description = "sourness"
	color = "#b31008"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	value = 2
	uid = "chem_hallucinogenics"

/decl/material/liquid/hallucinogenics/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_MIND, -2)
	M.set_hallucination(50, 50)

/decl/material/liquid/psychotropics
	name = "psychotropics"
	lore_text = "A strong psychotropic derived from certain species of mushroom."
	taste_description = "mushroom"
	color = "#e700e7"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.5
	value = 2
	euphoriant = 30
	fruit_descriptor = "hallucinogenic"
	uid = "chem_psychotropics"

/decl/material/liquid/psychotropics/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/threshold = 1
	var/dose = LAZYACCESS(M.chem_doses, type)
	if(dose < 1 * threshold)
		M.apply_effect(3, STUTTER)
		ADJ_STATUS(M, STAT_DIZZY, 1)
		if(prob(5))
			M.emote(pick("twitch", "giggle"))
	else if(dose < 2 * threshold)
		M.apply_effect(3, STUTTER)
		ADJ_STATUS(M, STAT_JITTER,  2)
		ADJ_STATUS(M, STAT_DIZZY,   2)
		SET_STATUS_MAX(M, STAT_DRUGGY, 35)

		if(prob(10))
			M.emote(pick("twitch", "giggle"))
	else
		M.add_chemical_effect(CE_MIND, -1)
		M.apply_effect(3, STUTTER)
		ADJ_STATUS(M, STAT_JITTER, 5)
		ADJ_STATUS(M, STAT_DIZZY,  5)
		SET_STATUS_MAX(M, STAT_DRUGGY, 40)
		if(prob(15))
			M.emote(pick("twitch", "giggle"))

// Welcome back, Three Eye
/decl/material/liquid/glowsap/gleam
	name = "Gleam"
	lore_text = "A powerful hallucinogenic and psychotropic derived from various species of glowing mushroom. Some say it can have permanent effects on the brains of those who over-indulge."
	color = "#ccccff"
	metabolism = REM*5
	overdose = 25
	uid = "chem_gleam"

	// M A X I M U M C H E E S E
	var/static/list/dose_messages = list(
		"Your name is called. It is your time.",
		"You are dissolving. Your hands are wax...",
		"It all runs together. It all mixes.",
		"It is done. It is over. You are done. You are over.",
		"You won't forget. Don't forget. Don't forget.",
		"Light seeps across the edges of your vision...",
		"Something slides and twitches within your sinus cavity...",
		"Your bowels roil. It waits within.",
		"Your gut churns. You are heavy with potential.",
		"Your heart flutters. It is winged and caged in your chest.",
		"There is a precious thing, behind your eyes.",
		"Everything is ending. Everything is beginning.",
		"Nothing ends. Nothing begins.",
		"Wake up. Please wake up.",
		"Stop it! You're hurting them!",
		"It's too soon for this. Please go back.",
		"We miss you. Where are you?",
		"Come back from there. Please."
	)

	var/static/list/overdose_messages = list(
		"THE SIGNAL THE SIGNAL THE SIGNAL THE SIGNAL",
		"IT CRIES IT CRIES IT WAITS IT CRIES",
		"NOT YOURS NOT YOURS NOT YOURS NOT YOURS",
		"THAT IS NOT FOR YOU",
		"IT RUNS IT RUNS IT RUNS IT RUNS",
		"THE BLOOD THE BLOOD THE BLOOD THE BLOOD",
		"THE LIGHT THE DARK A STAR IN CHAINS"
	)

/decl/material/liquid/glowsap/gleam/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	M.add_client_color(/datum/client_color/noir/thirdeye)
	M.add_chemical_effect(CE_THIRDEYE, 1)
	M.add_chemical_effect(CE_MIND, -2)
	M.set_hallucination(50, 50)
	ADJ_STATUS(M, STAT_JITTER, 3)
	ADJ_STATUS(M, STAT_DIZZY,  3)
	if(prob(0.1) && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.seizure()
		H.adjustBrainLoss(rand(8, 12))
	if(prob(5))
		to_chat(M, SPAN_WARNING("<font size = [rand(1,3)]>[pick(dose_messages)]</font>"))

/decl/material/liquid/glowsap/gleam/on_leaving_metabolism(var/atom/parent, var/metabolism_class)
	. = ..()
	var/mob/M = parent
	if(istype(M))
		M.remove_client_color(/datum/client_color/noir/thirdeye)

/decl/material/liquid/glowsap/gleam/affect_overdose(var/mob/living/M, var/datum/reagents/holder)
	M.adjustBrainLoss(rand(1, 5))
	if(ishuman(M) && prob(10))
		var/mob/living/carbon/human/H = M
		H.seizure()
	if(prob(10))
		to_chat(M, SPAN_DANGER("<font size = [rand(2,4)]>[pick(overdose_messages)]</font>"))

/decl/material/liquid/opium
	name = "opium"
	lore_text = "Unrefined substance extracted from opium poppy flowers."
	color = "#ccccff"
	metabolism = REM * 0.1
	overdose = 60
	uid = "chem_opium"
	var/addictiveness = 10 //addiction gained per unit consumed
	var/painkill_magnitude = 130000
	var/effective_dose = 1
	drug_category = DRUG_CATEGORY_ANALGESICS

/decl/material/liquid/opium/affect_blood(mob/living/carbon/human/H, removed, datum/reagents/holder)
	if(H.bloodstr.has_reagent(/decl/material/liquid/naloxone, 1))
		return
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	H.add_chemical_effect(CE_PAINKILLER, painkill_magnitude * removed)
	SET_STATUS_MAX(H, STAT_DRUGGY, 15)
	heart.bpm_modifiers[name] = removed * -3000
	var/boozed = isboozed(H)
	if(boozed)
		H.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		H.add_chemical_effect(CE_BREATHLOSS, -2 * boozed)

/decl/material/liquid/opium/affect_overdose(mob/living/carbon/human/H, datum/reagents/holder)
	. = ..()
	if(H.bloodstr.has_reagent(/decl/material/liquid/naloxone, 4))
		return
	H.add_chemical_effect(CE_BREATHLOSS, -5)
	ADJ_STATUS(H, STAT_DIZZY,  3)

/decl/material/liquid/opium/on_leaving_metabolism(atom/parent, metabolism_class)
	. = ..()
	var/mob/M = parent
	spawn(60 SECONDS)
		to_chat(M, SPAN_BOLD("You suddenly want more [name]..."))

/decl/material/liquid/opium/proc/isboozed(var/mob/living/carbon/M)
	. = 0
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested)
		var/list/pool = M.reagents.reagent_volumes | ingested.reagent_volumes
		for(var/rtype in pool)
			var/decl/material/liquid/ethanol/booze = GET_DECL(rtype)
			if(!istype(booze) ||LAZYACCESS(M.chem_doses, rtype) < 2) //let them experience false security at first
				continue
			. = 1
			if(booze.strength < 40) //liquor stuff hits harder
				return 2

/decl/material/liquid/opium/tramadol
	name = "tramadol"
	lore_text = "A linear painkiller."
	addictiveness = 5
	painkill_magnitude = 110000
	overdose = 70
	uid = "chem_tramadol"
	ingest_met = 0.1

/decl/material/liquid/opium/tramadol/affect_blood(mob/living/carbon/human/H, removed, datum/reagents/holder)
	if(H.bloodstr.has_reagent(/decl/material/liquid/naloxone, 1))
		return
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	heart.bpm_modifiers[name] = removed * -100
	H.add_chemical_effect(CE_PAINKILLER, painkill_magnitude * removed)
	var/boozed = isboozed(H)
	if(boozed)
		H.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		H.add_chemical_effect(CE_BREATHLOSS, -1 * boozed)

/decl/material/liquid/opium/tramadol/affect_ingest(mob/living/carbon/human/H, removed, datum/reagents/holder)
	if(H.bloodstr.has_reagent(/decl/material/liquid/naloxone, 1))
		return
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	var/dose = LAZYACCESS(H.chem_doses, type)
	heart.bpm_modifiers[name] = dose * -0.1
	H.add_chemical_effect(CE_PAINKILLER, painkill_magnitude * dose * metabolism)
	var/boozed = isboozed(H)
	if(boozed)
		H.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		H.add_chemical_effect(CE_BREATHLOSS, -1 * boozed)

/decl/material/liquid/opium/fentanyl
	name = "fentanyl"
	lore_text = "An extremely strong painkiller."
	addictiveness = 3
	painkill_magnitude = 1740000
	overdose = 3 //can't drink fentanyl in ohio
	uid = "chem_fentanyl"
	ingest_met = 0.1

/decl/material/liquid/opium/fentanyl/affect_blood(mob/living/carbon/human/H, removed, datum/reagents/holder)
	if(H.bloodstr.has_reagent(/decl/material/liquid/naloxone, 1))
		return
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	heart.bpm_modifiers[name] = removed * -50000
	H.add_chemical_effect(CE_PAINKILLER, painkill_magnitude * removed)
	H.add_chemical_effect(CE_PRESSURE, -30000 * removed)
	H.add_chemical_effect(CE_BREATHLOSS, -10000 * removed)
	var/boozed = isboozed(H)
	if(boozed)
		H.add_chemical_effect(CE_ALCOHOL_TOXIC, 2)
		H.add_chemical_effect(CE_BREATHLOSS, -3 * boozed)

/decl/material/liquid/opium/fentanyl/affect_ingest(mob/living/carbon/human/H, removed, datum/reagents/holder)
	if(H.bloodstr.has_reagent(/decl/material/liquid/naloxone, 1))
		return
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	var/dose = LAZYACCESS(H.chem_doses, type)
	heart.bpm_modifiers[name] = dose * -5
	H.add_chemical_effect(CE_PAINKILLER, painkill_magnitude * dose * metabolism)
	H.add_chemical_effect(CE_PRESSURE, -3 * dose)
	H.add_chemical_effect(CE_BREATHLOSS, -1 * dose)
	var/boozed = isboozed(H)
	if(boozed)
		H.add_chemical_effect(CE_ALCOHOL_TOXIC, 2)
		H.add_chemical_effect(CE_BREATHLOSS, -3 * boozed)

/decl/material/liquid/opium/codeine
	name = "codeine"
	lore_text = "A precursor to a large variety of opioids"
	addictiveness = 1
	painkill_magnitude = 40000
	uid = "chem_codeine"

/decl/material/liquid/opium/codeine/desomorphine
	name = "desomorphine"
	lore_text = "An addictive painkiller with a very short window of action."
	effective_dose = 0.5
	painkill_magnitude = 220000
	overdose = 14
	uid = "chem_desomorphine"

/decl/material/liquid/tianeptine
	name = "tianeptine"
	lore_text = "An addictive and effective antidepressant."
	uid = "chem_tianeptine"

/decl/material/liquid/sulfuric_morphine
	name = "sulfuric morphine"
	lore_text = "Morphine with a lot of sulfuric acid traces in it."
	heating_products = list(/decl/material/liquid/opium/morphine = 1, /decl/material/solid/sulfur = 1)
	heating_message = "All sulphuric acid evaporates, leaving a mess of purple liquid and yellow powder."
	heating_point = 140 CELSIUS
	uid = "chem_sulfuricmorphine"

/decl/material/liquid/opium/morphine
	name = "morphine"
	painkill_magnitude = 290000
	uid = "chem_morphine"
	effective_dose = 1
	overdose = 18

/decl/material/liquid/opium/morphine/affect_blood(mob/living/carbon/human/H, removed, datum/reagents/holder)
	if(H.bloodstr.has_reagent(/decl/material/liquid/naloxone, 1))
		return
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	heart.bpm_modifiers[name] = removed * -700
	H.add_chemical_effect(CE_PAINKILLER, painkill_magnitude * removed)
	SET_STATUS_MAX(H, STAT_DRUGGY, 15)
	var/boozed = isboozed(H)
	if(boozed)
		H.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		H.add_chemical_effect(CE_BREATHLOSS, -1 * boozed)

/decl/material/liquid/opium/morphine/ethylmorphine
	name = "ethylmorphine"
	painkill_magnitude = 20
	uid = "chem_ethylmorphine"

/decl/material/liquid/opium/morphine/diamorphine
	name = "diamorphine"
	lore_text = "A synthetic morphine-derived drug."
	painkill_magnitude = 330000
	uid = "chem_diamorphine"

/decl/material/liquid/opium/morphine/diamorphine/affect_blood(mob/living/carbon/human/H, removed, datum/reagents/holder)
	H.set_hallucination(120, 30)

/decl/material/liquid/opium/morphine/diamorphine/dirty
	name = "murky diamorphine"
	lore_text = "A synthetic morphine-derived drug. Looks unpure."
	painkill_magnitude = 250000
	uid = "chem_diamorphinedirty"

/decl/material/liquid/opium/morphine/diamorphine/dirty/affect_blood(mob/living/carbon/human/H, removed, datum/reagents/holder)
	. = ..()
	H.adjustToxLoss(removed*5)