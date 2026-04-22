/*
The heat exchanger takes in a fluid, exhanges its temperature with the connected heat exchanger and spits it out
*/

/obj/machinery/atmospherics/binary/heat_exchanger
	icon = 'icons/obj/atmospherics/components/binary/pump.dmi'
	icon_state = "map_off"
	level = 1

	name = "heat exchanger"

	identifier = "HE"

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL|CONNECT_TYPE_WATER
	build_icon_state = "pump"

	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/pipe
	base_type = /obj/machinery/atmospherics/binary/heat_exchanger

	var/volume = ATMOS_DEFAULT_VOLUME_PUMP

	var/obj/machinery/atmospherics/binary/heat_exchanger/connected = null

	var/wanted_temperature = T20C
	var/minimum_temperature = TCMB
	var/heating = TRUE //whether this side should be cooled or heated
	var/engaged = TRUE //whether it should be active at all

/obj/machinery/atmospherics/binary/heat_exchanger/Initialize()
	. = ..()
	air1.volume = volume
	air1.suction_moles = volume
	air2.volume = volume
	for(var/sdir in global.cardinal)
		connected = locate(/obj/machinery/atmospherics/binary/heat_exchanger) in get_step(src,sdir)
		if(connected)
			break

/obj/machinery/atmospherics/binary/heat_exchanger/Destroy()
	. = ..()
	QDEL_NULL(connected)

/obj/machinery/atmospherics/binary/heat_exchanger/Process()
	. = ..()

	if(!engaged || !connected?.air1.total_moles || !air1.total_moles)
		return
	// We are the processing side.
	// We need to see how much energy is available, then how much we need, and then apply that

	// First of all, just pass fluid if conditions we need are already met
	if(heating)
		if(air1.temperature > wanted_temperature)
			pass_fluid()
			return
	else
		if(air1.temperature < wanted_temperature)
			pass_fluid()
			return

	// Second, get all the needed data for calcs
	var/our_heat_capacity = air1.heat_capacity()
	var/their_heat_capacity = connected.air1.heat_capacity()

	var/latent_heat_energy = 0
	var/latent_heat_capacity = 0
	var/alist/all_fluid = air1.get_fluid()
	if(heating)
		for(var/f_type, f_amount in all_fluid)
			var/decl/material/mat = GET_DECL(f_type)
			if(air1.temperature < mat.boiling_point && wanted_temperature > mat.boiling_point)
				latent_heat_energy += f_amount * mat.latent_heat
	else
		for(var/f_type, f_amount in all_fluid)
			var/decl/material/mat = GET_DECL(f_type)
			if(air1.temperature > mat.boiling_point && wanted_temperature < mat.boiling_point)
				latent_heat_energy -= f_amount * mat.latent_heat
	latent_heat_capacity = latent_heat_energy / air1.total_moles

	var/connected_latent_heat_energy = 0
	var/connected_latent_heat_capacity = 0
	var/alist/connected_fluid = connected.air1.get_fluid()
	if(connected.heating)
		for(var/f_type, amt in connected_fluid)
			var/decl/material/mat = GET_DECL(f_type)
			if(connected.air1.temperature < mat.boiling_point && wanted_temperature > mat.boiling_point)
				connected_latent_heat_energy += amt * mat.latent_heat
	else
		for(var/f_type, amt in connected_fluid)
			var/decl/material/mat = GET_DECL(f_type)
			if(connected.air1.temperature > mat.boiling_point && connected.minimum_temperature < mat.boiling_point)
				connected_latent_heat_energy -= amt * mat.latent_heat
	connected_latent_heat_capacity = connected_latent_heat_energy / connected.air1.total_moles

	// If this is negative, then give energy to connected. If positive, take from connected
	var/temperature_delta = wanted_temperature - air1.temperature
	var/required_energy_delta = (temperature_delta * our_heat_capacity) + latent_heat_energy

	var/available_energy_delta = (connected.air1.temperature - wanted_temperature) * their_heat_capacity

	var/actual_energy_delta
	if(heating)
		actual_energy_delta = min(available_energy_delta, required_energy_delta)
	else
		actual_energy_delta = max(available_energy_delta, required_energy_delta)

	var/energy_per_mole = ((our_heat_capacity/air1.total_moles) * temperature_delta) + latent_heat_capacity
	var/energy_per_mole_conn = ((their_heat_capacity/connected.air1.total_moles) * (wanted_temperature - connected.air1.temperature)) + connected_latent_heat_capacity

	var/datum/gas_mixture/removed = air1.remove(abs(actual_energy_delta/energy_per_mole))
	removed.add_thermal_energy(actual_energy_delta, boiling_coef = 0.999)
	air2.merge(removed)

	removed = connected.air1.remove(abs(actual_energy_delta/energy_per_mole_conn))
	removed.add_thermal_energy(actual_energy_delta * -1, boiling_coef = 0.999)
	connected.air2.merge(removed)

	update_networks()

	return 1

// Just pass fluid without heating it
/obj/machinery/atmospherics/binary/heat_exchanger/proc/pass_fluid()
	pump_passive(air1, air2, air1.get_mass())

/obj/machinery/atmospherics/binary/heat_exchanger/return_air()
	if(air1.return_pressure() > air2.return_pressure())
		return air1
	else
		return air2

/obj/machinery/atmospherics/binary/heat_exchanger/exchanger_tungsten
	heating = FALSE
	minimum_temperature = 3750 //we won't cool down further
	volume = 60000
	engaged = FALSE

/obj/machinery/atmospherics/binary/heat_exchanger/exchanger_steam
	heating = TRUE
	wanted_temperature = 1430
	volume = 60000

/obj/machinery/atmospherics/binary/heat_exchanger/condenser_cryo
	heating = TRUE
	wanted_temperature = 400
	volume = 60000

/obj/machinery/atmospherics/binary/heat_exchanger/condenser_steam
	heating = FALSE
	minimum_temperature = 350
	wanted_temperature = 350
	volume = 60000
	engaged = FALSE