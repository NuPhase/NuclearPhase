/obj/machinery/fabricator/printer
	name = "industrial 3D printer"
	desc = "This hefty piece of machinery can print stuff out of polymers and metals."
	icon = 'icons/obj/machines/printer.dmi'
	icon_state = "off"
	base_icon_state = "off"
	idle_power_usage = 200
	active_power_usage = 50000
	base_type = /obj/machinery/fabricator/printer
	fabricator_class = FABRICATOR_CLASS_PRINTER
	base_storage_capacity_mult = 20
	mat_efficiency = 0.9 //evaporates some material

/obj/machinery/fabricator/printer/take_materials(obj/item/thing, mob/user)

	if (!istype(thing, /obj/item/stack/material/filament))
		return

	. = ..()
	

/obj/machinery/fabricator/printer/try_dump_material(mat_path)
	if(!mat_path || !stored_material[mat_path])
		return
	// TODO: proper liquid reagent ejection checks (acid sheet ejection...).
	var/decl/material/mat = GET_DECL(mat_path)
	if(mat?.phase_at_stp() != MAT_PHASE_SOLID)
		stored_material[mat_path] = 0
	else
		var/sheet_count = FLOOR(stored_material[mat_path]/SHEET_MATERIAL_AMOUNT)
		if(sheet_count >= 1)
			stored_material[mat_path] -= sheet_count * SHEET_MATERIAL_AMOUNT
			SSmaterials.create_object(mat_path, get_turf(src), sheet_count, /obj/item/stack/material/filament, /obj/item/stack/material/filament)

	. = ..()
	