/obj/machinery/atmospherics/unary/small_caster
	name = "small metal caster"
	icon = 'icons/obj/atmospherics/components/unary/cold_sink.dmi'
	icon_state = "intact_off"
	var/obj/item/casting_shape/loaded_shape
	var/opened = FALSE

/obj/machinery/atmospherics/unary/small_caster/examine(mob/user)
	. = ..()
	if(loaded_shape)
		to_chat(user, SPAN_NOTICE("It has \a [loaded_shape] in it."))

/obj/machinery/atmospherics/unary/small_caster/attackby(obj/item/I, mob/user)
	. = ..()
	if(istype(I, /obj/item/casting_shape))
		if(!loaded_shape)
			if(!do_after(user, 15, src))
				return
			loaded_shape = I
			user.drop_from_inventory(I, src)
			visible_message(SPAN_NOTICE("[user] inserts \a [I] in \the [src]."))
			icon_state = "intact_on"
		else
			to_chat(user, SPAN_NOTICE("There is already a casting shape in \the [src]."))
		return
	if(IS_CROWBAR(I) && loaded_shape)
		if(!do_after(user, 15, src))
			return
		visible_message(SPAN_NOTICE("[user] removes \the [loaded_shape] from \the [src]."))
		user.put_in_hands(loaded_shape)
		loaded_shape = null
		icon_state = "intact_off"
		return

/obj/machinery/atmospherics/unary/small_caster/physical_attack_hand(user)
	. = ..()
	opened = !opened
	if(opened)
		visible_message(SPAN_NOTICE("[user] opens the valve on \the [src]."))
	else
		visible_message(SPAN_NOTICE("[user] closes the valve on \the [src]."))

/obj/machinery/atmospherics/unary/small_caster/Process()
	. = ..()
	if(opened)
		if(loaded_shape)
			if(loaded_shape.filled)
				return
			var/used_mat
			for(var/mat in air_contents.gas)
				if(air_contents.phases[mat] == MAT_PHASE_GAS)
					continue
				if(!(mat in loaded_shape.accepted_materials))
					return
				used_mat = mat
			if(!used_mat)
				return
			var/decl/material/mat_datum = GET_DECL(used_mat)
			var/total_available_mass = air_contents.get_mass()
			if(loaded_shape.weight_cost > total_available_mass)
				return
			var/moles_to_remove = air_contents.specific_mass() * loaded_shape.weight_cost
			air_contents.remove(moles_to_remove)
			loaded_shape.hot = TRUE
			loaded_shape.temperature = mat_datum.melting_point + 76
			loaded_shape.filled = used_mat
			loaded_shape.update_icon()
		else //spill on the floor if no shape present
			var/spilled_fluid
			for(var/g in air_contents.gas)
				if(air_contents.phases[g] == MAT_PHASE_LIQUID)
					spilled_fluid = g
					break
			if(!spilled_fluid)
				return
			var/turf/T = get_turf(src)
			T.add_fluid(spilled_fluid, air_contents.gas[spilled_fluid], ntemperature = air_contents.temperature)
			air_contents.adjust_gas(spilled_fluid, air_contents.gas[spilled_fluid]*-1)
