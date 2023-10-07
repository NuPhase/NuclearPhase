/mob/living/carbon/human/proc/adjust_arousal(amount)
	arousal = clamp(arousal + amount, 0, 1000)

/mob/living/carbon/human/proc/adjust_pleasure(amount)
	var/arousal_modifier = MAX_AROUSAL_PLEASURE_MODIFIER * (arousal / 1000)
	pleasure = clamp(pleasure + amount * arousal_modifier, 0, 1000)