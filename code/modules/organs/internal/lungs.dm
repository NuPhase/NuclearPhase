/datum/composite_sound/breath_sound
	mid_sounds = list()
	mid_length = 22
	volume = 25
	distance = -6
	direct = TRUE
	var/obj/item/organ/internal/lungs/our_lungs

/datum/composite_sound/breath_sound/New(list/_output_atoms, start_immediately, _direct, _our_lungs)
	output_atoms = _output_atoms
	direct = _direct
	our_lungs = _our_lungs
	start()

/datum/composite_sound/breath_sound/play(soundfile)
	if(!soundfile)
		return
	. = ..()

/datum/composite_sound/breath_sound/get_sound()
	if(!our_lungs.owner)
		return
	var/obj/item/clothing/mask/mask = our_lungs.owner.get_equipped_item(slot_wear_mask_str)
	return our_lungs.get_breathing_sound(mask, our_lungs.last_breath_efficiency)

/obj/item/organ/internal/lungs
	name = "lungs"
	icon_state = "lungs"
	prosthetic_icon = "lungs-prosthetic"
	gender = PLURAL
	organ_tag = BP_LUNGS
	parent_organ = BP_CHEST
	w_class = ITEM_SIZE_NORMAL
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	relative_size = 60

	var/active_breathing = 1
	var/has_gills = FALSE
	var/breath_type
	var/exhale_type
	var/list/poison_types

	var/min_breath_pressure
	var/last_int_pressure
	var/last_ext_pressure
	var/max_pressure_diff = 240 //temporary, over a span of 1s

	var/ruptured = FALSE
	var/obj/item/chest_tube/chest_tube = null

	var/safe_exhaled_max = 6
	var/safe_toxins_max = 0.2
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/last_successful_breath
	var/breath_fail_ratio // How badly they failed a breath. Higher is worse.
	oxygen_consumption = 1
	var/oxygen_generation = 1.86 // default per breath
	var/breath_rate = 16 //per minute
	var/last_breath_efficiency = 1
	var/datum/composite_sound/breath_sound/soundloop

/obj/item/organ/internal/lungs/Destroy()
	. = ..()
	qdel(soundloop)

/obj/item/organ/internal/lungs/rejuvenate(ignore_prosthetic_prefs)
	. = ..()
	ruptured = FALSE

/obj/item/organ/internal/lungs/Initialize(mapload, material_key, datum/dna/given_dna)
	. = ..()
	soundloop = new(_output_atoms=list(src), _our_lungs=src)
	if(ishuman(owner))
		spawn(50) //ugly workaround, lungs don't have post initialize proc
			oxygen_generation += owner.get_skill_value(SKILL_FITNESS) * 0.08

/obj/item/organ/internal/lungs/proc/can_drown()
	return (is_broken() || !has_gills)

// Returns a percentage value for use by GetOxyloss().
/obj/item/organ/internal/lungs/proc/get_oxygen_deprivation()
	if(status & ORGAN_DEAD)
		return 100
	return oxygen_deprivation

/obj/item/organ/internal/lungs/set_species(species_name)
	. = ..()
	sync_breath_types()

/**
 *  Set these lungs' breath types based on the lungs' species
 */
/obj/item/organ/internal/lungs/proc/sync_breath_types()
	if(species)
		max_pressure_diff =   species.max_pressure_diff
		min_breath_pressure = species.breath_pressure
		breath_type =         species.breath_type  || /decl/material/gas/oxygen
		poison_types =        species.poison_types || list(/decl/material/gas/chlorine = TRUE)
		exhale_type =         species.exhale_type  || /decl/material/gas/carbon_dioxide
	else
		max_pressure_diff =   initial(max_pressure_diff)
		min_breath_pressure = initial(min_breath_pressure)
		breath_type =         /decl/material/gas/oxygen
		poison_types =        list(/decl/material/gas/chlorine = TRUE)
		exhale_type =         /decl/material/gas/carbon_dioxide

