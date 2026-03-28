/decl/processing_recipe/furnace
	processing_type = PROCESSING_CLASS_FURNACE
	abstract_type = /decl/processing_recipe/furnace

/decl/processing_recipe/furnace/bake_hq_electrode
	name = "Bake HQ Arc Electrode"
	required_items = list(/obj/item/arc_electrode)
	required_gas = list(/decl/material/gas/nitrogen = 3)
	item_result_type = /obj/item/arc_electrode/high_quality
	recipe_time = 300

/decl/processing_recipe/furnace/bake_uhq_electrode
	name = "Bake UHQ Arc Electrode"
	required_items = list(/obj/item/arc_electrode/high_quality)
	required_gas = list(/decl/material/gas/chlorine = 0.1)
	required_reagents = list(/decl/material/liquid/acid/hydrofluoric = 3000)
	item_result_type = /obj/item/arc_electrode/ultrahigh_quality
	recipe_time = 300