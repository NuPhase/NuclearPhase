/decl/processing_recipe/cutter
	processing_type = PROCESSING_CLASS_CUTTER
	abstract_type = /decl/processing_recipe/cutter

/decl/processing_recipe/cutter/slice_food
	name = "Slice Food"
	strict_item_type = FALSE
	required_items = list(/obj/item/chems/food/sliceable)

/decl/processing_recipe/cutter/slice_food/produce_result(obj/machinery/processor/parent)
	for(var/obj/item/chems/food/sliceable/I in parent.stored_items)
		for(var/count in 1 to I.slices_num)
			parent.add_item(new I.slice_path)

/decl/processing_recipe/cutter/slice_crystal
	name = "Cut a Silicon Crystal"
	required_items = list(/obj/item/crafting_component/silicon_crystal)
	required_gas = list(/decl/material/gas/xenon = 3)
	item_result_type = /obj/item/crafting_component/silicon_wafer
	item_result_amount = 4

/decl/processing_recipe/cutter/slice_wafer_soc
	name = "Cut a SoC Wafer"
	required_items = list(/obj/item/crafting_component/system_chip_wafer)
	required_gas = list(/decl/material/gas/xenon = 1)
	item_result_type = /obj/item/crafting_component/system_chip
	item_result_amount = 4

/decl/processing_recipe/cutter/slice_wafer_cpu
	name = "Cut a CPU Wafer"
	required_items = list(/obj/item/crafting_component/cpu_wafer)
	required_gas = list(/decl/material/gas/xenon = 1)
	item_result_type = /obj/item/crafting_component/cpu_chip
	item_result_amount = 4