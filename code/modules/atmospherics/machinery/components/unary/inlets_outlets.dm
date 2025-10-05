/obj/machinery/atmospherics/unary/reagent_inlet
	icon = 'icons/obj/atmospherics/pipes/pipes-s.dmi'
	icon_state = "inlet"

	name = "pipe inlet"
	desc = "For adding reagents to a pipe network. Click it with a container to add reagents."

	dir = SOUTH
	initialize_directions = SOUTH

	interact_offline = TRUE
	uncreated_component_parts = null
	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/pipe

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL|CONNECT_TYPE_WATER
	build_icon_state = "inlet"

	pipe_class = PIPE_CLASS_UNARY

/obj/machinery/atmospherics/unary/reagent_inlet/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/chems))
		if(air_contents.pressure > MAX_PUMP_PRESSURE)
			to_chat(user, SPAN_WARNING("The pipe is too overpressured to add fluids."))
			return
		var/obj/item/chems/CI = I
		for(var/reagent_type in CI.reagents.reagent_volumes)
			var/amount = CI.reagents.reagent_volumes[reagent_type]
			CI.reagents.remove_reagent(reagent_type, amount)
			var/decl/material/mat = GET_DECL(reagent_type)
			air_contents.adjust_gas_temp(reagent_type, amount/mat.molar_volume, CI.temperature, FALSE)
		air_contents.update_values()
		playsound(src, 'sound/chemistry/pour/jerry_can.mp3', 80, 0)
		return
	. = ..()

/obj/machinery/atmospherics/unary/reagent_inlet/receive_mouse_drop(atom/dropping, mob/living/user)
	. = ..()
	if(istype(dropping, /obj/structure/reagent_dispensers))
		if(air_contents.pressure > MAX_PUMP_PRESSURE)
			to_chat(user, SPAN_WARNING("The pipe is too overpressured to add fluids."))
			return
		var/tank_volume = air_contents.volume * 500
		var/datum/reagents/temp_holder = new(tank_volume)
		var/actually_transferred = dropping.reagents.trans_to_holder(temp_holder, tank_volume)
		for(var/reagent_type in temp_holder.reagent_volumes)
			var/amount = temp_holder.reagent_volumes[reagent_type]
			var/decl/material/mat = GET_DECL(reagent_type)
			air_contents.adjust_gas(reagent_type, amount/mat.molar_volume, FALSE)
		air_contents.update_values()
		playsound(src, 'sound/chemistry/pour/jerry_can.mp3', 80, 0)
		user.visible_message(SPAN_NOTICE("[user] fills \the [src] from \the [dropping]."), SPAN_NOTICE("You fill \the [src] with [round(actually_transferred*0.001)]L from \the [dropping]."))
		return

/obj/machinery/atmospherics/unary/reagent_outlet
	icon = 'icons/obj/atmospherics/pipes/pipes-s.dmi'
	icon_state = "trunk"

	name = "pipe outlet"
	desc = "For removing reagents from a pipe network. Click it with a container to do so."

	dir = SOUTH
	initialize_directions = SOUTH

	interact_offline = TRUE
	uncreated_component_parts = null
	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/pipe

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL|CONNECT_TYPE_WATER
	build_icon_state = "trunk"

	pipe_class = PIPE_CLASS_UNARY

/obj/machinery/atmospherics/unary/reagent_outlet/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/chems))
		if(air_contents.pressure < ONE_ATMOSPHERE)
			to_chat(user, SPAN_WARNING("The pressure is too low to remove fluids."))
			return
		var/obj/item/chems/CI = I
		var/list/all_fluid = air_contents.get_fluid()
		var/volume_per_mat = REAGENTS_FREE_SPACE(CI.reagents) / length(all_fluid)
		for(var/mat_type in all_fluid)
			var/decl/material/mat = GET_DECL(mat_type)
			var/amount = min(volume_per_mat, all_fluid[mat_type]*mat.molar_volume)
			CI.reagents.add_reagent(mat_type, amount, defer_update = TRUE)
			air_contents.remove_gas(mat_type, amount/mat.molar_volume)
		CI.reagents.update_total()
		CI.update_icon()
		air_contents.update_values()
		playsound(src, 'sound/chemistry/pour/jerry_can.mp3', 80, 0)
		return
	. = ..()

/obj/machinery/atmospherics/unary/reagent_outlet/receive_mouse_drop(atom/dropping, mob/living/user)
	. = ..()
	if(istype(dropping, /obj/structure/reagent_dispensers))
		if(air_contents.pressure < ONE_ATMOSPHERE)
			to_chat(user, SPAN_WARNING("The pressure is too low to remove fluids."))
			return
		var/list/all_fluid = air_contents.get_fluid()
		var/volume_per_mat = REAGENTS_FREE_SPACE(dropping.reagents) / length(all_fluid)
		for(var/mat_type in all_fluid)
			var/decl/material/mat = GET_DECL(mat_type)
			var/amount = min(volume_per_mat, all_fluid[mat_type]*mat.molar_volume)
			dropping.reagents.add_reagent(mat_type, amount, defer_update = TRUE)
			air_contents.remove_gas(mat_type, amount/mat.molar_volume)
		dropping.reagents.update_total()
		dropping.update_icon()
		air_contents.update_values()
		playsound(src, 'sound/chemistry/pour/jerry_can.mp3', 80, 0)
		return