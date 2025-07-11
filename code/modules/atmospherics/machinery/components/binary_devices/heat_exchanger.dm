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

/obj/machinery/atmospherics/binary/heat_exchanger/Process()
	. = ..()

	if(!connected || !air1.total_moles || !engaged)
		return

	if(heating)
		if(connected.air1.temperature < wanted_temperature)
			return FALSE
	else
		if(connected.air1.temperature > wanted_temperature)
			return FALSE

	var/our_heat_capacity = air1.heat_capacity()
	var/their_heat_capacity = connected.air1.heat_capacity()

	if(!their_heat_capacity || !our_heat_capacity)
		return FALSE

	// Account for latent heat
	var/latent_heat_energy = 0
	var/latent_heat_capacity = 0
	var/list/all_fluid = air1.get_fluid()
	if(heating)
		for(var/f_type in all_fluid)
			var/decl/material/mat = GET_DECL(f_type)
			if(air1.temperature < mat.boiling_point && wanted_temperature > mat.boiling_point)
				latent_heat_energy += all_fluid[f_type] * mat.latent_heat
	else
		for(var/f_type in all_fluid)
			var/decl/material/mat = GET_DECL(f_type)
			if(air1.temperature > mat.boiling_point && wanted_temperature < mat.boiling_point)
				latent_heat_energy -= all_fluid[f_type] * mat.latent_heat
	latent_heat_capacity = latent_heat_energy / air1.total_moles

	var/temperature_delta = wanted_temperature - air1.temperature
	var/required_energy_delta = (temperature_delta * our_heat_capacity) + latent_heat_energy

	var/available_energy_delta = (connected.air1.temperature - wanted_temperature) * their_heat_capacity

	var/actual_energy_delta
	if(heating)
		actual_energy_delta = min(available_energy_delta, required_energy_delta)
	else
		actual_energy_delta = max(available_energy_delta, required_energy_delta)

	//var/moles_to_transfer = abs(actual_energy_delta) / max(our_heat_capacity, their_heat_capacity)

	var/energy_per_mole = ((our_heat_capacity/air1.total_moles) * temperature_delta) + latent_heat_capacity

	air2.merge(air1.remove(abs(actual_energy_delta/energy_per_mole)))
	air2.add_thermal_energy(actual_energy_delta)

	connected.air2.merge(connected.air1.remove(abs((actual_energy_delta / their_heat_capacity) * temperature_delta)))
	connected.air2.add_thermal_energy(actual_energy_delta * -1)

	update_networks()

	return 1

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
	minimum_temperature = 60 CELSIUS
	volume = 60000
	engaged = FALSE