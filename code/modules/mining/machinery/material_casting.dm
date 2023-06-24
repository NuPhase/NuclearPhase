/obj/machinery/atmospherics/unary/small_caster
	name = "small metal caster"
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
			loaded_shape = I
			user.drop_from_inventory(I, src)
			visible_message(SPAN_NOTICE("[user] inserts \a [I] in \the [src]."))
		else
			to_chat(user, SPAN_NOTICE("There is already a casting shape in \the [src]."))

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
			var/total_available_mass = air_contents.get_mass()
			if(loaded_shape.weight_cost > total_available_mass)
				return
			var/moles_to_remove = air_contents.specific_mass() * loaded_shape.weight_cost
			air_contents.remove(moles_to_remove)
			loaded_shape.filled = TRUE
			loaded_shape.icon_state = loaded_shape.filled_icon_state
		//spill on the floor if no shape present