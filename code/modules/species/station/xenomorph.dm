/decl/species/xenomorph
	name = SPECIES_XENOMORPH
	name_plural = "Xenomorphs"
	unarmed_attacks = list(/decl/natural_attack/xenomorph_claws, /decl/natural_attack/xenomorph_tail, /decl/natural_attack/bite/sharp)
	description = "NO DATA."
	hidden_from_codex = TRUE
	spawn_flags = SPECIES_IS_RESTRICTED
	flesh_color = "#322936"

	available_bodytypes = list(
		/decl/bodytype/xenomorph
	)

	available_pronouns = list(
		/decl/pronouns/female
	)
	mob_size = MOB_SIZE_LARGE
	strength = STR_VHIGH
	show_ssd = "in stasis"
	light_sensitive = TRUE
	hunger_factor = XENOMORPH_HUNGER_FACTOR
	thirst_factor = XENOMORPH_THIRST_FACTOR
	taste_sensitivity = TASTE_HYPERSENSITIVE

	total_health = 350

	natural_armour_values = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
	brute_mod =      0.75                    // Physical damage multiplier.
	burn_mod =       2                    // Burn damage multiplier.
	toxins_mod =     0.5                    // Toxloss modifier
	radiation_mod =  0                    // Radiation modifier

	oxy_mod =        0.1                    // Oxyloss modifier
	flash_mod =      0                    // Stun from blindness modifier.
	metabolism_mod = 2                    // Reagent metabolism modifier
	stun_mod =       0.3                    // Stun period modifier.
	paralysis_mod =  1.5                    // Paralysis period modifier.
	weaken_mod =     0.5                    // Weaken period modifier.

	exertion_effect_chance = 10
	exertion_hydration_scale = 1
	exertion_charge_scale = 1
	exertion_reagent_scale = 1
	exertion_reagent_path = /decl/material/liquid/lactate
	exertion_emotes_biological = list(
		/decl/emote/exertion/biological,
		/decl/emote/exertion/biological/breath,
		/decl/emote/exertion/biological/pant
	)
	exertion_emotes_synthetic = list(
		/decl/emote/exertion/synthetic,
		/decl/emote/exertion/synthetic/creak
	)
	pain_emotes_with_pain_level = list()
	manual_dexterity = DEXTERITY_GRIP
	genitals = 1

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/xenomorph),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/xenomorph),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/xenomorph),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/xenomorph),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/xenomorph),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/xenomorph),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/xenomorph),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/xenomorph),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/xenomorph),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/xenomorph),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/xenomorph)
	)

	has_organ = list(    // which required-organ checks are conducted.
		BP_HEART =    /obj/item/organ/internal/heart/xenomorph,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_LUNGS =    /obj/item/organ/internal/lungs/xenomorph,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain
		)
	spawn_flags = SPECIES_IS_RESTRICTED


/decl/species/xenomorph/get_root_species_name(var/mob/living/carbon/human/H)
	return SPECIES_XENOMORPH

/decl/species/xenomorph/get_ssd(var/mob/living/carbon/human/H)
	if(H.stat == CONSCIOUS)
		return "staring blankly, not reacting to your presence"
	return ..()

/decl/species/xenomorph/equip_default_fallback_uniform(var/mob/living/carbon/human/H)
	return
