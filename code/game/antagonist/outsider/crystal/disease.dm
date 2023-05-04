/datum/ailment/crystal
	name = "Sentient Crystal Infection"
	applies_to_organ = list(BP_CHEST)
	specific_organ_subtype = /obj/item/organ/external/chest
	category = /datum/ailment/crystal
	var/was_triggered = FALSE //for stage transitions

/datum/ailment/crystal/begin_ailment_event()
	. = ..()
	was_triggered = TRUE

/datum/ailment/crystal/phase_one //mostly dormant, no symptoms
	scanner_diagnosis_string = "Visible sporadic clusters of dense matter."
	min_time = 5 MINUTES
	max_time = 30 MINUTES

/datum/ailment/crystal/phase_one/begin_ailment_event()
	. = ..()
	if(was_triggered)
		organ.add_ailment(/datum/ailment/crystal/phase_two)
		qdel(src)

/datum/ailment/crystal/phase_two //from this point it becomes contagious
	initial_ailment_message = "Your skin itches in strange patterns..."
	manual_diagnosis_string = "There are some barely noticeable swollen red lumps on $USER_HIS$ body."
	scanner_diagnosis_string = "Visible moving chunks of strange dense matter."
	min_time = 5 MINUTES
	max_time = 10 MINUTES

/datum/ailment/crystal/phase_two/begin_ailment_event()
	. = ..()
	if(was_triggered)
		organ.add_ailment(/datum/ailment/crystal/phase_three)
		qdel(src)

/datum/ailment/crystal/phase_three //radiation, severe psychological effects, visible crystals on the body, highly contagious
	initial_ailment_message = "The pain slowly subsides, you start enjoying the severe inflamation on your body. It's a part of you now."
	manual_diagnosis_string = "There are strange crystals embedded into $USER_HIS$ flesh."
	scanner_diagnosis_string = "Dense moving structures of unknown origin."
	min_time = 3 MINUTES
	max_time = 5 MINUTES

/datum/ailment/crystal/phase_three/begin_ailment_event()
	. = ..()
	if(was_triggered)
		organ.add_ailment(/datum/ailment/crystal/phase_four)
		qdel(src)

/datum/ailment/crystal/phase_three/on_ailment_event()
	SSradiation.radiate(organ.owner, 15)

/datum/ailment/crystal/phase_four //insanity, agression, latches on surfaces upon death
	initial_ailment_message = "They don't understand, they'll take it from you! Stop them!"
	min_time = 1 MINUTE
	max_time = 5 MINUTES

/datum/ailment/crystal/phase_four/on_ailment_event()
	SSradiation.radiate(organ.owner, 40)