/obj/item/organ/internal/lungs/Process()
	..()
	if(!owner)
		return

	if (germ_level > INFECTION_LEVEL_ONE && active_breathing)
		if(prob(5))
			owner.emote("cough")		//respitory tract infection

	if(ruptured && !owner.is_asystole())
		if(prob(2))
			if(active_breathing)
				owner.visible_message(
					"<B>\The [owner]</B> coughs up blood!",
					"<span class='warning'>You cough up blood!</span>",
					"You hear someone coughing!",
				)
			else
				var/obj/item/organ/parent = GET_EXTERNAL_ORGAN(owner, parent_organ)
				owner.visible_message(
					"blood drips from <B>\the [owner]'s</B> [parent.name]!",
				)

			owner.drip(1)
		if(prob(4))
			if(active_breathing)
				owner.visible_message(
					"<B>\The [owner]</B> gasps for air!",
					"<span class='danger'>You can't breathe!</span>",
					"You hear someone gasp for air!",
				)
			else
				to_chat(owner, "<span class='danger'>You're having trouble getting enough [breath_type]!</span>")

			owner.losebreath = max(3, owner.losebreath)

/obj/item/organ/internal/lungs/proc/rupture()
	var/obj/item/organ/external/parent = GET_EXTERNAL_ORGAN(owner, parent_organ)
	if(istype(parent))
		owner.custom_pain("You feel a stabbing pain in your [parent.name]!", 50, affecting = parent)
	ruptured = TRUE

//exposure to extreme pressures can rupture lungs
/obj/item/organ/internal/lungs/proc/check_rupturing(breath_pressure)
	if(isnull(last_int_pressure))
		last_int_pressure = breath_pressure
		return
	var/datum/gas_mixture/environment = loc.return_air()
	var/ext_pressure = environment && environment.return_pressure() // May be null if, say, our owner is in nullspace
	var/int_pressure_diff = abs(last_int_pressure - breath_pressure)
	var/ext_pressure_diff = abs(last_ext_pressure - ext_pressure) * owner.get_pressure_weakness(ext_pressure)
	if(int_pressure_diff > max_pressure_diff && ext_pressure_diff > max_pressure_diff)
		var/lung_rupture_prob = BP_IS_PROSTHETIC(src) ? prob(30) : prob(60) //Robotic lungs are less likely to rupture.
		if(!ruptured && lung_rupture_prob) //only rupture if NOT already ruptured
			rupture()

/obj/item/organ/internal/lungs/take_internal_damage(amount, silent)
	. = ..()
	if(ruptured)
		return
	var/lung_rupture_prob = BP_IS_PROSTHETIC(src) ? prob(30) : prob(60)
	if(amount > 10 && lung_rupture_prob)
		rupture()

