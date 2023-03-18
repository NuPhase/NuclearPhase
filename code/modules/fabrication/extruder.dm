#define EXTRUDER_HEAT_CAPACITY 300000
#define EXTRUDER_COMFORTABLE_TEMPERATURE 320
#define EXTRUDER_MAX_TEMPERATURE 410

/obj/machinery/atmospherics/binary/extruder
	name = "industrial extruder"
	desc = "A machine that extrudes things. Simple, is it?"
	icon = 'icons/obj/machines/fabricators/autolathe.dmi'
	icon_state = "autolathe"
	density = 1
	anchored = 1
	idle_power_usage = 500 //cooling pumps
	active_power_usage = 70000
	clicksound = "keyboard"
	clickvol = 30
	uncreated_component_parts = null
	stat_immune = 0
	base_type =       /obj/machinery/atmospherics/binary/extruder
	construct_state = /decl/machine_construction/default/panel_closed
	var/decl/extruder_recipe/current_recipe = null
	var/fabrication_progress = 0
	var/fab_status_flags

/obj/machinery/atmospherics/binary/extruder/Initialize()
	. = ..()
	air1.volume = 100
	air2.volume = 100
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/atmospherics/binary/extruder/proc/start_fabricating(var/decl/extruder_recipe/do_recipe)
	current_recipe = do_recipe
	use_power = POWER_USE_ACTIVE
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	Process()

/obj/machinery/atmospherics/binary/extruder/proc/stop_fabricating()
	current_recipe = null
	use_power = POWER_USE_IDLE //switching to off happens in processing
	fabrication_progress = 0

/obj/machinery/atmospherics/binary/extruder/Process()
	. = ..()
	var/datum/gas_mixture/internal_removed = air1.remove_ratio(1)
	var/combined_heat_capacity = internal_removed.heat_capacity() + EXTRUDER_HEAT_CAPACITY
	var/combined_energy = internal_removed.temperature * internal_removed.heat_capacity() + EXTRUDER_HEAT_CAPACITY * temperature
	var/final_temperature = combined_energy / combined_heat_capacity
	temperature = final_temperature
	internal_removed.temperature = final_temperature
	air2.merge(internal_removed)

	if(temperature < EXTRUDER_COMFORTABLE_TEMPERATURE && !current_recipe)
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		use_power = POWER_USE_OFF
		visible_message(SPAN_NOTICE("[src] shuts down audibly, it has cooled itself down fully."))
		return

	if(!current_recipe)
		return
	fabrication_progress += current_recipe.progress_step
	temperature += current_recipe.temperature_step
	if(fabrication_progress > 100)
		var/result = new current_recipe.output_item(get_turf(src))
		current_recipe.on_fabricate(result)
		stop_fabricating()
		return
	if(temperature > EXTRUDER_MAX_TEMPERATURE)
		new /obj/item/ore/slag(get_turf(src))
		stop_fabricating()
		visible_message(SPAN_WARNING("[src] overheats and shuts down, the materials are wasted!"))
		return

/obj/machinery/atmospherics/binary/extruder/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/stack/material))
		if(current_recipe)
			to_chat(user, SPAN_WARNING("[src] is busy!"))
			return

		var/obj/item/stack/material/mat_stack = I
		var/list/possible_recipes = list()
		for(var/candidate in subtypesof(/decl/extruder_recipe))
			var/decl/extruder_recipe/recipe = GET_DECL(candidate)
			if(recipe.input_material == mat_stack.material.type && user.get_skill_value(SKILL_DEVICES) >= recipe.minimum_skill)
				possible_recipes += recipe

		if(!length(possible_recipes))
			to_chat(user, SPAN_WARNING("You don't know how to extrude something from [mat_stack]!"))
			return
		var/decl/extruder_recipe/chosen_recipe = input(user, "What to make from [mat_stack.material.name]?", "Recipe selection") as null|anything in possible_recipes
		if(!chosen_recipe)
			return
		if(mat_stack.matter[mat_stack.material.type] < chosen_recipe.input_amount)
			to_chat(user, SPAN_WARNING("You don't have enough [mat_stack.material.name]!"))
			return
		mat_stack.use(chosen_recipe.input_amount / SHEET_MATERIAL_AMOUNT)
		start_fabricating(chosen_recipe)
	. = ..()

/decl/extruder_recipe
	var/name = ""
	var/input_material = /decl/material
	var/input_amount = SHEET_MATERIAL_AMOUNT

	var/output_item = /obj/item
	var/output_amount = 1

	var/progress_step = 20 //steps per process
	var/temperature_step = 5 //kelvin per process

	var/minimum_skill = SKILL_NONE

/decl/extruder_recipe/proc/on_fabricate(var/obj/item/result)
	return