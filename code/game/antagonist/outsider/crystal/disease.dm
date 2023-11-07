/datum/ailment/crystal
	name = "Sentient Crystal Infection"
	applies_to_organ = list(BP_CHEST)
	specific_organ_subtype = /obj/item/organ/external/chest
	category = /datum/ailment/crystal
	var/was_triggered = FALSE //for stage transitions

/datum/ailment/crystal/phase_one //mostly dormant, no symptoms
	scanner_diagnosis_string = "Visible sporadic clusters of dense matter."
	min_time = 5 MINUTES
	max_time = 30 MINUTES

/datum/ailment/crystal/phase_one/New(obj/item/organ/_organ)
	. = ..()
	spawn(rand(5 MINUTES, 30 MINUTES))
		_organ.add_ailment(/datum/ailment/crystal/phase_two)
		qdel(src)

/datum/ailment/crystal/phase_two //from this point it becomes contagious
	initial_ailment_message = "Your skin starts itching in strange patterns..."
	manual_diagnosis_string = "There are some barely noticeable swollen red lumps on $USER_HIS$ body."
	scanner_diagnosis_string = "Visible moving chunks of strange dense matter."
	min_time = 5 MINUTES
	max_time = 10 MINUTES

/datum/ailment/crystal/phase_two/New(obj/item/organ/_organ)
	. = ..()
	spawn(rand(5 MINUTES, 10 MINUTES))
		_organ.add_ailment(/datum/ailment/crystal/phase_three)
		qdel(src)

/datum/ailment/crystal/phase_three //radiation, severe psychological effects, visible crystals on the body, highly contagious
	initial_ailment_message = "The pain slowly subsides, you start enjoying the severe inflamation on your body. It's a part of you now."
	manual_diagnosis_string = "There are strange crystals embedded into $USER_HIS$ flesh."
	scanner_diagnosis_string = "Dense moving structures of unknown origin."
	min_time = 5 SECONDS
	max_time = 10 SECONDS

/datum/ailment/crystal/phase_three/New(obj/item/organ/_organ)
	. = ..()
	spawn(rand(3 MINUTES, 5 MINUTES))
		_organ.add_ailment(/datum/ailment/crystal/phase_four)

/datum/ailment/crystal/phase_three/on_ailment_event()
	SSradiation.radiate(organ.owner, 1500)
	var/list/limbs_to_infect = list(BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG)
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(organ.owner, pick(limbs_to_infect))
	if(!affecting || BP_IS_CRYSTAL(affecting))
		return
	affecting.take_external_damage(rand(3, 7))
	if(affecting.brute_dam > 25)
		BP_SET_CRYSTAL(affecting)
		affecting.rejuvenate()

/datum/ailment/crystal/phase_four //insanity, agression, latches on surfaces upon death
	initial_ailment_message = "They don't understand, they'll take it from you! Stop them, bring them the same knowledge!"
	min_time = 5 SECONDS
	max_time = 10 SECONDS

/datum/ailment/crystal/phase_four/on_ailment_event()
	var/list/limbs_to_infect = list(BP_GROIN, BP_CHEST, BP_HEAD, BP_L_ARM, BP_R_ARM)
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(organ.owner, pick(limbs_to_infect))
	if(affecting || !BP_IS_CRYSTAL(affecting))
		affecting.take_external_damage(rand(15, 25))
		if(affecting.brute_dam > 40)
			BP_SET_CRYSTAL(affecting)
			affecting.rejuvenate()

	var/obj/item/organ/external/destroying = GET_EXTERNAL_ORGAN(organ.owner, pick(BP_L_FOOT, BP_R_FOOT))
	if(destroying)
		destroying.take_external_damage(rand(5, 10))

	SSradiation.radiate(organ.owner, 4000)