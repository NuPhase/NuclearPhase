/decl/extruder_recipe/filament
	name = "Steel Filament"
	input_material = /decl/material/solid/metal/steel
	input_amount = SHEET_MATERIAL_AMOUNT*10
	output_item = /obj/item/stack/material/filament/steel/ten
	output_amount = 1
	temperature_step = 5
	progress_step = 50

/decl/extruder_recipe/filament/plastic
	name = "Plastic Filament"
	input_material = /decl/material/solid/plastic
	output_item = /obj/item/stack/material/filament/plastic/ten
	temperature_step = 3

/decl/extruder_recipe/filament/aluminium
	name = "Aluminium Filament"
	input_material = /decl/material/solid/metal/aluminium
	output_item = /obj/item/stack/material/filament/aluminium/ten

/decl/extruder_recipe/filament/fiberglass
	name = "Fiberglass Filament"
	input_material = /decl/material/solid/fiberglass
	output_item = /obj/item/stack/material/filament/fiberglass/ten

/decl/extruder_recipe/filament/inconel
	name = "Inconel Filament"
	input_material = /decl/material/solid/metal/inconel
	output_item = /obj/item/stack/material/filament/inconel/ten

/decl/extruder_recipe/filament/carbon
	name = "Carbon Filament"
	input_material = /decl/material/solid/carbon
	output_item = /obj/item/stack/material/filament/carbon/ten