/obj/item/organ/internal/lungs/proc/handle_breath(datum/gas_mixture/breath, var/forced)

	if(!owner)
		return 1

	if(!breath || (max_damage <= 0) || oxygen_deprivation)
		breath_fail_ratio = 1
		handle_failed_breath()
		breath_rate = 0
		return 1

	var/breath_pressure = breath.return_pressure()
	check_rupturing(breath_pressure)

	var/datum/gas_mixture/environment = loc.return_air()
	last_ext_pressure = environment && environment.return_pressure()
	last_int_pressure = breath_pressure
	if(breath.total_moles == 0)
		breath_fail_ratio = 1
		handle_failed_breath()
		return 1

	var/safe_pressure_min = min_breath_pressure // Minimum safe partial pressure of breathable gas in kPa
	// Lung damage increases the minimum safe pressure.
	safe_pressure_min *= 1 + rand(1,2) * damage/max_damage
	if(ruptured)
		if(!chest_tube)
			safe_pressure_min *= 1.4 //one lung collapsed
		else
			safe_pressure_min *= 1.1 //helps a little

	if(owner.lying)
		safe_pressure_min *= 0.8

	var/failed_inhale = 0
	var/failed_exhale = 0

	var/inhaling = breath.gas[breath_type]
	var/inhale_efficiency = min(round(((inhaling/breath.total_moles)*breath_pressure)/safe_pressure_min, 0.001), 3)
	last_breath_efficiency = inhale_efficiency

	// Not enough to breathe
	if(inhale_efficiency < 0.6)
		if(prob(20) && active_breathing)
			if(inhale_efficiency < 0.6)
				owner.emote("gasp")
			else if(prob(20))
				to_chat(owner, SPAN_WARNING("It's hard to breathe..."))
		breath_fail_ratio = Clamp(0,(1 - inhale_efficiency + breath_fail_ratio)/2,1)
		failed_inhale = 1
	else
		if(breath_fail_ratio && prob(20))
			to_chat(owner, SPAN_NOTICE("It gets easier to breathe."))
		breath_fail_ratio = Clamp(0,breath_fail_ratio-0.05,1)

	owner.oxygen_alert = failed_inhale * 2

	var/inhaled_gas_used = inhaling / 4
	breath.adjust_gas(breath_type, -inhaled_gas_used, update = 0) //update afterwards

	owner.toxins_alert = 0 // Reset our toxins alert for now.
	if(!failed_inhale) // Enough gas to tell we're being poisoned via chemical burns or whatever.
		var/poison_total = 0
		if(poison_types)
			for(var/gname in breath.gas)
				if(poison_types[gname])
					poison_total += breath.gas[gname]
		if(((poison_total/breath.total_moles)*breath_pressure) > safe_toxins_max)
			owner.toxins_alert = 1

	// Pass reagents from the gas into our body.
	// Presumably if you breathe it you have a specialized metabolism for it, so we drop/ignore breath_type. Also avoids
	// humans processing thousands of units of oxygen over the course of a round.
	var/ratio = BP_IS_PROSTHETIC(src)? 0.66 : 1
	for(var/gasname in breath.gas - breath_type)
		var/decl/material/gas = GET_DECL(gasname)
		if(gas.gas_metabolically_inert)
			continue
		var/reagent_amount = breath.gas[gasname] * gas.molar_volume * ratio
		owner.reagents.add_reagent(gasname, reagent_amount)
		breath.adjust_gas(gasname, -breath.gas[gasname], update = 0) //update after

	// Moved after reagent injection so we don't instantly poison ourselves with CO2 or whatever.
	var/obj/item/clothing/mask/mask = owner.get_equipped_item(slot_wear_mask_str)
	if(exhale_type && (!istype(mask) || !(exhale_type in mask.filtered_gases)))
		breath.adjust_gas_temp(exhale_type, inhaled_gas_used, owner.bodytemperature, update = 0) //update afterwards

	// Were we able to breathe?
	var/failed_breath = failed_inhale || failed_exhale
	if(!failed_breath || forced)
		calculate_breath_rate()
		owner.add_oxygen(oxygen_generation * breath_rate * inhale_efficiency)
		last_successful_breath = world.time
		owner.adjustOxyLoss(-5 * inhale_efficiency)

	handle_temperature_effects(breath)
	breath.update_values()

	if(failed_breath)
		handle_failed_breath()
	else
		owner.oxygen_alert = 0
	return failed_breath

/obj/item/organ/internal/lungs/proc/get_breathing_sound(obj/item/clothing/mask/mask, efficiency)
	if(!mask || !(mask.item_flags & ITEM_FLAG_AIRTIGHT))
		if(owner.gender == MALE)
			switch(breath_rate)
				if(30 to 45)
					if(efficiency < 0.75)
						return 'sound/voice/breath/30_male_75.wav'
				if(45 to 60)
					return 'sound/voice/breath/60_male.wav'
				if(60 to INFINITY)
					return 'sound/voice/breath/75_male.wav'
		else
			if(breath_rate > 30)
				return 'sound/voice/breath/60_female.wav'
	else
		if(owner.internal)
			return 'sound/voice/breath/mask_tank_breathing.wav'
		else
			return 'sound/voice/breath/mask_breathing.wav'

