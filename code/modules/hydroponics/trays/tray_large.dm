/obj/machinery/portable_atmospherics/hydroponics/large
	icon = 'icons/obj/hydroponics/large_hydroponics.dmi'
	pixel_x = -32
	bound_x = -32
	bound_width = 96
	closed_system = TRUE
	mechanical = FALSE

//Refreshes the icon and sets the luminosity
/obj/machinery/portable_atmospherics/hydroponics/large/on_update_icon()
	// Update name.
	if(seed)
		if(mechanical)
			name = "[base_name] ([seed.seed_name])"
		else
			name = "[seed.seed_name]"
	else
		SetName(initial(name))

	overlays.Cut()
	var/new_overlays = list()
	// Updates the plant overlay.
	if(seed)
		if(dead)
			var/ikey = "[seed.get_trait(TRAIT_PLANT_ICON)]-dead"
			var/image/dead_overlay = SSplants.plant_icon_cache["[ikey]"]
			if(!dead_overlay)
				dead_overlay = image('icons/obj/hydroponics/hydroponics_growing.dmi', "[ikey]")
				dead_overlay.color = DEAD_PLANT_COLOUR
			new_overlays |= dead_overlay
		else
			if(!seed.growth_stages)
				seed.update_growth_stages()
			if(!seed.growth_stages)
				log_error("<span class='danger'>Seed type [seed.get_trait(TRAIT_PLANT_ICON)] cannot find a growth stage value.</span>")
				return
			var/overlay_stage = get_overlay_stage()

			var/ikey = "\ref[seed]-plant-[overlay_stage]"
			if(!SSplants.plant_icon_cache[ikey])
				SSplants.plant_icon_cache[ikey] = seed.get_icon(overlay_stage)
			new_overlays |= SSplants.plant_icon_cache[ikey]

			if(harvest && overlay_stage == seed.growth_stages)
				ikey = "[seed.get_trait(TRAIT_PRODUCT_ICON)]"
				var/image/harvest_overlay = SSplants.plant_icon_cache["product-[ikey]-[seed.get_trait(TRAIT_PLANT_COLOUR)]"]
				if(!harvest_overlay)
					harvest_overlay = image('icons/obj/hydroponics/hydroponics_products.dmi', "[ikey]")
					harvest_overlay.color = seed.get_trait(TRAIT_PRODUCT_COLOUR)
					SSplants.plant_icon_cache["product-[ikey]-[harvest_overlay.color]"] = harvest_overlay
				new_overlays |= harvest_overlay

	if((!density || !opacity) && seed && seed.get_trait(TRAIT_LARGE))
		if(!mechanical)
			set_density(1)
		set_opacity(1)
	else
		if(!mechanical)
			set_density(0)
		set_opacity(0)

	if(closed_system)
		new_overlays += "cover"

	overlays |= new_overlays

	// Update bioluminescence.
	if(seed && seed.get_trait(TRAIT_BIOLUM))
		set_light(round(seed.get_trait(TRAIT_POTENCY)/10), l_color = seed.get_trait(TRAIT_BIOLUM_COLOUR))
	else
		set_light(0)

/obj/machinery/portable_atmospherics/hydroponics/large/harvest(var/mob/user)

	//Harvest the product of the plant,
	if(!seed || !harvest)
		return

	if(closed_system)
		if(user) to_chat(user, "You can't harvest from the plant while the lid is shut.")
		return

	if(user)
		. = seed.harvest(user,yield_mod + 3)
	else
		. = seed.harvest(get_turf(src),yield_mod + 3)
	// Reset values.
	harvest = 0
	lastproduce = age

	if(!seed.get_trait(TRAIT_HARVEST_REPEAT))
		yield_mod = 0
		clear_seed()
		dead = 0
		age = 0
		sampled = 0
		mutation_mod = 0

	check_health()