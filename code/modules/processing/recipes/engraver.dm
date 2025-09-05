/decl/processing_recipe/engraver
	processing_type = PROCESSING_CLASS_ENGRAVER
	abstract_type = /decl/processing_recipe/engraver

/decl/processing_recipe/engraver/engrave_wafer_soc
	name = "Engrave a SoC Wafer"
	required_items = list(/obj/item/crafting_component/silicon_wafer)
	required_reagents = list(/decl/material/liquid/acid = 150)
	item_result_type = /obj/item/crafting_component/system_chip_wafer

/decl/processing_recipe/engraver/engrave_wafer_cpu
	name = "Engrave a CPU Wafer"
	required_items = list(/obj/item/crafting_component/silicon_wafer)
	required_reagents = list(/decl/material/liquid/acid = 150)
	item_result_type = /obj/item/crafting_component/cpu_wafer

/decl/processing_recipe/engraver/sharpen_composite_sword
	name = "Sharpen a Composite Sword"
	required_items = list(/obj/item/composite_sword/unpolished)
	required_reagents = list(/decl/material/liquid/acid = 150)
	item_result_type = /obj/item/composite_sword
	item_result_amount = 1
	recipe_time = 60