// These are definitions for intermediate components used in crafting. They aren't used for anything else.

/obj/item/crafting_component
	icon = 'icons/obj/items/crafting_intermediates.dmi'

// Carbon with plastic in a 3D printer, takes a long time
/obj/item/crafting_component/carbon_composite
	name = "carbon composite"
	desc = "A light plastic mesh woven with carbon fiber. It's production is long and costly, but it posesses extreme physical strength."
	icon_state = "carbon_composite"
	matter = list(/decl/material/solid/carbon = MATTER_AMOUNT_PRIMARY, /decl/material/solid/plastic = MATTER_AMOUNT_TRACE)
	weight = 0.7
	w_class = ITEM_SIZE_LARGE

// Carbon in a 3D printer, takes a medium amount of time
/obj/item/crafting_component/carbon_fiber_roll
	name = "carbon fiber roll"
	desc = "A roll of carbon fiber."
	icon_state = "carbon_fiber"
	matter = list(/decl/material/solid/carbon = MATTER_AMOUNT_PRIMARY)
	weight = 0.3
	w_class = ITEM_SIZE_LARGE

// Blood and mutagen in a medical assembler
/obj/item/crafting_component/genetic_muscle
	name = "gen-moded muscle batch"
	desc = "A batch of genetically engineered muscle."
	weight = 0.2
	w_class = ITEM_SIZE_NORMAL

// Rod + cable
/obj/item/crafting_component/motor_shaft
	name = "motor shaft"
	desc = "A simple wound motor shaft."
	icon_state = "motor_shaft"
	weight = 0.2
	w_class = ITEM_SIZE_NORMAL

// Steel in an extruder
/obj/item/crafting_component/motor_case
	name = "motor case"
	desc = "A simple motor case."
	icon_state = "motor_case"
	weight = 0.5
	w_class = ITEM_SIZE_NORMAL

// Genetic muscle + wetware interface
/obj/item/crafting_component/biomech_muscle
	name = "biomechanical muscle batch"
	desc = "A batch of genetically engineered muscle with wetware circuits for precise control."
	weight = 0.3
	w_class = ITEM_SIZE_NORMAL


// CIRCUITS
/obj/item/crafting_component/silicon_crystal
	name = "silicon crystal"
	desc = "A monocrystal of silicon, ready to be cut into wafers."
	weight = 0.4
	w_class = ITEM_SIZE_LARGE

// Silicon wafer, a basic crafting component. Silicon crystal in a laser cutter
/obj/item/crafting_component/silicon_wafer
	name = "silicon wafer"
	desc = "A single piece of silicon wafer. Demands extreme sterility and can be engraved."
	icon_state = "silicon_wafer"
	weight = 0.1
	w_class = ITEM_SIZE_NORMAL

// Silicon wafer in a laser engraver
/obj/item/crafting_component/system_chip_wafer
	name = "SoC wafer"
	desc = "A set of computer circuits engraved on a silicon wafer. Don't drop it."
	icon_state = "silicon_wafer"
	weight = 0.1
	w_class = ITEM_SIZE_NORMAL

// Silicon wafer in a laser engraver
/obj/item/crafting_component/cpu_wafer
	name = "CPU wafer"
	desc = "A set of very powerful processing chips engraved on a silicon wafer. Don't drop it."
	icon_state = "silicon_wafer"
	weight = 0.1
	w_class = ITEM_SIZE_NORMAL

// SoC wafer in a laser cutter
/obj/item/crafting_component/system_chip
	name = "SoC chip"
	desc = "A system on a chip engraved on silicon."
	icon_state = "soc_chip"
	weight = 0.025
	w_class = ITEM_SIZE_SMALL

// CPU wafer in a laser cutter
/obj/item/crafting_component/cpu_chip
	name = "CPU chip"
	desc = "A CPU chip engraved on silicon."
	icon_state = "cpu_chip"
	weight = 0.025
	w_class = ITEM_SIZE_SMALL

// System on a chip + brain sample from genetics
/obj/item/crafting_component/wetware_interface
	name = "wetware interface"
	desc = "A computer that uses living neurons. Disgusting for some, but it's very compact and efficient."
	weight = 0.1
	w_class = ITEM_SIZE_SMALL


