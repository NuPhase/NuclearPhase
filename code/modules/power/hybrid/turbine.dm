#define TURBINE_MOMENT_OF_INERTIA 2375 //0.5m radius, 9500kg weight
#define KGS_PER_KPA_DIFFERENCE 0.6 //For every kPa of pressure difference we gain that amount of kgs of flow

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
	var/kin_loss = 0.001
	var/expansion_ratio = 0.2
	var/volume_ratio = 0.8
	var/steam_velocity = 0
	var/pressure_difference = 0
	var/total_mass_flow = 0
	var/rpm = 0
	var/braking = FALSE //emergency brakes
	var/vibration = 0 //0-25 is minor, 25-50 is major, anything above is critical

/obj/machinery/atmospherics/binary/turbinestage/Initialize()
	. = ..()
	air1.volume = 20000
	air2.volume = 80000
	reactor_components[uid] = src

/obj/machinery/atmospherics/binary/turbinestage/Process()
	. = ..()
	total_mass_flow = air1.net_flow_mass
	pressure_difference = max(air1.return_pressure() - air2.return_pressure(), 0)
	total_mass_flow += pressure_difference * KGS_PER_KPA_DIFFERENCE
	steam_velocity = ((total_mass_flow * 3600) * 1.694) / 11304
	var/kin_total = 0.05 * (total_mass_flow * steam_velocity**2) * expansion_ratio
	air1.add_thermal_energy(!kin_total)
	kin_energy += kin_total * efficiency
	var/datum/gas_mixture/air_all = new
	air_all.volume = air1.volume + air2.volume
	pump_passive(air1, air_all, total_mass_flow)
	air_all.temperature *= volume_ratio ** ADIABATIC_EXPONENT
	air2.merge(air_all)
	var/new_rpm = round(sqrt(kin_energy / (0.5 * TURBINE_MOMENT_OF_INERTIA)))
	if(braking) //TODO: MAKE DAMAGE FROM THIS
		var/datum/gas_mixture/environment = loc.return_air()
		kin_energy = kin_energy * 0.9
		environment.add_thermal_energy(kin_energy * 0.1)
	rpm = Clamp(Interpolate(rpm, new_rpm, 0.1), 0, 5000)

/obj/machinery/power/turbine_generator
	name = "motor"
	desc = "Electrogenerator. Converts rotation into power."
	icon = 'icons/obj/atmospherics/components/unary/pipeturbine.dmi'
	icon_state = "motor"
	anchored = 1
	density = 1
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE

	var/obj/machinery/atmospherics/binary/turbinestage/turbine

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/default/panel_closed
	var/connected = FALSE
	var/last_load = 0

/obj/machinery/power/turbine_generator/Initialize()
	. = ..()
	updateConnection()
	connect_to_network()

/obj/machinery/power/turbine_generator/proc/updateConnection()
	turbine = null
	if(src.loc && anchored)
		turbine = locate(/obj/machinery/atmospherics/binary/turbinestage) in get_step(src,dir)
		if (turbine.stat & (BROKEN) || !turbine.anchored || turn(turbine.dir,180) != dir)
			turbine = null

/obj/machinery/power/turbine_generator/Process()
	updateConnection()
	if(!turbine || !anchored)
		return

	if(connected)
		var/power_generated = powernet.load + 100000
		last_load = powernet.load
		turbine.kin_energy -= power_generated
		generate_power(power_generated)

/datum/composite_sound/turbine
	start_sound = 'sound/machines/turbine_start.ogg'
	start_length = 155
	mid_sounds = list('sound/machines/turbine_mid.ogg'=1)
	mid_length = 180
	end_sound = 'sound/machines/turbine_end.ogg'
	volume = 300
	sfalloff = 3

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