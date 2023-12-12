/mob/living/carbon/human/dummy
	real_name = "test dummy"
	status_flags = GODMODE|CANPUSH
	virtual_mob = null

/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	STOP_PROCESSING(SSmobs, src)
	global.human_mob_list -= src

/mob/living/carbon/human/dummy/selfdress/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		equip_to_appropriate_slot(I)

/mob/living/carbon/human/corpse
	real_name = "corpse"

/mob/living/carbon/human/corpse/Initialize(mapload, new_species, obj/abstract/landmark/corpse/corpse)

	. = ..(mapload, new_species)

	var/decl/cultural_info/culture = get_cultural_value(TAG_CULTURE)
	if(culture)
		var/newname = culture.get_random_name(src, gender, species.name)
		if(newname && newname != name)
			real_name = newname
			SetName(newname)
			if(mind)
				mind.name = real_name

	adjustOxyLoss(maxHealth)//cease life functions
	setBrainLoss(maxHealth)
	var/obj/item/organ/internal/heart/corpse_heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
	if(corpse_heart)
		corpse_heart.pulse = PULSE_NONE//actually stops heart to make worried explorers not care too much
	if(corpse)
		corpse.randomize_appearance(src, new_species)
		corpse.equip_outfit(src)
	update_icon()

/mob/living/carbon/human/dummy/mannequin/add_to_living_mob_list()
	return FALSE

/mob/living/carbon/human/dummy/mannequin/add_to_dead_mob_list()
	return FALSE

/mob/living/carbon/human/dummy/mannequin/fully_replace_character_name(new_name, in_depth = TRUE)
	..("[new_name] (mannequin)", FALSE)

/mob/living/carbon/human/dummy/mannequin/InitializeHud()
	return	// Mannequins don't get HUDs

/mob/living/carbon/human/monkey
	gender = PLURAL

/mob/living/carbon/human/monkey/Initialize(mapload)
	if(gender == PLURAL)
		gender = pick(MALE, FEMALE)
	. = ..(mapload, SPECIES_MONKEY)

/mob/living/carbon/human/training_dummy
	real_name = "training dummy"
	virtual_mob = null

/mob/living/carbon/human/training_dummy/emote(act, m_type, message)
	return

/mob/living/carbon/human/training_dummy/Initialize(mapload, species_name, datum/dna/new_dna)
	. = ..()
	global.human_mob_list -= src

/obj/item/training_dummy_controller
	name = "dummy controller"
	desc = "A controller for a medical training dummy."
	icon = 'icons/obj/items/device/locator_borg.dmi'
	var/mob/living/carbon/human/training_dummy/assigned_dummy = null

/obj/item/training_dummy_controller/attack(mob/living/M, mob/living/user, target_zone, animate)
	. = ..()
	if(istype(M, /mob/living/carbon/human/training_dummy))
		assigned_dummy = M
		to_chat(user, "Dummy reassigned.")

/obj/item/training_dummy_controller/attack_self(mob/user)
	. = ..()
	if(!assigned_dummy)
		return
	var/input = tgui_input_list(user, "Choose an action.", "Dummy Control", list("Reset Dummy", "Add Arrythmia", "Remove Arrythmias", "Clear Bloodstream", "Unique Condition"))
	var/obj/item/organ/internal/heart/H = GET_INTERNAL_ORGAN(assigned_dummy, BP_HEART)
	switch(input)
		if("Reset Dummy")
			assigned_dummy.rejuvenate()
		if("Add Arrythmia")
			var/list/sorted_arrythmias = list()
			for(var/decl/arrythmia/arr in subtypesof(/decl/arrythmia))
				arr = GET_DECL(arr)
				sorted_arrythmias[arr.name] = arr
			var/chosen_arrythmia = sorted_arrythmias[tgui_input_list(user, "Choose an arrythmia.", "Arrythmia Induction", sorted_arrythmias)]
			if(!chosen_arrythmia)
				return
			H.arrythmias.Cut()
			H.add_arrythmia(chosen_arrythmia)
		if("Remove Arrythmias")
			H.arrythmias.Cut()
		if("Clear Bloodstream")
			assigned_dummy.bloodstr.remove_any(5000)