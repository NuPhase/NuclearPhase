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
	faction = "silicon"

/mob/living/carbon/human/synthetic/process_hemodynamics()
	var/obj/item/organ/internal/heart/heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
	bpm = heart.pulse + heart.external_pump
	tpvr = rand(210, 220)
	if(bpm)
		syspressure = rand(115, 120)
		dyspressure = rand(75, 80)
		mcv = NORMAL_MCV + rand(-10, 10)
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

		if(get_shock() >= 1000  && a_intent != I_HURT)
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
		custom_pain("[pick("Pain imitation active")]!", 150, nohalloss = TRUE)

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
			custom_pain("[pick("Your pain imitation levels are high")]!", 250, nohalloss = TRUE)
			SET_STATUS_MAX(src, STAT_WEAK, 1)

	if(shock_stage >= 80)
		if (prob(5))
			custom_pain("[pick("Your sensors are signaling high levels of painful activity")]!", 450, nohalloss = TRUE)
			SET_STATUS_MAX(src, STAT_WEAK, 1)

	if(shock_stage >= 120)
		if(!HAS_STATUS(src, STAT_PARA) && prob(2))
			custom_pain("[pick("Extreme pain mimicing levels reached")]!", 750, nohalloss = TRUE)
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
		custom_pain(msg,450,affecting = organ)
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
		if(get_shock() >= 50) tally += (get_shock() / 100) //pain shouldn't slow you down if you can't even feel it

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

	return (tally+get_config_value(/decl/config/num/movement_human))

