/obj/machinery/atmospherics/binary/regulated_valve
	name = "valve"
	desc = "A remote controlled valve."
	var/manual = FALSE
	var/open_to = 0 //0-1
	icon = 'icons/obj/atmospherics/components/binary/regulated_valve.dmi'
	icon_state = "map_off"
	level = 2
	var/last_mass_flow = 0
	var/portvolume = 2000
	use_power = POWER_USE_IDLE
	idle_power_usage = 120

/obj/machinery/atmospherics/binary/regulated_valve/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("The valve is open to [open_to * 100]%."))

/obj/machinery/atmospherics/binary/regulated_valve/Initialize()
	. = ..()
	if(uid)
		rcontrol.reactor_valves[uid] = src
	air1.volume = portvolume
	air2.volume = portvolume

/obj/machinery/atmospherics/binary/regulated_valve/on_update_icon()
	. = ..()
	if(stat & NOPOWER)
		icon_state = "off"
	else
		icon_state = "on"
	build_device_underlays(FALSE)

/obj/machinery/atmospherics/binary/regulated_valve/proc/adjust_openage(percent)
	open_to = Clamp(open_to + percent / 100, 0, 1)
	update_icon()

/obj/machinery/atmospherics/binary/regulated_valve/proc/set_openage(percent)
	open_to = percent / 100
	update_icon()

/obj/machinery/atmospherics/binary/regulated_valve/Process()
	..()
	//flow rate limit
	var/transfer_moles = air1.total_moles * open_to
	if(!transfer_moles)
		return
	var/transfer_mass = air1.net_flow_mass * open_to

	pump_gas_passive(src, air1, air2, transfer_moles)
	pump_fluid_passive(src, air1, air2, transfer_mass)
	update_networks()
	update_icon()
	last_mass_flow = transfer_mass