/obj/machinery/dna_extractor
	name = "cell lysis-isolator"
	desc = "A complex DNA extraction machine."
	icon = 'icons/obj/machines/destructive_analyzer.dmi'
	icon_state = "d_analyzer"
	idle_power_usage = 30
	active_power_usage = 7000
	construct_state = /decl/machine_construction/default/panel_closed
	density = TRUE
	anchored = TRUE

	var/busy = FALSE
	var/obj/item/loaded_item = null
	var/obj/item/loaded_container = null

/obj/machinery/dna_extractor/on_update_icon()
	if(panel_open)
		icon_state = "d_analyzer_t"
	else if(loaded_item)
		icon_state = "d_analyzer_l"
	else
		icon_state = "d_analyzer"

/obj/machinery/dna_extractor/components_are_accessible(path)
	return !busy && ..()