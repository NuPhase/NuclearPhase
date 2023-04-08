/obj/item/organ/internal/heart/xenomorph //extremely fragile yet effective
	name = "pumping system"
	desc = "A complex net of blood vessels and muscles. It doesn't pulsate, but rather, it twitches constantly."
	max_damage = 20
	pulse = 340
	current_pattern = HEART_PATTERN_XENOMORPH
	oxygen_consumption = 5

/obj/item/organ/internal/heart/xenomorph/handle_pulse()
	if(damage != max_damage)
		pulse = rand(300, 600)
	else
		pulse = 0

/obj/item/organ/internal/heart/xenomorph/handle_heartbeat()
	return

/obj/item/organ/internal/heart/xenomorph/calculate_instability()
	return