/datum/gas_mixture/proc/touch(var/atom/touching) //applies touch effects of everything inside the mixture
	if(!gas)
		return
	if(istype(touching, /mob/living/carbon))
		touch_mob(touching)
		return
	if(istype(touching, /turf/simulated))
		touch_turf(touching)
		return

/datum/gas_mixture/proc/touch_mob(var/mob/living/carbon/touching)
	for(var/g in gas)
		var/decl/material/mat = GET_DECL(g)
		mat.touch_mob(touching, gas[g] * mat.molar_volume)
		mat.affect_touch(touching, gas[g] * mat.molar_volume)

/datum/gas_mixture/proc/touch_turf(var/turf/simulated/touching)
	for(var/g in gas)
		var/decl/material/mat = GET_DECL(g)
		mat.touch_turf(touching, gas[g] * mat.molar_volume)

/datum/gas_mixture/proc/is_acidic() //whether the mixture is acidic
	for(var/g in gas)
		var/decl/material/mat = GET_DECL(g)
		if(mat.solvent_max_damage)
			return TRUE
	return FALSE

/datum/gas_mixture/proc/react()
	var/reaction_occured = FALSE
	var/atom/location = holder.loc
	var/list/eligible_reactions = list()
	var/list/reactants = list()
	var/reaction_speed = get_reaction_speed()
	for(var/g in gas)
		var/decl/material/mat = GET_DECL(g)
		reactants[mat] += gas[g] * mat.molar_volume
	if(!reactants)
		return

	for(var/decl/material/R in reactants)
		// Check if the reagent is decaying or not.
		var/list/replace_self_with
		var/replace_message
		var/replace_sound
		if(!isnull(R.chilling_point) && R.type != R.bypass_cooling_products_for_root_type && LAZYLEN(R.chilling_products) && temperature <= R.chilling_point)
			replace_self_with = R.chilling_products
			if(R.chilling_message)
				replace_message = "\The [lowertext(R.name)] [R.chilling_message]"
			replace_sound = R.chilling_sound
		else if(!isnull(R.heating_point) && R.type != R.bypass_heating_products_for_root_type && LAZYLEN(R.heating_products) && temperature >= R.heating_point)
			replace_self_with = R.heating_products
			if(R.heating_message)
				replace_message = "\The [lowertext(R.name)] [R.heating_message]"
			replace_sound = R.heating_sound

		if(replace_self_with)
			var/replace_amount = reactants[R] * reaction_speed
			adjust_gas(R, (!gas[R] * reaction_speed))
			for(var/product in replace_self_with)
				adjust_gas(product, replace_self_with[product] * replace_amount)
			reaction_occured = TRUE

			if(location)
				if(replace_message)
					location.visible_message("<span class='notice'>[html_icon(location)] [replace_message]</span>")
				if(replace_sound)
					playsound(location, pick(replace_sound), 80, 1)

		else // Otherwise, collect all possible reactions.
			eligible_reactions |= SSmaterials.chemical_reactions_by_id[R.type]
	var/list/active_reactions = list()
	for(var/decl/chemical_reaction/C in eligible_reactions)
		if(C.can_happen(src))
			active_reactions[C] = 1 // The number is going to be 1/(fraction of remaining reagents we are allowed to use), computed below
			reaction_occured = 1

	var/list/used_reagents = list()
	// if two reactions share a reagent, each is allocated half of it, so we compute this here
	for(var/decl/chemical_reaction/C in active_reactions)
		var/list/adding = C.get_used_reagents()
		for(var/R in adding)
			LAZYADD(used_reagents[R], C)

	for(var/R in used_reagents)
		var/counter = length(used_reagents[R])
		if(counter <= 1)
			continue // Only used by one reaction, so nothing we need to do.
		for(var/decl/chemical_reaction/C in used_reagents[R])
			active_reactions[C] = max(counter, active_reactions[C])
			counter-- //so the next reaction we execute uses more of the remaining reagents
			// Note: this is not guaranteed to maximize the size of the reactions we do (if one reaction is limited by reagent A, we may be over-allocating reagent B to it)
			// However, we are guaranteed to fully use up the most profligate reagent if possible.
			// Further reactions may occur on the next tick, when this runs again.

	for(var/thing in active_reactions)
		var/decl/chemical_reaction/C = thing
		C.process(src, active_reactions[C] * reaction_speed)

	for(var/thing in active_reactions)
		var/decl/chemical_reaction/C = thing
		C.post_reaction(src)

	update_values()
	if(reaction_occured)
		return TRUE
	return FALSE

/datum/gas_mixture/proc/get_reaction_speed() //A modifier for reaction speed. 0-1
	return 1