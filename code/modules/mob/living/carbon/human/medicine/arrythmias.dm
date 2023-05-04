/decl/arrythmia
	var/name = ""

	var/cardiac_output_mod = 1

	var/evolves_into = null
	var/degrades_into = null

	var/evolve_time = 2 MINUTES

	var/can_be_shocked = FALSE //can it be cured with a defib
	var/can_appear = TRUE

	var/required_instability = 100

/decl/arrythmia/proc/on_spawn(var/mob/living/carbon/human/M, var/obj/item/organ/internal/heart/H)
	return

/decl/arrythmia/proc/get_pulse_mod()
	return 0

/decl/arrythmia/proc/can_appear(var/obj/item/organ/internal/heart/H)
	if(!(GET_DECL(/decl/arrythmia/asystole) in H.arrythmias))
		return can_appear
	return FALSE


/decl/arrythmia/atrial_flaunt
	name = "Atrial Flaunt"
	cardiac_output_mod = 0.95
	required_instability = 20
	evolves_into = /decl/arrythmia/atrial_fibrillation

/decl/arrythmia/atrial_flaunt/get_pulse_mod()
	return rand(-20, 20)

/decl/arrythmia/atrial_fibrillation
	name = "Atrial Fibrillation"
	cardiac_output_mod = 0.9
	required_instability = 30
	degrades_into = /decl/arrythmia/atrial_flaunt
	can_appear = FALSE

/decl/arrythmia/atrial_fibrillation/get_pulse_mod()
	return rand(20, 70)


/decl/arrythmia/tachycardia
	name = "Tachycardia"
	cardiac_output_mod = 0.9
	required_instability = 15
	evolves_into = /decl/arrythmia/paroxysmal_tachycardia

/decl/arrythmia/tachycardia/get_pulse_mod()
	return rand(40, 90)

/decl/arrythmia/paroxysmal_tachycardia
	name = "Paroxysmal Tachycardia"
	cardiac_output_mod = 0.8
	required_instability = 30
	degrades_into = /decl/arrythmia/tachycardia
	can_appear = FALSE

/decl/arrythmia/paroxysmal_tachycardia/get_pulse_mod()
	return rand(90, 140)


/decl/arrythmia/ventricular_flaunt
	name = "Ventricular Flaunt"
	cardiac_output_mod = 0.35
	required_instability = 60
	evolves_into = /decl/arrythmia/ventricular_fibrillation
	evolve_time = 30 SECONDS
	can_be_shocked = TRUE

/decl/arrythmia/ventricular_flaunt/get_pulse_mod()
	return rand(100, 200)

/decl/arrythmia/ventricular_flaunt/can_appear(var/obj/item/organ/internal/heart/H)
	if(!(GET_DECL(/decl/arrythmia/ventricular_fibrillation) in H.arrythmias) && !(GET_DECL(/decl/arrythmia/asystole) in H.arrythmias))
		return TRUE
	return FALSE

/decl/arrythmia/ventricular_fibrillation
	name = "Ventricular Fibrillation"
	cardiac_output_mod = 0.1
	required_instability = 70
	degrades_into = /decl/arrythmia/ventricular_flaunt
	evolves_into = /decl/arrythmia/asystole
	evolve_time = 1 MINUTE
	can_be_shocked = TRUE
	can_appear = FALSE

/decl/arrythmia/ventricular_fibrillation/get_pulse_mod()
	return rand(200, 300)


/decl/arrythmia/asystole
	name = "Asystole"
	cardiac_output_mod = 0.01
	required_instability = 80
	can_appear = FALSE

/decl/arrythmia/asystole/get_pulse_mod()
	return -1000 //live no more

/decl/arrythmia/asystole/on_spawn(var/mob/living/carbon/human/M, var/obj/item/organ/internal/heart/H)
	H.arrythmias.Cut()