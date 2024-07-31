/obj/machinery/dna_assembler
	name = "DNA assembler"
	desc = "A complex DNA assembling machine."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "assembler"
	idle_power_usage = 30
	active_power_usage = 15000
	construct_state = /decl/machine_construction/default/panel_closed
	density = TRUE
	anchored = TRUE

	var/busy = FALSE
	var/obj/item/loaded_disk = null
	var/obj/item/loaded_container = null