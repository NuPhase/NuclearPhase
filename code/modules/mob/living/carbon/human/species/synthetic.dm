/*
I hereby declare that NuclearPhase will not have 'dumbed down' synthetics.
We're an almost perfect copy of humans in their appearance, so basically indistinguishable(the reason for no separate species)
Every limb has a tensor muscle organ that replaces bones mechanics.
We have a very powerful computer system that allows our neural network to fully imitate human behaviour.
*/

/mob/living/carbon/human/synthetic
	weight = 95 //even composite materials are very heavy
	pull_coefficient = 0.2
	lying_pull_coefficient = 0.9

/mob/living/carbon/human/synthetic/process_hemodynamics()
	var/obj/item/organ/internal/heart/heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
	bpm = heart.pulse + heart.external_pump
	tpvr = rand(210, 220)
	if(bpm)
		syspressure = rand(115, 120)
		dyspressure = rand(75, 80)
		mcv = NORMAL_MCV + rand(-100, 100)
	else
		syspressure = 0
		dyspressure = 0
		mcv = 0

/mob/living/carbon/human/synthetic/setup(var/datum/dna/new_dna = null)
	dna = new_dna

	set_species()

	if(new_dna)
		set_real_name(new_dna.real_name)
	else
		try_generate_default_name()

	species.handle_pre_spawn(src)
	if(!LAZYLEN(get_external_organs()))
		species.create_missing_organs(src) //Syncs DNA when adding organs
	apply_species_cultural_info()
	apply_species_appearance()
	species.handle_post_spawn(src)

	UpdateAppearance() //Apply dna appearance to mob, causes DNA to change because filler values are regenerated

/mob/living/carbon/human/synthetic/set_species(var/new_species_name, var/new_bodytype = null)
	var/new_species = GET_DECL(/decl/species/human/synth)
	if(!new_species)
		CRASH("set_species on mob '[src]' was passed a bad species name!")

	//Handle old species transition
	if(species)
		species.remove_base_auras(src)
		species.remove_inherent_verbs(src)

	//Update our species
	species = new_species
	if(dna)
		dna.species = new_species_name
	holder_type = null
	if(species.holder_type)
		holder_type = species.holder_type
	maxHealth = species.total_health
	mob_size = species.mob_size
	remove_extension(src, /datum/extension/armor)
	if(species.natural_armour_values)
		set_extension(src, /datum/extension/armor, species.natural_armour_values)

	var/decl/pronouns/new_pronouns = get_pronouns_by_gender(get_sex())
	if(!istype(new_pronouns) || !(new_pronouns in species.available_pronouns))
		new_pronouns = species.default_pronouns
		set_gender(new_pronouns.name)

	//Handle bodytype
	if(!new_bodytype)
		new_bodytype = species.get_bodytype_by_pronouns(new_pronouns)
	set_bodytype(new_bodytype, FALSE)

	available_maneuvers = species.maneuvers.Copy()

	meat_type =     species.meat_type
	meat_amount =   species.meat_amount
	skin_material = species.skin_material
	skin_amount =   species.skin_amount
	bone_material = species.bone_material
	bone_amount =   species.bone_amount

	full_prosthetic = null //code dum thinks ur robot always
	default_walk_intent = null
	default_run_intent = null
	move_intent = null
	move_intents = species.move_intents.Copy()
	set_move_intent(GET_DECL(move_intents[1]))
	if(!istype(move_intent))
		set_next_usable_move_intent()
	update_emotes()

	// Update codex scannables.
	if(species.secret_codex_info)
		var/datum/extension/scannable/scannable = get_or_create_extension(src, /datum/extension/scannable)
		scannable.associated_entry = "[lowertext(species.name)] (species)"
		scannable.scan_delay = 5 SECONDS
	else if(has_extension(src, /datum/extension/scannable))
		remove_extension(src, /datum/extension/scannable)

	return TRUE

