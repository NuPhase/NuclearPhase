/obj/machinery/processor/furnace
	name = "induction furnace"
	desc = "An inert environment precise temperature controlled furnace."
	icon = 'icons/obj/machines/processing_64x64.dmi'
	icon_state = "furnace_off"
	root_icon_state = "furnace"
	bound_width = 64
	bound_height = 64
	active_power_usage = 170000
	max_items = 1
	has_tank_slot = TRUE
	initial_tank_path = /obj/item/tank/xenon
	processing_class = PROCESSING_CLASS_FURNACE
	reagent_container_volume = 5000

/obj/machinery/processor/furnace/on_update_icon()
	. = ..()
	cut_overlays()
	if(operating)
		add_overlay(emissive_overlay(icon, "furnace_glow"))
		return