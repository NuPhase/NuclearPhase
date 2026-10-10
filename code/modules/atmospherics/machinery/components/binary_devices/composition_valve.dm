/obj/machinery/atmospherics/binary/composition_valve
	icon = 'icons/obj/atmospherics/components/binary/passive_gate.dmi'
	icon_state = "map_off"
	level = 1

	name = "composition valve"
	desc = "A one-way valve that opens when the concentration of the selected fluid drops below a set percentage. Can be used for chemical reactors."

	interact_offline = TRUE

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_SUPPLY
	build_icon_state = "passivegate"

	identifier = "AGR"
	uncreated_component_parts = null // Does not need power components; does not come with radio stuff, have to install it manually.

	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/default/panel_closed/item_chassis
	base_type = /obj/machinery/atmospherics/binary/composition_valve

	var/opened = FALSE
	var/comp_threshold = 0.25 // coefficient
	var/comp_fluid = /decl/material/gas/hydrogen

/obj/machinery/atmospherics/binary/composition_valve/examine(mob/user)
	. = ..()
	var/decl/material/mat = GET_DECL(comp_fluid)
	to_chat(user, SPAN_NOTICE("It opens at below [round(comp_threshold * 100, 0.1)]% of [mat.name]."))

/obj/machinery/atmospherics/binary/composition_valve/on_update_icon()
	icon_state = (opened)? "on" : "off"
	build_device_underlays(FALSE)

/obj/machinery/atmospherics/binary/composition_valve/hide(var/i)
	update_icon()

/obj/machinery/atmospherics/binary/composition_valve/Process()
	. = ..()

	var/alist/all_fluid = air2.get_fluid(comp_fluid)
	if(all_fluid[comp_fluid]/air2.total_moles < comp_threshold)
		open()
	else
		close()

	if(opened)
		if(pump_gas_passive(src, air1, air2) != -1)
			update_networks()

/obj/machinery/atmospherics/binary/composition_valve/proc/open()
	if(opened)
		return
	opened = TRUE
	update_icon()

/obj/machinery/atmospherics/binary/composition_valve/proc/close()
	if(!opened)
		return
	opened = FALSE
	update_icon()