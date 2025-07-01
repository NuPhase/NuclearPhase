/obj/item/stack/ore
	name = "ore chunk"
	desc = "Unpurified chunks of rock with minerals in it. This isn't some game from 2011, right?"
	icon = 'icons/obj/materials.dmi'
	icon_state = "ore"
	plural_icon_state = "ore-mult"
	max_icon_state = "ore-max"
	singular_name = "ore chunk"
	plural_name = "ore chunks"
	w_class = ITEM_SIZE_LARGE
	attack_cooldown = 21
	melee_accuracy_bonus = -20
	throw_speed = 5
	throw_range = 20
	max_amount = 800 //800kg in one item, should be okay
	amount = 100
	weight = 100
	var/processing_flags
	var/true_mineral_name = "" //only visible to geologists
	var/list/composition //associative list of binary ratios

	// Represents the difficulty of processing this ore.
	var/yield_divisor = 1
	/* Some common values, representing the amount of useful product at the qualities(10% / 50% / 100%):
		0.1    - (90% / 98% / 99%) - Amorphous Carbon, Ice, Sulfur
		0.5    - (66% / 90% / 95%) - Graphite, Bauxite, Cryolite
		1.0    - (50% / 83% / 90%) - Chalcopyrite, Pyrothane, Ilmenite, Sphalerite
		2.0    - (33% / 70% / 83%) - Hematite, Cyanopyrite
		3.0    - (25% / 62% / 76%) - Galena, Magnetite
		4.0    - (20% / 55% / 70%) - Crystalline Copper, Vanadinite
		5.0    - (16% / 50% / 66%) - Monazite, Xenotime, Cassiterite
		10.0   - (9%  / 33% / 50%) - Uraninite, Pitchblende, Columbite
		20.0   - (5%  / 20% / 33%) - Rare Metals, Gold
		50.0   - (1%  / 10% / 16%)
		100.0  - (1%  / 5%  / 10%)

	*/
/*
	var/list/composition = list(
		var/decl/material/someshit = 0.3,
		var/decl/material/somepiss = 0.7
	)
*/

/obj/item/stack/ore/copy_from(obj/item/stack/ore/other)
	. = ..()
	icon = other.icon
	icon_state = other.icon_state
	processing_flags = other.processing_flags
	composition = other.composition

/obj/item/stack/ore/MouseDrop(atom/over)
	. = ..()
	var/mob/user = usr
	if(istype(over, /obj/machinery/material_processing))
		var/obj/machinery/material_processing/over_processor = over
		if(over_processor.processing_stack)
			return
		if(!user.do_skilled(50, SKILL_DEVICES, over_processor))
			return
		over_processor.processing_stack = src
		forceMove(over_processor)
		START_PROCESSING_MACHINE(over_processor, MACHINERY_PROCESS_SELF)
		return
	if(istype(over, /obj/structure/arc_furnace_overlay))
		var/obj/structure/arc_furnace_overlay/over_furnace = over
		over_furnace.our_furnace.add_ore(src)
		forceMove(over_furnace.our_furnace)
		return

/obj/item/stack/ore/copy_from(obj/item/stack/ore/other)
	. = ..()
	processing_flags = other.processing_flags
	true_mineral_name = other.true_mineral_name
	icon_state = other.icon_state
	composition = other.composition

/obj/item/stack/ore/attackby(obj/item/W, mob/user)
	. = ..()
	if(!isturf(loc))
		return
	if(istype(W, /obj/item/pickaxe))
		if(processing_flags & ORE_FLAG_CRUSHED)
			return
		if(user.get_skill_value(SKILL_STRENGTH) < SKILL_ADEPT)
			to_chat(user, SPAN_WARNING("You are too frail to break up \the [src]. Find someone stronger."))
			return //fuck femboys
		playsound(loc, 'sound/foley/metal1.ogg', 70, 1)
		if(!user.do_skilled(amount * 0.55, SKILL_STRENGTH, src))
			return
		if(processing_flags & ORE_FLAG_CRUSHED)
			return
		playsound(loc, 'sound/foley/metal1.ogg', 70, 1)
		crush(0.5)

/obj/item/stack/ore/examine(mob/user, distance)
	. = ..()
	if(user.get_skill_value(SKILL_DEVICES) > SKILL_NONE)
		to_chat(user, "You recognize the ore as [SPAN_BOLD(true_mineral_name)].")
	if(processing_flags & ORE_FLAG_CRUSHED)
		to_chat(user, "It was crushed to dust.")
		if(processing_flags & ORE_FLAG_SEPARATED_BEST)
			to_chat(user, "It looks pristinely pure.")
		else if(processing_flags & ORE_FLAG_SEPARATED_GOOD)
			to_chat(user, "It is separated well, with little discolorations all around.")
		else if(processing_flags & ORE_FLAG_SEPARATED_CRUDE)
			to_chat(user, "It is crudely separated, either by hand or by sifting.")
		else
			to_chat(user, "It's very impure.")

/obj/item/stack/ore/proc/crush(efficiency=1)
	processing_flags |= ORE_FLAG_CRUSHED
	icon = 'icons/obj/ore.dmi'
	icon_state = "dust"
	amount *= efficiency

/obj/item/stack/ore/proc/ore_to_slag_ratio()
	var/quality = 0.01
	if(processing_flags & ORE_FLAG_SEPARATED_BEST)
		quality = 10
	else if(processing_flags & ORE_FLAG_SEPARATED_GOOD)
		quality = 5
	else if(processing_flags & ORE_FLAG_SEPARATED_CRUDE)
		quality = 1
	else if(processing_flags & ORE_FLAG_CRUSHED)
		quality = 0.05

	var/actual_ratio = quality / (quality + yield_divisor)
	return actual_ratio

