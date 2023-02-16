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

	var/efficiency = 0.8
	var/kin_energy = 0
	var/kin_loss = 0.001
	var/transferring_kin_energy = TRUE
	var/expansion_ratio = 0.2
	var/steam_velocity = 0
	var/pressure_difference = 0
	var/total_mass_flow = 0
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
	air1.volume = 2000
	air2.volume = 8000

/obj/machinery/atmospherics/binary/turbinestage/Process()
	. = ..()
	if(nextstage)
		nextstage.kin_energy += kin_energy
		kin_energy = 0
	total_mass_flow = air1.net_flow_mass
	pressure_difference = max(air1.return_pressure() - air2.return_pressure(), 0)
	steam_velocity = ((total_mass_flow * 3600) * 1.694) / 11304
	var/kin_total = 0.5 * (total_mass_flow * steam_velocity**2) * expansion_ratio
	air1.add_thermal_energy(!kin_total)
	kin_energy = kin_total * efficiency
	var/datum/gas_mixture/air_all = new
	air_all.volume = air1.volume + air2.volume
	air_all.merge(air1.remove_ratio(1))
	air_all.merge(air2.remove_ratio(1))
	air2.merge(air_all)

/obj/machinery/atmospherics/binary/turbinestage/hp

/obj/machinery/atmospherics/binary/turbinestage/reheat

/obj/machinery/atmospherics/binary/turbinestage/exhaust

/obj/machinery/atmospherics/binary/turbinestage/lp

/obj/machinery/power/turbine_generator

/datum/composite_sound/turbine
	start_sound = 'sound/machines/turbine_start.ogg'
	start_length = 155
	mid_sounds = list('sound/machines/turbine_mid.ogg'=1)
	mid_length = 180
	end_sound = 'sound/machines/turbine_end.ogg'
	volume = 250

/obj/structure/turbine_visual
	name = "turbine"
	desc = "A gas turbine. Converting pressure into energy since 1884."
	icon = 'icons/obj/machines/power/turbine.dmi'
	icon_state = "off"
	layer = ABOVE_OBJ_LAYER
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	anchored = 1
	level = 2
	density = 1
	bound_x = 96
	bound_y = 192
	var/datum/composite_sound/turbine/soundloop

/obj/structure/turbine_visual/proc/spool_up()
	soundloop = new(list(src, GET_ABOVE(src.loc)), TRUE)

/obj/structure/turbine_visual/proc/spool_down()
	QDEL_NULL(soundloop)