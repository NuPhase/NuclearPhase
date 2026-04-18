/*
Contians the proc to handle radiation.
Specifically made to do radiation burns.
*/


/mob/living/carbon/apply_radiation(damage)
	..()
	if(!isSynthetic() && !ignore_rads && damage > 100000)
		damage = 0.0000001 * damage * (species ? species.get_radiation_mod(src) : 1)
		adjustFireLoss(damage)
		updatehealth()
	return TRUE
