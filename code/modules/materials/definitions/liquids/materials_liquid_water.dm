/decl/material/liquid/water
	name = "water"
	uid = "liquid_water"
	solid_name = "ice"
	lore_text = "A ubiquitous chemical substance composed of hydrogen and oxygen."
	color = COLOR_LIQUID_WATER
	gas_tile_overlay = "generic"
	gas_overlay_limit = 0.5
	gas_specific_heat = 36.5
	liquid_specific_heat = 75.6
	molar_mass = 0.018
	boiling_point = 103 CELSIUS
	melting_point = 0 CELSIUS
	latent_heat = 2258
	gas_condensation_point = 308.15 // 35C. Dew point is ~20C but this is better for gameplay considerations.
	gas_symbol_html = "H<sub>2</sub>O"
	gas_symbol = "H2O"
	scannable = 1
	metabolism = REM * 10
	taste_description = "clean water"
	glass_name = "water"
	glass_desc = "The father of all refreshments."
	slipperiness = 8
	dirtiness = DIRTINESS_CLEAN
	turf_touch_threshold = 0.1
	chilling_point = T0C
	chilling_products = list(
		/decl/material/solid/ice = 1
	)
	liquid_density = 997
	var/dirty_stage = 0 //0-5

/decl/material/liquid/water/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/list/data = REAGENT_DATA(holder, type)
		if(data && data["holy"])
			if(iscultist(M))
				if(prob(10))
					var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
					cult.offer_uncult(M)
				if(prob(2))
					var/obj/effect/spider/spiderling/S = new /obj/effect/spider/spiderling(M.loc)
					M.visible_message("<span class='warning'>\The [M] coughs up \the [S]!</span>")
			else
				var/decl/special_role/godcult = GET_DECL(/decl/special_role/godcultist)
				if(M.mind && godcult.is_antagonist(M.mind))
					if(REAGENT_VOLUME(holder, type) > 5)
						M.adjustHalLoss(5)
						M.adjustBruteLoss(1)
						if(prob(10)) //Only annoy them a /bit/
							to_chat(M,"<span class='danger'>You feel your insides curdle and burn!</span> \[<a href='?src=\ref[holder];deconvert=\ref[M]'>Give Into Purity</a>\]")

/decl/material/liquid/water/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	switch(dirty_stage)
		if(1)
			var/obj/item/organ/internal/stomach/S = GET_INTERNAL_ORGAN(M, BP_STOMACH)
			S.germ_level += removed
		if(2)
			var/obj/item/organ/internal/stomach/S = GET_INTERNAL_ORGAN(M, BP_STOMACH)
			S.germ_level += removed * 2
			M.custom_pain("Something is not right with this liquid...", 10)
		if(3)
			var/obj/item/organ/internal/stomach/S = GET_INTERNAL_ORGAN(M, BP_STOMACH)
			S.germ_level += removed * 2
			M.add_chemical_effect(CE_TOXIN, removed * 0.5)
			M.custom_pain("Drinking this is extremely unpleasant...", 10)
		if(4)
			var/obj/item/organ/internal/stomach/S = GET_INTERNAL_ORGAN(M, BP_STOMACH)
			S.germ_level += removed * 10
			M.add_chemical_effect(CE_TOXIN, removed)
			M.custom_pain("This liquid tastes disgusting!", 15)
		if(5)
			var/obj/item/organ/internal/stomach/S = GET_INTERNAL_ORGAN(M, BP_STOMACH)
			S.germ_level += removed * 10
			M.add_chemical_effect(CE_TOXIN, removed*2)
			M.add_chemical_effect(CE_ALCOHOL, removed*5)
			M.custom_pain("You feel the walls of your esophagus eroding and burning!", 35)

	M.adjust_hydration(removed * 10)
	affect_blood(M, removed, holder)

#define WATER_LATENT_HEAT 9500 // How much heat is removed when applied to a hot turf, in J/unit (9500 makes 120 u of water roughly equivalent to 2L
/decl/material/liquid/water/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)

	..()

	if(!istype(T))
		return

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T20C + rand(0, 20) // Room temperature + some variance. An actual diminishing return would be better, but this is *like* that. In a way. . This has the potential for weird behavior, but I says fuck it. Water grenades for everyone.

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !isspaceturf(T))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.fire_react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	var/volume = REAGENT_VOLUME(holder, type)
	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * WATER_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if (prob(5) && environment && environment.temperature > T100C)
			T.visible_message("<span class='warning'>The water sizzles as it lands on \the [T]!</span>")

	var/list/data = REAGENT_DATA(holder, type)
	if(data && data["holy"])
		T.holy = TRUE

/decl/material/liquid/water/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	..()
	if(istype(O, /obj/item/chems/food/monkeycube))
		var/obj/item/chems/food/monkeycube/cube = O
		if(!cube.wrapper_type)
			cube.Expand()

/decl/material/liquid/water/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	..()
	if(istype(M))
		var/needed = M.fire_stacks * 10
		if(amount > needed)
			M.fire_stacks = 0
			M.ExtinguishMob()
			holder.remove_reagent(type, needed)
		else
			M.adjust_fire_stacks(-(amount / 10))
			holder.remove_reagent(type, amount)
		if(amount > 200 && !dirty_stage)
			wash_mob(M)

/decl/material/liquid/water/dirty1
	dirty_stage = 1
	dirtiness = DIRTINESS_NEUTRAL
	taste_description = "raw water"
	uid = "liquid_water_dirty1"
	color = "#83d7e0"

/decl/material/liquid/water/dirty2
	dirty_stage = 2
	dirtiness = 1
	taste_description = "water with a weird aftertaste"
	taste_mult = 1.5
	uid = "liquid_water_dirty2"
	color = "#65a3aa"
	heating_point = 100 CELSIUS
	heating_temperature_product = -2
	heating_products = list(/decl/material/liquid/water = 1)

/decl/material/liquid/water/dirty3
	dirty_stage = 3
	dirtiness = 1.5
	taste_description = "water from a dirty lake"
	taste_mult = 1.5
	uid = "liquid_water_dirty3"
	color = "#507579"

/decl/material/liquid/water/dirty4
	dirty_stage = 4
	dirtiness = 2
	taste_description = "swamp water"
	taste_mult = 2
	uid = "liquid_water_dirty4"
	color = "#9b7d63"

/decl/material/liquid/water/dirty5
	dirty_stage = 5
	dirtiness = 3
	taste_description = "heavily contaminated water"
	taste_mult = 3
	uid = "liquid_water_dirty5"
	color = "#74441d"