// Iron-bearing minerals

/obj/item/stack/ore/hematite //straightforward smelting to release oxygen
	color = "#a52e10"
	true_mineral_name = "hematite"
	composition = list(
		/decl/material/solid/metal/iron = 0.7,
		/decl/material/gas/oxygen = 0.3
	)
	yield_divisor = 2
	material = /decl/material/solid/hematite

/obj/item/stack/ore/magnetite
	color = "#53575f"
	true_mineral_name = "magnetite"
	composition = list(
		/decl/material/solid/magnetite = 1
	)
	yield_divisor = 3
	material = /decl/material/solid/magnetite

// Copper-bearing minerals

/obj/item/stack/ore/chalcopyrite // smelting = copper sulfide and iron, copper sulfide must be electrolyzed
	color = "#c09918"
	true_mineral_name = "chalcopyrite"
	composition = list(
		/decl/material/solid/metal/iron = 0.35,
		/decl/material/solid/copper_sulfide = 0.6,
		/decl/material/gas/oxygen = 0.05
	)
	yield_divisor = 1
	material = /decl/material/solid/chalcopyrite

/obj/item/stack/ore/copper
	color = "#ffd271"
	true_mineral_name = "crystalline copper"
	composition = list(
		/decl/material/solid/metal/copper = 1
	)
	yield_divisor = 4
	material = /decl/material/solid/metal/copper

// Carbon-bearing minerals

// High surface area carbon. Explosive.
/obj/item/stack/ore/amorphous_carbon
	color = "#666666"
	true_mineral_name = "amorphous carbon"
	composition = list(
		/decl/material/solid/carbon = 0.965,
		/decl/material/solid/quartz = 0.004,
		/decl/material/solid/bauxite = 0.001,
		/decl/material/solid/magnetite = 0.015,
		/decl/material/solid/hematite = 0.005,
		/decl/material/solid/gemstone/diamond = 0.01
	)
	yield_divisor = 0.1
	material = /decl/material/solid/carbon

/obj/item/stack/ore/graphite
	color = "#272727"
	true_mineral_name = "graphite"
	composition = list(
		/decl/material/solid/carbon = 0.13,
		/decl/material/solid/densegraphite = 0.67,
		/decl/material/solid/graphite = 0.15,
		/decl/material/solid/quartz = 0.03,
		/decl/material/solid/clay = 0.02
	)
	yield_divisor = 0.5
	material = /decl/material/solid/graphite

/obj/item/stack/ore/pyrothane
	color = "#ffaf54"
	true_mineral_name = "pyrothane"
	composition = list(
		/decl/material/solid/metal/iron = 0.03,
		/decl/material/solid/metal/chromium = 0.007,
		/decl/material/solid/metal/radium = 0.001,
		/decl/material/solid/metal/gold = 0.002,
		/decl/material/liquid/diesel = 0.42,
		/decl/material/liquid/water/dirty5 = 0.06,
		/decl/material/liquid/tar = 0.21,
		/decl/material/liquid/acetone = 0.04,
		/decl/material/solid/copper_sulfide = 0.04,
		/decl/material/gas/methane = 0.19
	)
	yield_divisor = 1
	material = /decl/material/gas/methane

// Other minerals

/obj/item/stack/ore/sulfur
	color = "#fffc54"
	true_mineral_name = "sulfur"
	composition = list(
		/decl/material/solid/sulfur = 0.95,
		/decl/material/gas/sulfur_dioxide = 0.05
	)
	yield_divisor = 0.1
	material = /decl/material/solid/sulfur

/obj/item/stack/ore/bauxite
	color = "#ebb932"
	true_mineral_name = "bauxite"
	composition = list(
		/decl/material/solid/bauxite = 0.99,
		/decl/material/gas/oxygen = 0.01
	)
	yield_divisor = 0.5
	material = /decl/material/solid/bauxite

/obj/item/stack/ore/ilmenite
	color = "#69566d"
	true_mineral_name = "ilmenite"
	composition = list(
		/decl/material/solid/metal/iron = 0.2,
		/decl/material/solid/metal/titanium = 0.2,
		/decl/material/gas/oxygen = 0.6
	)
	yield_divisor = 1
	material = /decl/material/solid/metal/titanium

/obj/item/stack/ore/sphalerite
	color = "#d3d3d3"
	true_mineral_name = "sphalerite"
	composition = list(
		/decl/material/solid/metal/zinc = 0.5,
		/decl/material/solid/sulfur = 0.5
	)
	yield_divisor = 1
	material = /decl/material/solid/metal/zinc

/obj/item/stack/ore/cyanopyrite
	color = "#70cbdb"
	true_mineral_name = "cyanopyrite"
	composition = list(
		/decl/material/liquid/cyanide = 0.33,
		/decl/material/solid/metal/iron = 0.34,
		/decl/material/solid/sulfur = 0.33
	)
	yield_divisor = 2
	material = /decl/material/liquid/cyanide

/obj/item/stack/ore/galena
	color = "#8b6a9e"
	true_mineral_name = "galena"
	composition = list(
		/decl/material/solid/metal/lead = 0.5,
		/decl/material/solid/sulfur = 0.5
	)
	yield_divisor = 3
	material = /decl/material/solid/metal/lead

/obj/item/stack/ore/gold
	color = "#ffd549"
	true_mineral_name = "gold"
	composition = list(
		/decl/material/solid/metal/gold = 0.7,
		/decl/material/solid/quartz = 0.2,
		/decl/material/solid/sulfur = 0.1
	)
	yield_divisor = 20
	material = /decl/material/solid/metal/gold