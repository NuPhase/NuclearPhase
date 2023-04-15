/obj/item/organ/internal/heart/synthetic
	name = "pulse imitation device"
	desc = "It looks like a simple vibration mechanism attached to a power source."
	icon_state = "cell"
	prosthetic_icon = "cell"
	prosthetic_dead_icon = "cell_bork"
	relative_size = 5
	organ_properties = ORGAN_PROP_PROSTHETIC
	weight = 0.3

/obj/item/organ/internal/heart/synthetic/handle_pulse()
	if(damage != max_damage)
		pulse = rand(55, 60)
	else
		pulse = 0

/obj/item/organ/internal/heart/synthetic/handle_heartbeat()
	return

/obj/item/organ/internal/heart/synthetic/calculate_instability()
	return