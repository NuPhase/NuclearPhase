/obj/item/stack/ore
	name = "ore chunk"
	desc = "Unpurified chunks of rock with minerals in it. This isn't some game from 2011, right?"
	icon_state = "shiny"
	icon = 'icons/obj/ore.dmi'
	singular_name = "ore chunk"
	plural_name = "ore chunks"
	w_class = ITEM_SIZE_LARGE
	attack_cooldown = 21
	melee_accuracy_bonus = -20
	throw_speed = 5
	throw_range = 20
	max_amount = 150 //150kg in one item, should be okay
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
		playsound(loc, 'sound/foley/metal1.ogg', 60, 1)
		if(!user.do_skilled(amount * 0.55, SKILL_STRENGTH, src))
			return
		playsound(loc, 'sound/foley/metal1.ogg', 60, 1)
		crush(0.55)

/obj/item/stack/ore/examine(mob/user, distance)
	. = ..()
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

/obj/item/stack/ore/hematite //straightforward smelting to release oxygen
	color = "#a52e10"
	true_mineral_name = "hematite"
	composition = list(
		/decl/material/solid/metal/iron = 0.7,
		/decl/material/gas/oxygen = 0.3
	)
	material = /decl/material/solid/hematite

/obj/item/stack/ore/chalcopyrite // smelting = copper sulfide and iron, copper sulfide must be electrolyzed
	color = "#bdc018"
	true_mineral_name = "chalcopyrite"
	composition = list(
		/decl/material/solid/metal/iron = 0.35,
		/decl/material/solid/copper_sulfide = 0.65
	)
	material = /decl/material/solid/chalcopyrite