/mob/living/carbon/human/synthetic/handle_environment(datum/gas_mixture/environment)

	SHOULD_CALL_PARENT(FALSE)

	if(!environment || (MUTATION_SPACERES in mutations))
		return

	//Stuff like water absorbtion happens here.
	species.handle_environment_special(src)

	//Moved pressure calculations here for use in skip-processing check.
	var/pressure = environment.return_pressure()
	var/adjusted_pressure = calculate_affecting_pressure(pressure)

	//Check for contaminants before anything else because we don't want to skip it.
	for(var/g in environment.gas)
		var/decl/material/mat = GET_DECL(g)
		if((mat.gas_flags & XGM_GAS_CONTAMINANT) && environment.gas[g] > mat.gas_overlay_limit + 1)
			handle_contaminants()
			break

	if(isspaceturf(src.loc)) //being in a closet will interfere with radiation, may not make sense but we don't model radiation for atoms in general so it will have to do for now.
		//Don't bother if the temperature drop is less than 0.1 anyways. Hopefully BYOND is smart enough to turn this constant expression into a constant
		if(bodytemperature > (0.1 * HUMAN_HEAT_CAPACITY/(HUMAN_EXPOSED_SURFACE_AREA*STEFAN_BOLTZMANN_CONSTANT))**(1/4) + COSMIC_RADIATION_TEMPERATURE)

			//Thermal radiation into space
			var/heat_gain = get_thermal_radiation(bodytemperature, HUMAN_EXPOSED_SURFACE_AREA, 0.5, SPACE_HEAT_TRANSFER_COEFFICIENT)

			var/temperature_gain = heat_gain/HUMAN_HEAT_CAPACITY
			bodytemperature += temperature_gain //temperature_gain will often be negative

	var/relative_density = (environment.total_moles/environment.volume) / (MOLES_CELLSTANDARD/CELL_VOLUME)
	if(relative_density > 0.02) //don't bother if we are in vacuum or near-vacuum
		var/loc_temp = environment.temperature

		if(adjusted_pressure < species.warning_high_pressure && adjusted_pressure > species.warning_low_pressure && abs(loc_temp - bodytemperature) < 20 && bodytemperature < species.heat_level_1 && bodytemperature > species.cold_level_1 && !failed_last_breath && species.body_temperature)
			pressure_alert = 0
			return // Temperatures are within normal ranges, fuck all this processing. ~Ccomp

		//Body temperature adjusts depending on surrounding atmosphere based on your thermal protection (convection)
		var/temp_adj = 0
		if(loc_temp < bodytemperature)			//Place is colder than we are
			var/thermal_protection = get_cold_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR)	//this will be negative
		else if (loc_temp > bodytemperature)			//Place is hotter than we are
			var/thermal_protection = get_heat_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR)

		//Use heat transfer as proportional to the gas density. However, we only care about the relative density vs standard 101 kPa/20 C air. Therefore we can use mole ratios
		bodytemperature += between(BODYTEMP_COOLING_MAX, temp_adj*relative_density, BODYTEMP_HEATING_MAX)

	if(failed_last_breath) //no air cooling :(
		if(hydration) //gotta watercool
			adjust_hydration(SYNTHETIC_THIRST_FACTOR * -5)
		else
			bodytemperature += 30 //no water cooling :(

	// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
	if(bodytemperature >= getSpeciesOrSynthTemp(HEAT_LEVEL_1))
		//Body temperature is too hot.
		fire_alert = max(fire_alert, 1)
		if(status_flags & GODMODE)	return 1	//godmode
		var/burn_dam = (bodytemperature - species.heat_level_1) * 0.03
		take_overall_damage(burn=burn_dam, used_weapon = "High Body Temperature", armor_pen = 200)
		fire_alert = max(fire_alert, 2)

	else if(bodytemperature <= getSpeciesOrSynthTemp(COLD_LEVEL_1))
		fire_alert = max(fire_alert, 1)
		if(status_flags & GODMODE)	return 1	//godmode

		var/burn_dam = (species.heat_level_1 - bodytemperature) * 0.02
		take_overall_damage(burn=burn_dam, used_weapon = "Low Body Temperature", armor_pen = 200)
		var/obj/item/organ/external/victim = pick(internal_organs)
		victim.germ_level += burn_dam
		fire_alert = max(fire_alert, 1)

	// Account for massive pressure differences.  Done by Polymorph
	// Made it possible to actually have something that can protect against high pressure... Done by Errorage. Polymorph now has an axe sticking from his head for his previous hardcoded nonsense!
	if(status_flags & GODMODE)	return 1	//godmode

	if(adjusted_pressure >= species.hazard_high_pressure)
		var/pressure_damage = min( ( (adjusted_pressure / species.hazard_high_pressure) -1 )*PRESSURE_DAMAGE_COEFFICIENT , MAX_HIGH_PRESSURE_DAMAGE)
		take_overall_damage(brute=pressure_damage, used_weapon = "High Pressure", armor_pen = 15)
		pressure_alert = 2
	else if(adjusted_pressure >= species.warning_high_pressure)
		pressure_alert = 1
	else if(adjusted_pressure >= species.warning_low_pressure)
		pressure_alert = 0
	else if(adjusted_pressure >= species.hazard_low_pressure)
		pressure_alert = -1
	else
		var/list/obj/item/organ/external/parts = get_damageable_organs()
		for(var/obj/item/organ/external/O in parts)
			if(QDELETED(O) || !(O.owner == src))
				continue
			if(O.damage + (LOW_PRESSURE_DAMAGE) < O.min_broken_damage) //vacuum does not break bones
				O.take_external_damage(brute = LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")
		pressure_alert = -2
		overlay_fullscreen("brute", /obj/screen/fullscreen/brute, 6)
	return

/mob/living/carbon/human/synthetic/verb/remove_masking_layer()
	set name = "Remove Masking Layer"
	set desc = "Remove your masking skin layer."
	set category = "Synthetic"

	var/list/chosen_organs = tgui_input_checkboxes(usr, "Choose limbs to unmask.", "Limb unmasking", list(BP_CHEST, BP_GROIN, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND))
	if(!length(chosen_organs))
		return
	for(var/org_tag in chosen_organs)
		var/obj/item/organ/external/ext_organ = GET_EXTERNAL_ORGAN(usr, org_tag)
		ext_organ.masking = FALSE
		ext_organ.update_icon()

/mob/living/carbon/human/synthetic/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SynthOS", "Synthetic Operating Software")
		ui.open()

/mob/living/carbon/human/synthetic/tgui_data(mob/user)
	var/list/data = list(
		"externalorganlist" = assemble_external_organ_list(),
		"internalorganlist" = assemble_internal_organ_list(),
		"body_temperature" = round(bodytemperature, 0.1),
		"water_consumption" = 17.4, //fixed for now
		"water_level" = round(hydration / initial(hydration) * 100),
		"nutrient_level" = round(nutrition / initial(nutrition) * 100)
	)
	return data

/mob/living/carbon/human/synthetic/proc/assemble_external_organ_list()
	var/organ_list = list()
	for(var/obj/item/organ/O in get_external_organs())
		var/damage_percentage = 100
		if(O.damage)
			damage_percentage = abs(1 - O.damage / O.max_damage) * 100
		organ_list += list(list("name" = O.name, "damage_percentage" = round(damage_percentage), "is_critical" = O.vital, "dead" = O.is_broken()))
	return organ_list

/mob/living/carbon/human/synthetic/proc/assemble_internal_organ_list()
	var/organ_list = list()
	for(var/obj/item/organ/O in get_internal_organs())
		var/damage_percentage = 100
		if(O.damage)
			damage_percentage = abs(1 - O.damage / O.max_damage) * 100
		organ_list += list(list("name" = O.name, "damage_percentage" = round(damage_percentage), "is_critical" = O.vital, "dead" = O.is_broken()))
	return organ_list

/mob/living/carbon/human/synthetic/verb/open_ui()
	set name = "Open OS Interface"
	set desc = "Check your status."
	set category = "Synthetic"

	tgui_interact(usr)