#define COOLANT_MOLES_08 (42400000*0.9)

// Main core. Features all logic and interactions.
/obj/machinery/multitile/fission_reactor_vessel
	name = "BRO-SMUT pressure vessel"
	desc = "Быстрый Реактор Опытный - С Металлическим Улучшенным Теплоносителем pressure vessel. Contains the reactor cole and the primary coolant reserve."
	anchored = TRUE
	density = TRUE
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	icon = 'icons/obj/machines/fission_vessel.dmi'
	icon_state = "normal"
	bound_width = 160
	bound_height = 160
	width = 4
	height = 4

	map_ports = list(
		list(0, 0, SOUTH, "Emergency HX Inlet"),
		list(0, 0, SOUTH, "Emergency HX Outlet"),
		list(4, 0, SOUTH, "Cold Coolant Inlet"),
		list(4, 1, EAST, "Hot Coolant Outlet"),
		list(0, 3, WEST, "Head Vent")
	)

	var/datum/fission_matrix/core_matrix

	var/circ_pump_speed = 0
	var/circ_pump_setpoint = 0

	var/inlet_temperature = 0
	var/inlet_flow = 0

/obj/machinery/multitile/fission_reactor_vessel/Initialize()
	. = ..()
	var/datum/gas_mixture/coolant_in = port_gases["Cold Coolant Inlet"]
	var/datum/gas_mixture/coolant_out = port_gases["Hot Coolant Outlet"]
	coolant_in.volume = 50000
	coolant_out.volume = 50000

	core_matrix = new()
	fission_reactor_components["core"] = src

/obj/machinery/multitile/fission_reactor_vessel/Process()
	handle_coolant()
	handle_circulation()
	handle_radiation()

/obj/machinery/multitile/fission_reactor_vessel/proc/handle_coolant()
	var/datum/gas_mixture/coolant_in = port_gases["Cold Coolant Inlet"]
	var/datum/gas_mixture/coolant_out = port_gases["Hot Coolant Outlet"]
	inlet_temperature = coolant_in.temperature
	var/datum/gas_mixture/removed = coolant_in.remove_ratio(0.8)
	inlet_flow = removed.get_mass()
	core_matrix.vessel.merge(removed)
	var/liquid_moles = core_matrix.vessel.total_moles - core_matrix.vessel.gas_moles
	if(coolant_out.available_volume > 2000 && liquid_moles > COOLANT_MOLES_08)
		coolant_out.merge(core_matrix.vessel.remove(min(75000, liquid_moles - COOLANT_MOLES_08)))

/obj/machinery/multitile/fission_reactor_vessel/proc/handle_circulation()
	if(circ_pump_speed == circ_pump_setpoint)
		return
	var/speed_delta = circ_pump_speed - circ_pump_setpoint
	if(abs(speed_delta) < 1) // within one percent, lock to setpoint
		circ_pump_speed = circ_pump_setpoint
		core_matrix.recirc_flow = 10 + (circ_pump_speed * 0.9)
		return
	if(speed_delta > 0)
		circ_pump_speed = Interpolate(circ_pump_speed, circ_pump_setpoint, 0.5)
	else
		circ_pump_speed = Interpolate(circ_pump_speed, circ_pump_setpoint, 0.1)
	core_matrix.recirc_flow = 10 + (circ_pump_speed * 0.9)

/obj/machinery/multitile/fission_reactor_vessel/proc/handle_radiation()
	var/radiation_emitted = core_matrix.total_neutrons * 1000000000
	SSradiation.radiate(src, radiation_emitted)

#undef COOLANT_MOLES_08