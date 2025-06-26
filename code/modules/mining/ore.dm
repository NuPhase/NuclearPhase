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
	max_amount = 150 //150kg in one item, should be okay
	weight = 1
	var/processing_flags
	var/true_mineral_name = "" //only visible to geologists
	var/list/composition //associative list of binary ratios
/*
	var/list/composition = list(
		var/decl/material/someshit = 0.3,
		var/decl/material/somepiss = 0.7
	)
*/

/obj/item/stack/ore/MouseDrop(atom/over)
	. = ..()
	if(istype(over, /obj/machinery/material_processing))
		var/obj/machinery/material_processing/over_processor = over
		if(over_processor.processing_stack)
			return
		over_processor.processing_stack = src
		forceMove(over_processor)
		START_PROCESSING_MACHINE(over_processor, MACHINERY_PROCESS_SELF)
		return
	if(istype(over, /obj/structure/arc_furnace_overlay))
		var/obj/structure/arc_furnace_overlay/over_furnace = over
		over_furnace.our_furnace.add_ore(src)
		forceMove(over_furnace)
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
	if(processing_flags & ORE_FLAG_SEPARATED_BEST)
		return 0.95
	else if(processing_flags & ORE_FLAG_SEPARATED_GOOD)
		return 0.75
	else if(processing_flags & ORE_FLAG_SEPARATED_CRUDE)
		return 0.25
	else if(processing_flags & ORE_FLAG_CRUSHED)
		return 0.05
	else
		return 0.01

// Iron-bearing minerals

/obj/item/stack/ore/hematite //straightforward smelting to release oxygen
	color = "#a52e10"
	true_mineral_name = "hematite"
	composition = list(
		/decl/material/solid/metal/iron = 0.7,
		/decl/material/gas/oxygen = 0.3
	)
	material = /decl/material/solid/hematite

// Copper-bearing minerals

/obj/item/stack/ore/chalcopyrite // smelting = copper sulfide and iron, copper sulfide must be electrolyzed
	color = "#c09918"
	true_mineral_name = "chalcopyrite"
	composition = list(
		/decl/material/solid/metal/iron = 0.35,
		/decl/material/solid/copper_sulfide = 0.65
	)
	material = /decl/material/solid/chalcopyrite

// Carbon-bearing minerals

// High surface area carbon. Explosive.
/obj/item/stack/ore/amorphous_carbon
	color = "#4b4b4b"
	true_mineral_name = "amorphous carbon"
	composition = list(
		/decl/material/solid/carbon = 0.965,
		/decl/material/solid/quartz = 0.004,
		/decl/material/solid/bauxite = 0.001,
		/decl/material/solid/magnetite = 0.015,
		/decl/material/solid/hematite = 0.005,
		/decl/material/solid/gemstone/diamond = 0.01
	)
	material = /decl/material/solid/carbon

/obj/item/stack/ore/graphite
	color = "#1b1b1b"
	true_mineral_name = "graphite"
	composition = list(
		/decl/material/solid/carbon = 0.13,
		/decl/material/solid/densegraphite = 0.67,
		/decl/material/solid/graphite = 0.15,
		/decl/material/solid/quartz = 0.03,
		/decl/material/solid/clay = 0.02
	)
	material = /decl/material/solid/graphite

/obj/item/stack/ore/pyrothane
	color = "#8a5d2b"
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
	material = /decl/material/solid/graphite