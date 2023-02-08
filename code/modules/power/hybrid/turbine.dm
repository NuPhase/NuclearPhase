/obj/machinery/atmospherics/binary/turbinestage
	name = "turbine stage"
	desc = "A steam turbine section. Converting pressure into energy since 1884."
	//icon = 'icons/obj/machines/power/turbine.dmi'
	//icon_state = "off"
	dir = 1
	layer = BELOW_OBJ_LAYER
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	level = 1
	density = 1
	anchored = 1

	use_power = POWER_USE_OFF
	idle_power_usage = 150
	identifier = "TURBINE0"

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/noninteractive

	var/efficiency = 0.4
	var/kin_energy = 0
	var/volume_ratio = 0.5 //AKA expansion ratio. Higher means less steam is used, but results in better overall efficiency.
	var/kin_loss = 0.001
	var/transferring_kin_energy = TRUE
	var/dP = 0
	var/obj/machinery/atmospherics/binary/turbinestage/nextstage = null

/obj/machinery/atmospherics/binary/turbinestage/Initialize()
	. = ..()
	var/turf/T = get_step(src, NORTH)
	for(var/obj/machinery/power/turbine_generator/gen in T.contents)
		if(gen)
			transferring_kin_energy = FALSE
			return
	for(var/obj/machinery/atmospherics/binary/turbinestage/newstage in T.contents)
		nextstage = newstage

/obj/machinery/atmospherics/binary/turbinestage/Process()
	. = ..()
	if(nextstage)
		nextstage.kin_energy += kin_energy
		kin_energy = 0

/obj/machinery/atmospherics/binary/turbinestage/hp
	efficiency = 0.2
	volume_ratio = 0.5

/obj/machinery/atmospherics/binary/turbinestage/hp/Process()
	. = ..()
	kin_energy *= 1 - kin_loss
	dP = max(air1.return_pressure() - air2.return_pressure(), 0)
	if(dP > 10)
		kin_energy += 1/ADIABATIC_EXPONENT * dP * air1.volume * (1 - volume_ratio**ADIABATIC_EXPONENT) * efficiency
		air1.temperature *= volume_ratio**ADIABATIC_EXPONENT

		var/datum/gas_mixture/air_all = new
		air_all.volume = air1.volume + air2.volume
		air_all.merge(air1.remove_ratio(1))
		air_all.merge(air2.remove_ratio(1))

		air1.merge(air_all.remove(volume_ratio))
		air2.merge(air_all)

	update_networks()

/obj/machinery/atmospherics/binary/turbinestage/reheat
	efficiency = 0.3
	volume_ratio = 0.7

/obj/machinery/atmospherics/binary/turbinestage/reheat/Process()
	. = ..()
	kin_energy *= 1 - kin_loss
	dP = max(air1.return_pressure() - air2.return_pressure(), 0)
	if(dP > 10)
		kin_energy += 1/ADIABATIC_EXPONENT * dP * air1.volume * (1 - volume_ratio**ADIABATIC_EXPONENT) * efficiency
		air1.temperature *= volume_ratio**ADIABATIC_EXPONENT

		var/datum/gas_mixture/air_all = new
		air_all.volume = air1.volume + air2.volume
		air_all.merge(air1.remove_ratio(1))
		air_all.merge(air2.remove_ratio(1))

		air1.merge(air_all.remove(volume_ratio))
		air2.merge(air_all)

	update_networks()

/obj/machinery/atmospherics/binary/turbinestage/exhaust
	efficiency = 0.3
	volume_ratio = 0.7

/obj/machinery/atmospherics/binary/turbinestage/exhaust/Process()
	. = ..()
	kin_energy *= 1 - kin_loss
	dP = max(air1.return_pressure() - air2.return_pressure(), 0)
	if(dP > 10)
		kin_energy += 1/ADIABATIC_EXPONENT * dP * air1.volume * (1 - volume_ratio**ADIABATIC_EXPONENT) * efficiency
		air1.temperature *= volume_ratio**ADIABATIC_EXPONENT

		var/datum/gas_mixture/air_all = new
		air_all.volume = air1.volume + air2.volume
		air_all.merge(air1.remove_ratio(1))
		air_all.merge(air2.remove_ratio(1))

		air1.merge(air_all.remove(volume_ratio))
		air2.merge(air_all)

	update_networks()

/obj/machinery/atmospherics/binary/turbinestage/lp
	efficiency = 0.5
	volume_ratio = 0.5

/obj/machinery/atmospherics/binary/turbinestage/lp/Process()
	. = ..()
	kin_energy *= 1 - kin_loss
	dP = max(air1.return_pressure() - air2.return_pressure(), 0)
	if(dP > 10)
		kin_energy += 1/ADIABATIC_EXPONENT * dP * air1.volume * (1 - volume_ratio**ADIABATIC_EXPONENT) * efficiency
		air1.temperature *= volume_ratio**ADIABATIC_EXPONENT

		var/datum/gas_mixture/air_all = new
		air_all.volume = air1.volume + air2.volume
		air_all.merge(air1.remove_ratio(1))
		air_all.merge(air2.remove_ratio(1))

		air1.merge(air_all.remove(volume_ratio))
		air2.merge(air_all)

	update_networks()

/obj/machinery/power/turbine_generator

/obj/structure/turbine_visual
	name = "turbine"
	desc = "A gas turbine. Converting pressure into energy since 1884."
	icon = 'icons/obj/machines/power/turbine.dmi'
	icon_state = "off"
	layer = ABOVE_OBJ_LAYER
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	anchored = 1
	level = 1
	density = 1
	bound_x = 96
	bound_y = 192