/mob/living/carbon/human/synthetic/handle_mutations_and_radiation()
	if(radiation)
		radiation -= 1 * RADIATION_SPEED_COEFFICIENT

		if (radiation > 50)
			SSradiation.radiate(src, radiation * 0.01)

		if(radiation > 500)
			add_chemical_effect(CE_GLOWINGEYES, 1)

/mob/living/carbon/human/synthetic/handle_regular_status_updates()
	if(!handle_some_updates())
		return 0

	if(status_flags & GODMODE)	return 0

	//SSD check, if a logged player is awake put them back to sleep!
	if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
		blinded = 1
		set_status(STAT_SILENCE, 0)
	else				//ALIVE. LIGHTS ARE ON
		updatehealth()	//TODO

		if(handle_death_check())
			death()
			blinded = 1
			set_status(STAT_SILENCE, 0)
			return 1

		if(hallucination_power)
			handle_hallucinations()

		if(get_shock() >= species.total_health)
			if(!stat)
				to_chat(src, "<span class='warning'>[species.halloss_message_self]</span>")
				src.visible_message("<B>[src]</B> [species.halloss_message]")
			SET_STATUS_MAX(src, STAT_PARA, 10)

		if(HAS_STATUS(src, STAT_PARA) ||HAS_STATUS(src, STAT_ASLEEP))
			blinded = 1
			set_stat(UNCONSCIOUS)
			animate_tail_reset()
			adjustHalLoss(-3)
		//CONSCIOUS
		else
			set_stat(CONSCIOUS)

		// Check everything else.

		//Periodically double-check embedded_flag
		if(embedded_flag && !(life_tick % 10))
			if(!embedded_needs_process())
				embedded_flag = 0

		//Resting
		if(resting)
			if(HAS_STATUS(src, STAT_DIZZY))
				ADJ_STATUS(src, STAT_DIZZY, -15)
			if(HAS_STATUS(src, STAT_JITTER))
				ADJ_STATUS(src, STAT_JITTER, -15)
			adjustHalLoss(-3)
		else
			if(HAS_STATUS(src, STAT_DIZZY))
				ADJ_STATUS(src, STAT_DIZZY, -3)
			if(HAS_STATUS(src, STAT_JITTER))
				ADJ_STATUS(src, STAT_JITTER, -3)
			adjustHalLoss(-1)

		// If you're dirty, your gloves will become dirty, too.
		var/obj/item/gloves = get_equipped_item(slot_gloves_str)
		if(gloves && germ_level > gloves.germ_level && prob(10))
			gloves.germ_level += 1

		// nutrition decrease
		if(nutrition > 0)
			adjust_nutrition(-species.hunger_factor)
		if(hydration > 0)
			adjust_hydration(-species.thirst_factor)
	return 1

