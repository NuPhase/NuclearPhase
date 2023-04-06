#define TURBINE_MOMENT_OF_INERTIA 2075 //0.5m radius, 9500kg weight
#define MS_PER_KPA_DIFFERENCE 0.14 //For every kPa of pressure difference we gain so much m/s of steam speed
#define TURBINE_PERFECT_RPM 3550
#define TURBINE_ABNORMAL_RPM 4000
#define TURBINE_MAX_RPM 10000

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

	use_power = POWER_USE_IDLE
	idle_power_usage = 2000 //we have to keep it warm
	active_power_usage = 40000 //balancing systems, hydraulics, computing, etc
	identifier = "TURBINE0"

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/noninteractive

	var/efficiency = 0.91
	var/kin_energy = 0
	var/kin_total = 0 //last kin energy generation
	var/kin_loss = 0.0001
	var/expansion_ratio = 0.4
	var/volume_ratio = 0.6
	var/steam_velocity = 0
	var/pressure_difference = 0
	var/total_mass_flow = 0
	var/rpm = 0
	var/braking = FALSE //emergency brakes
	var/vibration = 0 //0-25 is minor, 25-50 is major, anything above is critical

	var/rotor_integrity = 100
	var/shaft_integrity = 100

	var/obj/machinery/atmospherics/binary/regulated_valve/ingoing_valve = null
	var/obj/structure/turbine_visual/visual = null

	var/valve_id = ""

/obj/machinery/atmospherics/binary/turbinestage/proc/get_vibration_flavor()
	switch(vibration)
		if(0 to 25)
			return "minor"
		if(26 to 50)
			return "major"
		if(51 to INFINITY)
			return "critical"

/obj/machinery/atmospherics/binary/turbinestage/Initialize()
	. = ..()
	air1.volume = 20000
	air2.volume = 80000
	reactor_components[uid] = src
	spawn(100)
		ingoing_valve = rcontrol.reactor_valves[valve_id]

/obj/machinery/atmospherics/binary/turbinestage/Process()
	. = ..()
	total_mass_flow = air1.net_flow_mass + air1.get_mass()*0.01 //barely enough to start it
	pressure_difference = max(air1.return_pressure() - air2.return_pressure(), 0)
	steam_velocity = (total_mass_flow * 3600 * 1.694) / 11304
	steam_velocity += pressure_difference * MS_PER_KPA_DIFFERENCE
	/*if(total_mass_flow < 50)
		total_mass_flow = 0
		steam_velocity = 0*/
	kin_total = 0.5 * (total_mass_flow * steam_velocity**2) * expansion_ratio
	air1.add_thermal_energy(!kin_total)
	kin_energy += kin_total * efficiency * (rotor_integrity * 0.01)
	var/datum/gas_mixture/air_all = new
	air_all.volume = air1.volume + air2.volume
	pump_passive(air1, air_all, total_mass_flow)
	air_all.temperature *= volume_ratio ** ADIABATIC_EXPONENT
	calculate_vibration(air_all)
	air2.merge(air_all)
	var/new_rpm = round(sqrt(kin_energy / (0.5 * TURBINE_MOMENT_OF_INERTIA)))
	if(braking)
		var/datum/gas_mixture/environment = loc.return_air()
		kin_energy = max(0, kin_energy * 0.95 - 10000)
		if(kin_energy)
			environment.add_thermal_energy(kin_energy * 0.05 + 10000)
	rpm = Clamp(Interpolate(rpm, new_rpm, 0.1), 0, TURBINE_MAX_RPM)
	ingoing_valve.forced_mass_flow = total_mass_flow //so we can succ enough steam

	apply_vibration_effects()
	calculate_efficiency()

	if(rpm > 250)
		use_power = POWER_USE_ACTIVE
		if(!visual.soundloop)
			visual.spool_up()
	else
		visual.spool_down()
		use_power = POWER_USE_IDLE

/obj/machinery/atmospherics/binary/turbinestage/proc/calculate_efficiency()
	efficiency = initial(efficiency)
	efficiency -= vibration * 0.005
	if(rpm < TURBINE_PERFECT_RPM)
		efficiency -= (TURBINE_PERFECT_RPM - rpm) * 0.0003
	efficiency = max(0.23, efficiency)

