/decl/species/human/synth
	name = SPECIES_SYNTH
	roleplay_summary = "You are a synthetic made by United Nations and were used to spy on important people. You were sealed in the shelter together with normal human beings. You have to conceal what you really are, and terminate any witnesses."
	primitive_form = SPECIES_HUMAN
	spawn_flags = SPECIES_IS_RESTRICTED
	species_flags = SPECIES_FLAG_SYNTHETIC
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE_NORMAL | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR | SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_POISON
	exertion_reagent_path = /decl/material/liquid/water //watercooled
	unarmed_attacks = list(/decl/natural_attack/stomp, /decl/natural_attack/kick, /decl/natural_attack/punch, /decl/natural_attack/bite)

	blood_types = list(
		/decl/blood_type/rhnull
	)

	blood_volume = SPECIES_BLOOD_SYNTHETIC
	hunger_factor = SYNTHETIC_HUNGER_FACTOR // Multiplier for hunger.
	thirst_factor = SYNTHETIC_THIRST_FACTOR // Multiplier for thirst.
	taste_sensitivity = TASTE_DULL
	strength = STR_HIGH

	brute_mod = 0.8 //metal metal metal metal
	burn_mod = 1.3 //we overheat easily
	toxins_mod = 0
	radiation_mod = 0.1

	oxy_mod = 0.1 //we only use oxygen to imitate breathing
	flash_mod = 1.1
	metabolism_mod = 2.5 //once again, only an imitation
	stun_mod = 1.5
	paralysis_mod = 0.7
	weaken_mod = 0.7

	meat_amount = 1
	skin_amount = 3 //the same as humans
	bone_material = /decl/material/solid/metal/stainlesssteel
	bone_amount = 15 //we handle that differently
	remains_type = /obj/item/remains/robot

	sniff_message_1p = "You analyze the surrounding air with sensors in your nose."
	halloss_message_self = "You imitate a traumatic shock and shut down temporarily."

	breath_pressure = 22 //our pumps are not as strong

	breath_type = /decl/material/gas/oxygen
	exhale_type = /decl/material/gas/oxygen

	body_temperature = 305

	heat_discomfort_strings = list(
		"You use considerably more water to cool yourself down.",
		"The surrounding air is too warm for a human.",
		"Your skin sends overheating signals."
		)
	cold_discomfort_strings = list(
		"The surrounding air is too cold for a human.",
		"Your muscles mimic a cold shiver.",
		"Your chilly flesh imitates goosebumps."
		)

	siemens_coefficient = 1.5

	darksight_range = 4

	slowdown = -1 //We have to think about this

	stomach_capacity = 3
	rarity_value = 3

	pain_emotes_with_pain_level = list( //less sensitive to pain
		list(/decl/emote/audible/agony) = 120,
		list(/decl/emote/audible/scream, /decl/emote/audible/whimper, /decl/emote/audible/moan, /decl/emote/audible/cry) = 90,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan, /decl/emote/audible/moan) = 60,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan) = 30,
	)

	genitals = TRUE
	anus = FALSE
	virginity = FALSE //yoba

	vision_flags = SEE_MOBS

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/synthetic),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/synthetic),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/synthetic),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/synthetic),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/synthetic),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/synthetic),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/synthetic),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/synthetic),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/synthetic),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/synthetic),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/synthetic)
	)

	has_organ = list(    // which required-organ checks are conducted.
		BP_HEART =    /obj/item/organ/internal/heart/synthetic,
		BP_STOMACH =  /obj/item/organ/internal/stomach/synthetic,
		BP_LUNGS =    /obj/item/organ/internal/lungs/synthetic,
		BP_BRAIN =    /obj/item/organ/internal/brain/synthetic,
		BP_EYES =     /obj/item/organ/internal/eyes/synthetic,
		BP_VOICE =    /obj/item/organ/internal/voicebox/synthetic,
		BP_POWER =  /obj/item/organ/internal/power_source/reactor
		)

/decl/species/human/synth/handle_post_spawn(mob/living/carbon/human/H)
	. = ..()
	for(var/obj/item/organ/external/ext_organ in H.get_external_organs())
		ext_organ.robotize(/decl/prosthetics_manufacturer/advanced_biomech, keep_organs = TRUE, skip_prosthetics = TRUE)