/mob/living/carbon/human/synthetic/handle_shock()
	if(!can_feel_pain() || (status_flags & GODMODE))
		shock_stage = 0
		return

	if(is_asystole())
		shock_stage = max(shock_stage + 1, 61)
	var/traumatic_shock = get_shock()
	if(traumatic_shock >= max(30, 0.8*shock_stage))
		shock_stage += 1
	else if (!is_asystole())
		shock_stage = min(shock_stage, 160)
		var/recovery = 1
		if(traumatic_shock < 0.5 * shock_stage) //lower shock faster if pain is gone completely
			recovery++
		if(traumatic_shock < 0.25 * shock_stage)
			recovery++
		shock_stage = max(shock_stage - recovery, 0)
		return
	if(stat) return 0

	if(shock_stage == 10)
		// Please be very careful when calling custom_pain() from within code that relies on pain/trauma values. There's the
		// possibility of a feedback loop from custom_pain() being called with a positive power, incrementing pain on a limb,
		// which triggers this proc, which calls custom_pain(), etc. Make sure you call it with nohalloss = TRUE in these cases!
		custom_pain("[pick("Pain imitation active")]!", 10, nohalloss = TRUE)

	if(a_intent == I_HURT)
		return

	if(shock_stage >= 30)
		if(shock_stage == 30)
			var/decl/pronouns/G = get_pronouns()
			visible_message("<b>\The [src]</b> is having trouble keeping [G.his] eyes open.")
		if(prob(30))
			SET_STATUS_MAX(src, STAT_STUTTER, 5)

	if (shock_stage >= 60)
		if(shock_stage == 60) visible_message("<b>[src]</b>'s body becomes limp.")
		if (prob(2))
			custom_pain("[pick("Your pain imitation levels are high")]!", shock_stage, nohalloss = TRUE)
			SET_STATUS_MAX(src, STAT_WEAK, 1)

	if(shock_stage >= 80)
		if (prob(5))
			custom_pain("[pick("Your sensors are signaling high levels of painful activity")]!", shock_stage, nohalloss = TRUE)
			SET_STATUS_MAX(src, STAT_WEAK, 1)

	if(shock_stage >= 120)
		if(!HAS_STATUS(src, STAT_PARA) && prob(2))
			custom_pain("[pick("Extreme pain mimicing levels reached")]!", shock_stage, nohalloss = TRUE)
			SET_STATUS_MAX(src, STAT_WEAK, 2)

	if(shock_stage == 150)
		visible_message("<b>[src]</b> can no longer stand, collapsing!")

	if(shock_stage >= 150)
		SET_STATUS_MAX(src, STAT_WEAK, 3)

/mob/living/carbon/human/synthetic/get_blood_saturation()
	return 1

/mob/living/carbon/human/synthetic/get_blood_perfusion()
	return 1

/mob/living/carbon/human/synthetic/consume_oxygen(amount)
	return 1

/mob/living/carbon/human/synthetic/jostle_internal_object(var/obj/item/organ/external/organ, var/obj/item/O)
	if(!organ.can_feel_pain())
		to_chat(src, SPAN_DANGER("Something is moving inside your [organ.name]."))
	else
		var/msg = pick( \
			SPAN_DANGER("Your [organ.name] sends warning messages as you bump [O] inside."), \
			SPAN_DANGER("Your movement jostles [O] in your [organ.name]. Sensors report damage."),       \
			SPAN_DANGER("Your movement jostles [O] in your [organ.name]. Sensors report damage."))
		custom_pain(msg,40,affecting = organ)
	organ.take_external_damage(rand(1,3) + O.w_class, DAM_EDGE, 0)

/mob/living/carbon/human/synthetic/help_shake_act(mob/living/carbon/M)
	if(src != M)
		..()
	else
		var/decl/pronouns/G = get_pronouns()
		visible_message( \
			SPAN_NOTICE("[src] examines [G.self]."), \
			SPAN_NOTICE("You check yourself for external damage.") \
			)

		for(var/obj/item/organ/external/org in get_external_organs())
			var/list/status = list()

			var/feels = 1 + round(org.pain/100, 0.1)
			var/brutedamage = org.brute_dam * feels
			var/burndamage = org.burn_dam * feels

			switch(brutedamage)
				if(1 to 20)
					status += "is mechanically damaged"
				if(20 to 40)
					status += "has major mechanical damage"
				if(40 to INFINITY)
					status += "does not respond to prompts"

			switch(burndamage)
				if(1 to 20)
					status += "has minor electrical damage"
				if(20 to 40)
					status += "electronics are severely damaged"
				if(40 to INFINITY)
					status += "does not respond to prompts"

			if(org.status & ORGAN_MUTATED)
				status += "is misshapen"
			if(org.status & ORGAN_BROKEN)
				status += "primary chassis is misaligned"
			if(org.status & ORGAN_DEAD)
				status += "is irrecoverably damaged"
			if(!org.is_usable() || org.is_dislocated())
				status += "is unresponsive"
			if(status.len)
				src.show_message("Your system reports that [org.name] <span class='warning'>[english_list(status)].</span>",1)
			else
				src.show_message("Your system reports that [org.name] is <span class='notice'>OK.</span>",1)

