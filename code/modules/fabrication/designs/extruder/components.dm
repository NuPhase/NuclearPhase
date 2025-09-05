/decl/extruder_recipe/exhaust_diverters
	name = "Exhaust Diverters"
	input_material = /decl/material/solid/carbon
	input_amount = SHEET_MATERIAL_AMOUNT*20
	output_item = /obj/item/vehicle_component/carbon_exhaust_diverters
	output_amount = 1
	temperature_step = 15
	progress_step = 25

/decl/extruder_recipe/motor_case
	name = "Motor Case"
	input_material = /decl/material/solid/metal/steel
	input_amount = SHEET_MATERIAL_AMOUNT*2
	output_item = /obj/item/crafting_component/motor_case
	output_amount = 1
	temperature_step = 5
	progress_step = 25

/decl/extruder_recipe/unpolished_composite_sword
	name = "Dull Composite Sword"
	input_material = /decl/material/solid/metal/titanium
	input_amount = SHEET_MATERIAL_AMOUNT*10
	output_item = /obj/item/composite_sword/unpolished
	output_amount = 1
	temperature_step = 5
	progress_step = 5
	minimum_skill = SKILL_ADEPT