/obj/machinery/atmospherics/binary/turbinestage/proc/calculate_vibration(var/datum/gas_mixture/turbine_internals)
	var/tvibration = 0
	if(turbine_internals.temperature < 409) //condensing inside of the turbine is incredibly dangerous
		tvibration += total_mass_flow * 0.04
	if(total_mass_flow > 1000 && rpm < 50) //that implies sudden increase in load on the generator and subsequent turbine stall
		tvibration += total_mass_flow * 0.06
	if(braking && total_mass_flow > 100) //hellish braking means hellish vibrations
		tvibration += 20
	if(rpm > TURBINE_ABNORMAL_RPM) //я твоя турбина вал шатал
		tvibration += (rpm - TURBINE_ABNORMAL_RPM)*0.1
	tvibration += total_mass_flow * 0.005
	vibration = Interpolate(vibration, tvibration, 0.1)

/obj/machinery/atmospherics/binary/turbinestage/proc/apply_vibration_effects()
	switch(vibration)
		if(26 to 50)
			for(var/mob/living/carbon/human/H in range(world.view, loc))
				to_chat(H, SPAN_WARNING("All your surroundings vibrate like in an earthquake!"))
			rotor_integrity = max(0, rotor_integrity - 0.1)
		if(51 to INFINITY)
			for(var/mob/living/carbon/human/H in range(world.view, loc))
				to_chat(H, SPAN_DANGER("Everything around you shakes and rattles!"))
			rotor_integrity = max(0, rotor_integrity - 0.5)
			shaft_integrity = max(0, shaft_integrity - 0.1)

/obj/machinery/power/generator/turbine_generator
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
	var/voltage = 35200 //4400x8

/obj/machinery/power/generator/turbine_generator/Initialize()
	. = ..()
	updateConnection()
	connect_to_network()
	reactor_components[uid] = src

/obj/machinery/power/generator/turbine_generator/proc/updateConnection()
	turbine = null
	if(src.loc && anchored)
		turbine = locate(/obj/machinery/atmospherics/binary/turbinestage) in get_step(src,dir)
		if (turbine.stat & (BROKEN) || !turbine.anchored || turn(turbine.dir,180) != dir)
			turbine = null

/obj/machinery/power/generator/turbine_generator/Process()
	if(!turbine)
		updateConnection()

/obj/machinery/power/generator/turbine_generator/available_power()
	if(turbine && connected)
		return turbine.kin_energy * (turbine.shaft_integrity * 0.01)
	else
		return 0

/obj/machinery/power/generator/turbine_generator/get_voltage()
	return voltage

/obj/machinery/power/generator/turbine_generator/on_power_drain(w)
	if(turbine)
		turbine.kin_energy -= w //i trust the power controller to not draw more than what's available
		last_load = w

/datum/composite_sound/turbine
	start_sound = 'sound/machines/turbine_start.ogg'
	start_length = 155
	mid_sounds = list('sound/machines/turbine_mid.ogg'=1)
	mid_length = 180
	end_sound = 'sound/machines/turbine_end.ogg'
	volume = 300
	sfalloff = 3

/obj/structure/turbine_visual
	name = "steam turbine"
	desc = "A gas turbine. Converting pressure into energy since 1884."
	icon = 'icons/obj/machines/power/turbine.dmi'
	icon_state = "off"
	layer = ABOVE_OBJ_LAYER
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	anchored = 1
	level = 2
	density = 1
	pixel_x = -32
	pixel_y = -64
	bound_x = -32
	bound_y = -64
	bound_width = 96
	bound_height = 192
	var/datum/composite_sound/turbine/soundloop
	var/obj/machinery/atmospherics/binary/turbinestage/turbine_stage

/obj/structure/turbine_visual/Initialize()
	. = ..()
	turbine_stage = locate(/obj/machinery/atmospherics/binary/turbinestage) in get_turf(loc)
	turbine_stage.visual = src

/obj/structure/turbine_visual/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/crowbar/brace_jack) && turbine_stage.braking)
		visible_message(SPAN_NOTICE("[user] starts resetting the emergency brakes on \the [src]."))
		if(!do_after(user, 5 SECONDS, src))
			visible_message(SPAN_WARNING("[user] fails to reset the emergency brakes!"))
			return
		visible_message(SPAN_NOTICE("[user] resets the emergency brakes on \the [src]."))
		turbine_stage.braking = FALSE
	. = ..()

/obj/structure/turbine_visual/proc/spool_up()
	soundloop = new(list(src, GET_ABOVE(src.loc)), TRUE)

/obj/structure/turbine_visual/proc/spool_down()
	QDEL_NULL(soundloop)