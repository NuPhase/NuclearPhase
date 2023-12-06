/obj/item/organ/internal/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	prosthetic_icon = "kidneys-prosthetic"
	gender = PLURAL
	organ_tag = BP_KIDNEYS
	parent_organ = BP_GROIN
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	relative_size = 10
	oxygen_consumption = 0.8
	oxygen_deprivation_tick = 0.2

/obj/item/organ/internal/kidneys/Process()
	..()

	if(!owner)
		return

	if(owner.get_blood_perfusion() < 0.8)
		var/pressure_difference = 100 - owner.meanpressure
		var/secretion_efficiency_coeff = max(0.01, 1 - (damage / max_damage) - (oxygen_deprivation / 100))
		if(pressure_difference > 0)
			owner.bloodstr.add_reagent_max(/decl/material/liquid/adrenaline, pressure_difference * 0.004 * secretion_efficiency_coeff, pressure_difference * 0.0013)
			owner.bloodstr.add_reagent_max(/decl/material/liquid/noradrenaline, pressure_difference * 0.002 * secretion_efficiency_coeff, pressure_difference * 0.007)

	// Coffee is really bad for you with busted kidneys.
	// This should probably be expanded in some way, but fucked if I know
	// what else kidneys can process in our reagent list.
	if(REAGENT_VOLUME(owner.reagents, /decl/material/liquid/drink/coffee))
		if(is_bruised())
			owner.adjustToxLoss(0.1)
		else if(is_broken())
			owner.adjustToxLoss(0.3)

	if(is_bruised())
		if(prob(5) && REAGENT_VOLUME(reagents, /decl/material/solid/potassium) < 5)
			reagents.add_reagent(/decl/material/solid/potassium, REM*5)
	if(is_broken())
		if(REAGENT_VOLUME(owner.reagents, /decl/material/solid/potassium) < 15)
			owner.reagents.add_reagent(/decl/material/solid/potassium, REM*2)

	//If your kidneys aren't working, your body's going to have a hard time cleaning your blood.
	if(!GET_CHEMICAL_EFFECT(owner, CE_ANTITOX))
		if(prob(33))
			if(is_broken())
				owner.adjustToxLoss(0.2)
			if(status & ORGAN_DEAD)
				owner.adjustToxLoss(0.3)
			else
				owner.adjustToxLoss(-0.1)


