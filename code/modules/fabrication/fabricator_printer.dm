/obj/machinery/fabricator/printer
	name = "industrial 3D printer"
	desc = "This hefty piece of machinery can print stuff out of polymers and metals."
	icon = 'icons/obj/machines/printer.dmi'
	icon_state = "off"
	base_icon_state = "off"
	idle_power_usage = 200
	active_power_usage = 50000
	uncreated_component_parts = null
	stat_immune = NOSCREEN | BROKEN
	base_type = /obj/machinery/fabricator/printer
	fabricator_class = FABRICATOR_CLASS_PRINTER
	base_storage_capacity_mult = 20
	mat_efficiency = 0.9 //evaporates some material