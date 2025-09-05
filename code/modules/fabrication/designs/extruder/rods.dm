/decl/extruder_recipe/steel_rods
	name = "Steel Rods"
	input_material = /decl/material/solid/metal/steel
	input_amount = SHEET_MATERIAL_AMOUNT*2
	output_item = /obj/item/stack/material/rods/two
	output_amount = 1
	temperature_step = 10
	progress_step = 25

/decl/extruder_recipe/arc_electrode
	name = "Arc Electrode"
	input_material = /decl/material/solid/carbon
	input_amount = SHEET_MATERIAL_AMOUNT*10
	output_item = /obj/item/arc_electrode
	output_amount = 1
	temperature_step = 15
	progress_step = 20