// GENERALIZED COMPONENTS
/obj/item/crafting_component/miniature_components
	name = "miniaturized components"
	desc = "Very small, power-dense mechanical components."
	weight = 0.1
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/plastic

/obj/item/crafting_component/components
	name = "mechanical components"
	desc = "General use mechanical components."
	weight = 0.4
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/metal/aluminium

/obj/item/crafting_component/industrial_components
	name = "industrial components"
	desc = "Extremely heavy-duty components. Used in the most powerful of machinery."
	weight = 2
	w_class = ITEM_SIZE_LARGE
	material = /decl/material/solid/metal/steel

/obj/item/crafting_component/aerospace_components
	name = "aerospace components"
	desc = "Heavy-duty, lightweight mechanical components. Used for the most demanding applications."
	weight = 0.5
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/metal/stainlesssteel


// MILL BLOCKS
/obj/item/crafting_component/mill_block_basic
	name = "basic machining block"
	desc = "General use steel block for machining."
	icon_state = "mill_cube"
	color = COLOR_GUNMETAL
	weight = 5
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/metal/stainlesssteel
	matter = list(/decl/material/solid/metal/stainlesssteel = MATTER_AMOUNT_PRIMARY*5)

/obj/item/crafting_component/mill_block_super
	name = "superalloy machining block"
	desc = "Superalloy block for heavy-duty machining."
	icon_state = "mill_cube"
	color = COLOR_POLISHED_BRASS
	weight = 5
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/metal/rare_metals
	matter = list(
					/decl/material/solid/metal/rare_metals = MATTER_AMOUNT_PRIMARY*2,
					/decl/material/solid/metal/iron = MATTER_AMOUNT_PRIMARY,
					/decl/material/solid/metal/chromium = MATTER_AMOUNT_PRIMARY,
					/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY,
					/decl/material/solid/metal/titanium = MATTER_AMOUNT_REINFORCEMENT,
					/decl/material/solid/metal/tungsten = MATTER_AMOUNT_REINFORCEMENT,
					/decl/material/solid/carbon = MATTER_AMOUNT_TRACE)

/obj/item/crafting_component/mill_block_super_supersized
	name = "supersized superalloy machining block"
	desc = "Superalloy block for heavy-duty machining."
	icon_state = "mill_cube_super"
	color = COLOR_POLISHED_BRASS
	weight = 4000
	w_class = ITEM_SIZE_HUGE
	material = /decl/material/solid/metal/rare_metals
	matter = list(
					/decl/material/solid/metal/rare_metals = MATTER_AMOUNT_PRIMARY*2*800,
					/decl/material/solid/metal/iron = MATTER_AMOUNT_PRIMARY*800,
					/decl/material/solid/metal/chromium = MATTER_AMOUNT_PRIMARY*800,
					/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY*800,
					/decl/material/solid/metal/titanium = MATTER_AMOUNT_REINFORCEMENT*800,
					/decl/material/solid/metal/tungsten = MATTER_AMOUNT_REINFORCEMENT*800,
					/decl/material/solid/carbon = MATTER_AMOUNT_TRACE*800)

// TURBINES
// 4 supersized superalloy blocks. Restored 6% of the turbine integrity
/obj/item/crafting_component/turbine_blades
	name = "turbine blade pack"
	icon_state = "turb_blades"
	desc = "A pack of 64 heavy-duty turbine blades. Can't be used on its own. A single blade weighs 55kg."
	weight = 3520
	w_class = ITEM_SIZE_LARGE
	material = /decl/material/solid/metal/rare_metals

// 4 turbine blade packs. Restores 25% of the turbine integrity
/obj/item/crafting_component/turbine_rotor
	name = "HP turbine rotor"
	desc = "An assembled turbine rotor with 256 blades in it."
	icon_state = "turbine_hp"
	weight = 14080
	w_class = ITEM_SIZE_HUGE
	material = /decl/material/solid/metal/rare_metals

// 4 HP turbine rotors. Restores 100% of the turbine integrity
/obj/item/crafting_component/turbine_rotor_huge
	name = "LP turbine rotor"
	desc = "An assembled turbine rotor with 1024 blades in it. Someone messed up big time to need this thing replaced."
	weight = 56320
	w_class = ITEM_SIZE_GARGANTUAN
	material = /decl/material/solid/metal/rare_metals