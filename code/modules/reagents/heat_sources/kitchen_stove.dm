/obj/machinery/reagent_temperature/stove
	name = "tabletop stove"
	desc = "A simple inductive tabletop stove."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "stove_off"
	active_power_usage = 20000
	max_temperature = 160 CELSIUS
	min_temperature = 95 CELSIUS
	permitted_types = list(/obj/item/chems)

/obj/machinery/reagent_temperature/stove/on_update_icon()

	var/list/adding_overlays

	if(use_power >= POWER_USE_ACTIVE)
		if(!on_icon)
			on_icon = image(icon, "stove_on")
		LAZYADD(adding_overlays, on_icon)

	if(container)
		if(!beaker_icon)
			beaker_icon = image(icon, "stove_on-beaker")
		LAZYADD(adding_overlays, beaker_icon)

	overlays = adding_overlays