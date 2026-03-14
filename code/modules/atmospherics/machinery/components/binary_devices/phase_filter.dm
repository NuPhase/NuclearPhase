/obj/machinery/atmospherics/binary/phase_filter // DO NOT use this one
	icon = 'icons/obj/atmospherics/components/binary/regulated_valve.dmi'
	icon_state = "map_off"
	level = 2
	use_power = POWER_USE_IDLE
	idle_power_usage = 120
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_WATER

	var/filtering_phase

/obj/machinery/atmospherics/binary/phase_filter/Process()
	. = ..()
	var/pressure_delta = air1.pressure - air2.pressure
	if(pressure_delta < 0)
		return
	var/target_mole_flow = calculate_pressure_flow(pressure_delta, air2.volume)
	var/mole_flow_diff = target_mole_flow - air1.total_moles
	if(mole_flow_diff > 0)
		air1.suction_moles = mole_flow_diff
	else
		air1.suction_moles = 0

	air2.merge(air1.remove_phase(target_mole_flow, filtering_phase))
	update_networks()

/obj/machinery/atmospherics/binary/phase_filter/gas
	name = "degasser"
	desc = "Only lets gases through."
	filtering_phase = MAT_PHASE_GAS

/obj/machinery/atmospherics/binary/phase_filter/liquid
	name = "osmotic filter"
	desc = "Only lets liquids through."
	filtering_phase = MAT_PHASE_LIQUID

/obj/machinery/atmospherics/binary/phase_filter/solid
	name = "solid filter"
	desc = "Only lets solids through."
	filtering_phase = MAT_PHASE_SOLID