/obj/item/organ/internal/lungs/proc/calculate_breath_rate()
	if(!last_int_pressure)
		breath_rate = 0
		return
	breath_rate = initial(breath_rate)
	breath_rate += GET_CHEMICAL_EFFECT(owner, CE_BREATHLOSS)
	breath_rate += min(25, owner.shock_stage * 0.1)
	var/breath_rate_delta = owner.max_oxygen_capacity - owner.oxygen_amount
	breath_rate += breath_rate_delta * 0.14

/obj/item/organ/internal/lungs/proc/handle_failed_breath()
	if(oxygen_deprivation && prob(15))
		if(!owner.is_asystole())
			if(active_breathing)
				owner.emote("gasp")

	owner.oxygen_alert = max(owner.oxygen_alert, 2)
	last_int_pressure = 0

/obj/item/organ/internal/lungs/proc/handle_temperature_effects(datum/gas_mixture/breath)
	// Hot air hurts :(

	if(breath.temperature > species.heat_level_1)
		var/damage = (breath.temperature - species.heat_level_1) * 0.02
		if(damage > 5)
			owner.apply_damage(damage*0.1, BURN, BP_HEAD, used_weapon = "Excessive Heat")
		take_internal_damage(damage, TRUE)
		owner.fire_alert = 1

	if(breath.temperature < species.cold_level_1)
		var/damage = (species.heat_level_1 - breath.temperature) * 0.01
		if(damage > 5)
			owner.apply_damage(damage*0.1, BURN, BP_HEAD, used_weapon = "Excessive Cold")
		take_internal_damage(damage, TRUE)
		owner.fire_alert = 2

		//breathing in hot/cold air also heats/cools you a bit
		var/temp_adj = breath.temperature - owner.bodytemperature
		if (temp_adj < 0)
			temp_adj /= (BODYTEMP_COLD_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed
		else
			temp_adj /= (BODYTEMP_HEAT_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed

		var/relative_density = breath.total_moles / (MOLES_CELLSTANDARD * breath.volume/CELL_VOLUME)
		temp_adj *= relative_density

		if (temp_adj > BODYTEMP_HEATING_MAX) temp_adj = BODYTEMP_HEATING_MAX
		if (temp_adj < BODYTEMP_COOLING_MAX) temp_adj = BODYTEMP_COOLING_MAX
//		log_debug("Breath: [breath.temperature], [src]: [bodytemperature], Adjusting: [temp_adj]")
		owner.bodytemperature += temp_adj

	else if(breath.temperature >= species.heat_discomfort_level)
		species.get_environment_discomfort(owner,"heat")
	else if(breath.temperature <= species.cold_discomfort_level)
		species.get_environment_discomfort(owner,"cold")

/obj/item/organ/internal/lungs/listen(mob/user)
	if(owner.failed_last_breath || !active_breathing)
		return "no respiration"

	if(BP_IS_PROSTHETIC(src))
		if(ruptured)
			return "malfunctioning fans"
		else
			return "air flowing"

	. = list()
	if(ruptured)
		. += "weak [pick("wheezing", "gurgling")] on one side."

	if(ruptured || damage > 20)
		sound_to(user, sound('sound/voice/breath/lung_stridor.wav',0,0,0,35))
	else
		sound_to(user, sound('sound/voice/breath/lung_normal.wav',0,0,0,35))

	var/list/breathtype = list()
	if(get_oxygen_deprivation() > 10)
		breathtype += pick("straining","labored")
	if(owner.shock_stage > 50)
		breathtype += pick("shallow and rapid")
	if(!breathtype.len)
		breathtype += "healthy"

	. += "[english_list(breathtype)] respiration at [round(breath_rate, 1)] breaths per minute."

	return english_list(.)

/obj/item/organ/internal/lungs/gills
	name = "lungs and gills"
	has_gills = TRUE
