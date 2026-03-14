/obj/machinery/atmospherics/binary/regulated_valve
	name = "valve"
	desc = "A remote controlled valve."
	var/open_to = 0 //0-1
	icon = 'icons/obj/atmospherics/components/binary/regulated_valve.dmi'
	icon_state = "map_off"
	level = 2
	var/portvolume = 2000
	use_power = POWER_USE_IDLE
	idle_power_usage = 120
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_WATER

/obj/machinery/atmospherics/binary/regulated_valve/on
	icon_state = "map_on"

/obj/machinery/atmospherics/binary/regulated_valve/on/Initialize()
	. = ..()
	set_openage(100)

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
	var/pressure_delta = air1.pressure - air2.pressure
	if(pressure_delta < 0)
		return
	var/target_mole_flow = calculate_pressure_flow(pressure_delta, air2.volume) * open_to
	var/mole_flow_diff = target_mole_flow - air1.total_moles
	if(mole_flow_diff > 0)
		air1.suction_moles = mole_flow_diff
	else
		air1.suction_moles = 0

	air2.merge(air1.remove(target_mole_flow))
	update_networks()
	update_icon()

/obj/machinery/atmospherics/binary/regulated_valve/inconel
	icon_state = "reactor_off"

/obj/machinery/atmospherics/binary/regulated_valve/inconel/on_update_icon()
	if(stat & NOPOWER)
		icon_state = "reactor_off"
	else
		icon_state = "reactor_on"