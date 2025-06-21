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
	air2.volume = volume
	for(var/sdir in global.cardinal)
		connected = locate(/obj/machinery/atmospherics/binary/heat_exchanger) in get_step(src,sdir)
		if(connected)
			break

/obj/machinery/atmospherics/binary/heat_exchanger/Process()
	build_network()
	if(!connected || !air1.total_moles || !engaged)
		return

	//Individual heat capacities
	var/our_heat_capacity = air1.heat_capacity()
	var/their_heat_capacity = connected.air1.heat_capacity()

	//How much energy we have for heat transfer
	var/available_transfer_energy = (their_heat_capacity * connected.air1.temperature) - (their_heat_capacity * connected.minimum_temperature)

	//How much moles can we actually exchange and transfer
	var/temperature_delta = wanted_temperature - air1.temperature
	var/energy_per_mole = temperature_delta * (our_heat_capacity / air1.total_moles)
	var/required_energy = air1.total_moles * energy_per_mole
	var/spent_energy = min(available_transfer_energy, required_energy)
	var/moles_to_transfer = spent_energy / energy_per_mole

	//Actually transfer the fluid and add/remove heat
	air2.merge(air1.remove(moles_to_transfer))
	air2.temperature = wanted_temperature
	connected.air2.merge(connected.air1.remove(moles_to_transfer))
	connected.air2.temperature = connected.minimum_temperature

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