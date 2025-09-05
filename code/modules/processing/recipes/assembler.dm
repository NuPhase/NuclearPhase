/decl/processing_recipe/assembler
	processing_type = PROCESSING_CLASS_ASSEMBLER
	abstract_type = /decl/processing_recipe/assembler

/decl/processing_recipe/assembler/electric_motor
	name = "Assemble an Electric Motor"
	required_items = list(/obj/item/crafting_component/motor_case, /obj/item/crafting_component/motor_shaft)
	item_result_type = /obj/item/stock_parts/engine/medium

/decl/processing_recipe/assembler/molten_sword
	name = "Assemble a Molten Sword"
	required_items = list(/obj/item/sword, /obj/item/stock_parts/capacitor, /obj/item/stock_parts/shielding/heat, /obj/item/stack/material/blankets/inconel)
	strict_item_type = FALSE
	item_result_type = /obj/item/energy_blade/molten_sword
	recipe_time = 30


// GUNS
/decl/processing_recipe/assembler/mx16
	name = "Assemble an MX16 SMG"
	required_items = list(/obj/item/crafting_component/components, /obj/item/crafting_component/miniature_components, /obj/item/crafting_component/carbon_composite, /obj/item/stock_parts/engine)
	item_result_type = /obj/item/gun/projectile/automatic/smg
	recipe_time = 60

/decl/processing_recipe/assembler/assault
	name = "Assemble an Assault Rifle"
	required_items = list(/obj/item/crafting_component/components, /obj/item/crafting_component/components, /obj/item/crafting_component/carbon_composite, /obj/item/stock_parts/shielding/heat)
	item_result_type = /obj/item/gun/projectile/automatic/assault_rifle
	recipe_time = 60

/decl/processing_recipe/assembler/snapdragon
	name = "Assemble a Snapdragon Rifle"
	required_items = list(/obj/item/crafting_component/components, /obj/item/crafting_component/components, /obj/item/crafting_component/carbon_composite, /obj/item/stock_parts/engine)
	item_result_type = /obj/item/gun/projectile/automatic/snapdragon
	recipe_time = 60

/decl/processing_recipe/assembler/cef
	name = "Assemble a CEF Pistol"
	required_items = list(/obj/item/crafting_component/aerospace_components, /obj/item/crafting_component/carbon_composite, /obj/item/stock_parts/shielding/heat, /obj/item/stack/material/blankets/inconel)
	item_result_type = /obj/item/gun/projectile/pistol/military_service
	recipe_time = 60

/decl/processing_recipe/assembler/cef
	name = "Assemble a VPS Pistol"
	required_items = list(/obj/item/crafting_component/components, /obj/item/stock_parts/shielding/heat, /obj/item/stock_parts/engine)
	item_result_type = /obj/item/gun/projectile/pistol/low_caliber
	recipe_time = 60

/decl/processing_recipe/assembler/ngdmr
	name = "Assemble an NG-HDM Rifle"
	required_items = list(/obj/item/crafting_component/aerospace_components, /obj/item/crafting_component/aerospace_components, /obj/item/stack/material/blankets/inconel, /obj/item/stock_parts/shielding/heat)
	item_result_type = /obj/item/gun/projectile/sniper/ngdmr
	recipe_time = 60

/decl/processing_recipe/assembler/bolt_sniper
	name = "Assemble a HI-PTR Sniper Rifle"
	required_items = list(/obj/item/crafting_component/components, /obj/item/crafting_component/components)
	item_result_type = /obj/item/gun/projectile/bolt_action/sniper
	recipe_time = 60

/decl/processing_recipe/assembler/auto_sniper
	name = "Assemble an AMR Sniper Rifle"
	required_items = list(/obj/item/crafting_component/aerospace_components, /obj/item/crafting_component/components, /obj/item/stock_parts/engine)
	item_result_type = /obj/item/gun/projectile/sniper/semiauto
	recipe_time = 60