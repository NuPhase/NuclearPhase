/obj/machinery/atmospherics/unary/dissolving_bioreactor
	name = "Dissolving bio-reactor"
	icon = 'icons/obj/atmospherics/atmos.dmi'
	density = TRUE
	var/base_icon_state = "dhum"
	var/is_active = FALSE
	var/list/associative_stage_materials = list(
		1 = list(/decl/material/gas/hydrogen = 0.8, /decl/material/liquid/water = 0.2),
		2 = list(/decl/material/gas/carbon_dioxide = 0.5, /decl/material/gas/ammonia = 0.2, /decl/material/gas/sulfur_dioxide = 0.3),
		3 = list(/decl/material/gas/carbon_dioxide = 0.1, /decl/material/gas/hydrogen = 0.1, /decl/material/liquid/acetone = 0.8),
		4 = list(/decl/material/gas/methane = 0.5, /decl/material/gas/carbon_dioxide = 0.2, /decl/material/liquid/water = 0.3)
	)
	var/list/allowed = list(/obj/item/wrench = 100)
	var/cur_material_amount = 0
	var/min_matter = 5
	var/fart_modifier = 1

/obj/machinery/atmospherics/unary/dissolving_bioreactor/Initialize()
	. = ..()
	update_icon()

/obj/machinery/atmospherics/unary/dissolving_bioreactor/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_INFO("The amount of reagent inside: [cur_material_amount]"))
	if (is_active)
		to_chat(user, SPAN_INFO("[src] is active."))

/obj/machinery/atmospherics/unary/dissolving_bioreactor/on_update_icon()
	icon_state = "[base_icon_state][is_active ? "-on" : "-off"]"
	. = ..()

/obj/machinery/atmospherics/unary/dissolving_bioreactor/attackby(obj/item/I, mob/user)
	if(!is_type_in_list(I, allowed))
		return

	visible_message(SPAN_INFO("[user] loads \the [I] in [src]!"))
	cur_material_amount += allowed[I.type]
	qdel(I)
	is_active = TRUE
	update_icon()
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	. = ..()

/obj/machinery/atmospherics/unary/dissolving_bioreactor/Process()
	if(cur_material_amount <= min_matter)
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		is_active = FALSE
		update_icon()
		return
	var/react_amount = fart_modifier * cur_material_amount
	var/react_stage_amount = react_amount * 0.25

	for(var/cur_stage in range(1, 4))
		var/cur_react_amount = react_stage_amount
		cur_material_amount -= cur_react_amount
		while(cur_react_amount > 0)
			cur_react_amount -= consoom_and_fart(cur_react_amount, associative_stage_materials[cur_stage])

/obj/machinery/atmospherics/unary/dissolving_bioreactor/proc/consoom_and_fart(var/available_reactants = 0, var/list/released_materials)
	var/to_fart = available_reactants * fart_modifier
	for(var/mat_type in released_materials)
		air_contents.adjust_gas_temp(mat_type, to_fart * released_materials[mat_type], 317)
	return to_fart