/mob/living/carbon/human/synthetic/melee_accuracy_mods()
	. = 0
	if(incapacitated(INCAPACITATION_UNRESISTING))
		. += 100
	if(HAS_STATUS(src, STAT_BLIND))
		. += 75
	if(HAS_STATUS(src, STAT_BLURRY))
		. += 15
	if(HAS_STATUS(src, STAT_CONFUSE))
		. += 30

/mob/living/carbon/human/synthetic/ranged_accuracy_mods()
	. = 0
	if(HAS_STATUS(src, STAT_JITTER))
		. -= 2
	if(HAS_STATUS(src, STAT_CONFUSE))
		. -= 2
	if(HAS_STATUS(src, STAT_BLIND))
		. -= 5
	if(HAS_STATUS(src, STAT_BLURRY))
		. -= 1
	if(skill_check(SKILL_WEAPONS, SKILL_ADEPT))
		. += 1
	if(skill_check(SKILL_WEAPONS, SKILL_EXPERT))
		. += 1
	if(skill_check(SKILL_WEAPONS, SKILL_PROF))
		. += 2

/mob/living/carbon/human/synthetic/get_movement_delay(travel_dir)
	var/tally = 0
	if(isturf(loc))
		var/turf/T = loc
		tally += T.get_movement_delay(travel_dir)
	if(HAS_STATUS(src, STAT_DROWSY))
		tally += 6
	if(lying) //Crawling, it's slower
		tally += (8 + ((GET_STATUS(src, STAT_WEAK) * 3) + (GET_STATUS(src, STAT_CONFUSE) * 2)))
	tally += move_intent.move_delay + (0.35 * encumbrance())

	var/obj/item/organ/external/H = GET_EXTERNAL_ORGAN(src, BP_GROIN) // gets species slowdown, which can be reset by robotize()
	if(H)
		tally += H.slowdown

	tally += species.handle_movement_delay_special(src)

	if(!has_gravity())
		if(skill_check(SKILL_EVA, SKILL_PROF))
			tally -= 2
		tally -= 1

	tally -= GET_CHEMICAL_EFFECT(src, CE_SPEEDBOOST)
	tally += GET_CHEMICAL_EFFECT(src, CE_SLOWDOWN)

	if(can_feel_pain() && a_intent != I_HURT)
		if(get_shock() >= 10) tally += (get_shock() / 10) //pain shouldn't slow you down if you can't even feel it

	if(istype(buckled, /obj/structure/bed/chair/wheelchair))
		for(var/organ_name in list(BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM))
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, organ_name)
			tally += E ? E.get_movement_delay(4) : 4
	else
		var/total_item_slowdown = -1
		for(var/slot in global.all_inventory_slots)
			var/obj/item/I = get_equipped_item(slot)
			if(istype(I))
				var/item_slowdown = 0
				item_slowdown += I.slowdown_general
				item_slowdown += LAZYACCESS(I.slowdown_per_slot, slot)
				item_slowdown += I.slowdown_accessory
				total_item_slowdown += max(item_slowdown, 0)
		tally += total_item_slowdown

		for(var/organ_name in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, organ_name)
			tally += E ? E.get_movement_delay(4) : 4

	if(is_asystole())
		tally += 10 // Heart attacks are kinda distracting.

	if(aiming && aiming.aiming_at)
		tally += 5 // Iron sights make you slower, it's a well-known fact.

	if(facing_dir)
		tally += 3 // Locking direction will slow you down.

	//if (bodytemperature < species.cold_discomfort_level)
	//	tally += (species.cold_discomfort_level - bodytemperature) / 10 * 1.75

	tally += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow

	if(mRun in mutations)
		tally = 0

	return (tally+config.human_delay)