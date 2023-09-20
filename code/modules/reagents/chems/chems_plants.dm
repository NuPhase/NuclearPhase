/decl/material/liquid/deterria
	name = "deterria extract"
	lore_text = "A natural occuring plant extract that causes fear and heightened awareness."
	mechanics_text = "Increases BPM. Makes resuscitations easier. Causes panic."
	taste_description = "rush of panic"
	color = "#ff6c17"
	scannable = 0
	overdose = 80
	metabolism = 0.1
	uid = "deterria_extract"
	var/static/list/overdose_messages = list(
		"You can't stand it anymore!",
		"You get overwhelmed with anxiety!",
		"You panic!"
	)

/decl/material/liquid/deterria/affect_blood(var/mob/living/carbon/human/H, var/removed, var/datum/reagents/holder)
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	var/volume = REAGENT_VOLUME(holder, type)
	heart.bpm_modifiers[name] = volume * 3
	heart.cardiac_output_modifiers[name] = 1 + volume * 0.03
	H.add_chemical_effect(CE_PAINKILLER, 3 * volume)
	heart.stability_modifiers[name] = volume * 1.3

/decl/material/liquid/deterria/affect_overdose(mob/living/carbon/human/H, datum/reagents/holder)
	. = ..()
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	var/volume = REAGENT_VOLUME(holder, type)
	ADJ_STATUS(H, STAT_JITTER, 5)
	heart.stability_modifiers[name] = volume * -3
	if(prob(10))
		H.emote("cry")
		to_chat(H, SPAN_DANGER("<font size = [rand(2,4)]>[pick(overdose_messages)]</font>"))