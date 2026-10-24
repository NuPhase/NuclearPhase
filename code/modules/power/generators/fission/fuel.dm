/obj/item/fission_fuel
	name = "quad fission fuel assembly"
	desc = ""
	icon = 'icons/obj/items/fission_fuel.dmi'
	icon_state = "quad_intact"
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	w_class = ITEM_SIZE_NO_CONTAINER
	layer = ABOVE_HUMAN_LAYER
	randpixel = 0
	weight = 2280 // 1680kg fuel + 600kg structural material
	var/integrity = 100
	var/used = FALSE
	var/radioactivity = 0

/obj/item/fission_fuel/get_mechanics_info()
	return "Can be melted down in an arc furnace."

/obj/item/fission_fuel/Initialize(ml, material_key)
	. = ..()
	create_reagents(250000)
	START_PROCESSING(SSobj, src)

/obj/item/fission_fuel/on_update_icon()
	. = ..()
	if(integrity < 80)
		icon_state = "quad_damaged"
		return
	if(used)
		icon_state = "quad_oxidized"
	else
		icon_state = "quad_intact"

/obj/item/fission_fuel/Process()
	SSradiation.radiate(src, radioactivity)

/obj/item/fission_fuel/on_reagent_change()
	radioactivity = 0
	for(var/reagent_type in reagents.reagent_volumes)
		var/decl/material/mat = GET_DECL(reagent_type)
		if(!mat.radioactivity)
			continue
		radioactivity += mat.radioactivity * reagents.reagent_volumes[reagent_type]
	radioactivity /= (integrity + 1)

/obj/item/fission_fuel/fresh/Initialize(ml, material_key)
	. = ..()
	reagents.add_reagent(/decl/material/solid/metal/depleted_uranium, 87927)
	reagents.add_reagent(/decl/material/solid/metal/plutonium, 9846)
	reagents.add_reagent(/decl/material/gas/helium, 100)

/obj/item/fission_fuel/depleted_mild/Initialize(ml, material_key) // 1 month
	. = ..()
	used = TRUE
	reagents.add_reagent(/decl/material/solid/metal/depleted_uranium, 87860)
	reagents.add_reagent(/decl/material/solid/metal/plutonium, 9861)
	reagents.add_reagent(/decl/material/solid/metal/nuclear_waste/high_level, 75.59)
	reagents.add_reagent(/decl/material/solid/metal/nuclear_waste/actinides, 6.82)
	reagents.add_reagent(/decl/material/gas/helium, 100)
	reagents.add_reagent(/decl/material/gas/krypton, 20.36)
	reagents.add_reagent(/decl/material/solid/caesium, 32.41)
	update_icon()

/obj/item/fission_fuel/depleted_full/Initialize(ml, material_key) // 6 months
	. = ..()
	used = TRUE
	reagents.add_reagent(/decl/material/solid/metal/depleted_uranium, 87135)
	reagents.add_reagent(/decl/material/solid/metal/plutonium, 10049)
	reagents.add_reagent(/decl/material/solid/metal/nuclear_waste/high_level, 453.58)
	reagents.add_reagent(/decl/material/solid/metal/nuclear_waste/actinides, 40.93)
	reagents.add_reagent(/decl/material/gas/helium, 100)
	reagents.add_reagent(/decl/material/gas/krypton, 122.18)
	reagents.add_reagent(/decl/material/solid/caesium, 194.49)
	update_icon()