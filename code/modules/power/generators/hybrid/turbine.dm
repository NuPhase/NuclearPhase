#define TURBINE_MOMENT_OF_INERTIA 1327000
#define STEAM_SPEED_MODIFIER 1.3
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

	var/feeder_valve_openage = 0
	var/efficiency = 0.93
	var/kin_energy = 0
	var/kin_total = 0 //last kin energy generation
	var/expansion_ratio = 0.87
	var/volume_ratio = 0.2
	var/steam_velocity = 0
	var/pressure_difference = 0
	var/total_mass_flow = 0
	var/rpm = 0
	var/braking = FALSE //emergency brakes
	var/vibration = 0 //0-25 is minor, 25-50 is major, anything above is critical

	var/water_level = 0 //0-1. Condensation inside turbine increases water level
	var/water_grates_open = FALSE

	var/rotor_integrity = 100
	var/shaft_integrity = 100

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
	air1.volume = 30000
	air2.volume = 7500
	reactor_components[uid] = src

/obj/machinery/atmospherics/binary/turbinestage/proc/get_specific_enthalpy(ntemp, npres)
	if(ntemp > 750)
		return 3758119 //PLEASE make an approximation using specific steam tables.
	else
		return 5000

/obj/machinery/atmospherics/binary/turbinestage/Process()
	. = ..()
	update_networks()
	total_mass_flow = (air1.net_flow_mass + air1.get_mass()) * feeder_valve_openage //barely enough to start it

	pressure_difference = max(air1.return_pressure() - air2.return_pressure(), 0) * feeder_valve_openage
	var/pressure_fall_factor = pressure_difference / 20
	steam_velocity = sqrt(2 * pressure_fall_factor * GRAVITY_CONSTANT) * STEAM_SPEED_MODIFIER

	var/datum/gas_mixture/air_all = new
	air_all.volume = air1.volume + air2.volume
	pump_passive(air1, air_all, total_mass_flow)
	var/old_temperature = air_all.temperature
	air_all.temperature = air_all.temperature * volume_ratio ** ADIABATIC_EXPONENT
	if(air_all.temperature > 320 && air_all.temperature < 400)
		if(water_grates_open)
			water_level += 0.01
		else
			water_level += 0.06
	else if(water_grates_open)
		water_level -= 0.05
	water_level = CLAMP01(water_level)
	air_all.temperature = max(air_all.temperature, 360)

	kin_total = get_specific_enthalpy(old_temperature, air1.return_pressure()) * total_mass_flow
	kin_total *= expansion_ratio

	kin_energy += kin_total * efficiency * (rotor_integrity * 0.01)
	rpm = sqrt(2 * kin_energy / TURBINE_MOMENT_OF_INERTIA) * 60 / 6.2831

	calculate_vibration(air_all)
	air2.merge(air_all)

	if(braking)
		var/datum/gas_mixture/environment = loc.return_air()
		kin_energy = max(0, kin_energy * 0.95 - 10000)
		if(kin_energy)
			environment.add_thermal_energy(kin_energy * 0.005 + 10000)

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
	efficiency = 0.23
	if(water_grates_open)
		efficiency -= 0.25
	efficiency -= vibration * 0.005
	efficiency += rpm * 0.00025
	efficiency = Clamp(efficiency, 0.23, initial(efficiency))

/obj/machinery/atmospherics/binary/turbinestage/proc/calculate_vibration(var/datum/gas_mixture/turbine_internals)
	var/tvibration = 0
	//if(turbine_internals.temperature < 409) //condensing inside of the turbine is incredibly dangerous
	//	tvibration += total_mass_flow * 0.04
	if(total_mass_flow > 1000 && rpm < 50) //that implies sudden increase in load on the generator and subsequent turbine stall
		tvibration += total_mass_flow * 0.06
	if(braking && total_mass_flow > 100) //hellish braking means hellish vibrations
		tvibration += 35
	if(rpm > TURBINE_ABNORMAL_RPM) //я твоя турбина вал шатал
		tvibration += (rpm - TURBINE_ABNORMAL_RPM)*0.12
	tvibration += water_level * 0.7
	tvibration += total_mass_flow * 0.005
	vibration = Interpolate(vibration, tvibration, 0.1)

/obj/machinery/atmospherics/binary/turbinestage/proc/apply_vibration_effects()
	switch(vibration)
		if(26 to 51)
			for(var/mob/living/carbon/human/H in range(world.view, loc))
				to_chat(H, SPAN_WARNING("All your surroundings vibrate like in an earthquake!"))
				shake_camera(H, 10, 2)
			rotor_integrity = max(0, rotor_integrity - 0.1)
			if(prob(5))
				playsound(src, 'sound/machines/vibrations.wav', 100, 0)
		if(51 to INFINITY)
			for(var/mob/living/carbon/human/H in human_mob_list)
				if(get_dist(H.loc, loc) < 10)
					to_chat(H, SPAN_DANGER("Everything around you shakes and rattles like in a powerful earthquake!"))
					shake_camera(H, 10, 6)
				else if(get_dist(H.loc, loc) < 50)
					to_chat(H, SPAN_WARNING("Everything around you vibrates and resonates throughout your body, almost like something is tearing itself apart..."))
					shake_camera(H, 10, 2)
			rotor_integrity = max(0, rotor_integrity - 0.5)
			shaft_integrity = max(0, shaft_integrity - 0.1)
			if(prob(5))
				playsound(src, 'sound/machines/vibrations_heavy.wav', 150, 0, 20, zrange = 3)
			if(prob(3))
				var/datum/effect/effect/system/smoke_spread/bad/smoke = new /datum/effect/effect/system/smoke_spread/bad()
				smoke.attach(src)
				smoke.set_up(10, 0, loc)
				smoke.start()

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
	soundloop = new(list(src), TRUE)

/obj/structure/turbine_visual/proc/spool_down()
	QDEL_NULL(soundloop)