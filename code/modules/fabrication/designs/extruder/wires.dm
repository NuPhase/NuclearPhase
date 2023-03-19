/decl/extruder_recipe/copper_cable_small
	name = "10cmx500cm Copper Cable"
	input_material = /decl/material/solid/metal/copper
	input_amount = 8000
	output_item = /obj/item/stack/cable_coil
	output_amount = 1
	minimum_skill = SKILL_BASIC
	progress_step = 50

/decl/extruder_recipe/copper_cable_small/on_fabricate(obj/item/stack/cable_coil/result)
	result.amount = 5

/decl/extruder_recipe/copper_cable_large //expensive as fuck
	name = "50cmx500cm Copper Cable"
	input_material = /decl/material/solid/metal/copper
	input_amount = 30000
	output_item = /obj/item/stack/cable_coil/heavy
	output_amount = 1
	minimum_skill = SKILL_ADEPT
	progress_step = 25

/decl/extruder_recipe/copper_cable_large/on_fabricate(obj/item/stack/cable_coil/result)
	result.amount = 5

/decl/extruder_recipe/silver_cable_large //less expensive, but still expensive as fuck
	name = "50cmx500cm Silver Cable"
	input_material = /decl/material/solid/metal/silver
	input_amount = 8000
	output_item = /obj/item/stack/cable_coil/heavy
	output_amount = 1
	minimum_skill = SKILL_ADEPT
	progress_step = 50
	temperature_step = 15

/decl/extruder_recipe/copper_cable_large/on_fabricate(obj/item/stack/cable_coil/result)
	result.amount = 5