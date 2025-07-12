#define TURBINE_MOMENT_OF_INERTIA 1327000
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
	var/expansion_ratio = 0.244755
	var/volume_ratio = 0.2
	var/steam_velocity = 0
	var/pressure_difference = 0
	var/total_mass_flow = 0
	var/rpm = 0
	var/braking = FALSE //emergency brakes
	var/vibration = 0 //0-25 is minor, 25-50 is major, anything above is critical

	//for logging and interfaces
	var/inlet_temperature = T20C
	var/exhaust_temperature = T20C
	var/inlet_pressure = 0
	var/exhaust_pressure = 0
	var/real_expansion = 1 //inlet_pressure / exhaust_pressure
	var/kinetic_energy_delta = 0 // (kin_total - generator.last_load) * 1800

	var/water_level = 0 //0-1. Condensation inside turbine increases water level
	var/water_grates_open = FALSE

	var/rotor_integrity = 100
	var/shaft_integrity = 100

	var/obj/structure/turbine_visual/visual = null
	var/obj/machinery/power/generator/turbine_generator/generator = null

	var/valve_id = ""

	failure_chance = 10

/obj/machinery/atmospherics/binary/turbinestage/proc/get_vibration_flavor()
	switch(vibration)
		if(0 to 25)
			return "low"
		if(26 to 50)
			return "medium"
		if(51 to INFINITY)
			return "high"

/obj/machinery/atmospherics/binary/turbinestage/Initialize()
	. = ..()
	air1.volume = 120000
	air2.volume = 120000
	reactor_components[uid] = src

/obj/machinery/atmospherics/binary/turbinestage/fail_roundstart()
	rotor_integrity = 100 - (SSticker.mode.difficulty / rand(1,3))
	shaft_integrity = 100 - (SSticker.mode.difficulty / 2)

/obj/machinery/atmospherics/binary/turbinestage/proc/get_specific_enthalpy(npres, ntemp)
	if(ntemp > 450)
		return 4127119 //Hooked to steam table API
	return 40000

/obj/machinery/atmospherics/binary/turbinestage/proc/get_density(npres, ntemp)
	return 2.16 //Hooked to steam table API

/obj/machinery/atmospherics/binary/turbinestage/Process()
	. = ..()
	update_networks()

	if(air1.total_moles)
		process_steam()
	else
		total_mass_flow = 0
		steam_velocity = 0
		kin_total = 0

	var/air2_pressure = air2.return_pressure()
	if(air2_pressure)
		real_expansion = air1.return_pressure() / air2_pressure
	else
		real_expansion = air1.return_pressure() / 0.001
	real_expansion = min(real_expansion, expansion_ratio)

	kinetic_energy_delta = kin_total - generator.last_load

	rpm = sqrt(2 * kin_energy / TURBINE_MOMENT_OF_INERTIA) * 60 / 6.2831

	if(braking)
		var/datum/gas_mixture/environment = loc.return_air()
		kin_energy = max(0, kin_energy * 0.95 - 10000)
		if(kin_energy)
			environment.add_thermal_energy(kin_energy * 0.005 + 10000)

	apply_vibration_effects()
	calculate_efficiency()

	if(rpm > 800)
		use_power = POWER_USE_ACTIVE
		if(!visual.sound_token)
			visual.spool_up()
		visual.on_rpm_change(rpm)
	else
		visual.spool_down()
		use_power = POWER_USE_IDLE

/obj/machinery/atmospherics/binary/turbinestage/proc/process_steam()
	var/air1_density = get_density(air1.return_pressure() * 0.001, air1.temperature - 273.15)

	//calculate flow velocity
	// sqrt((2 * (P1 - P2) / rho) + (2 * g * (h1 - h2)))
	if(feeder_valve_openage)
		pressure_difference = max(air1.return_pressure() - air2.return_pressure(), 0)
		steam_velocity = sqrt((2 * pressure_difference / air1_density) + (2 * GRAVITY_CONSTANT))
	else
		steam_velocity = 0

	//calculate flow mass
	//Steam enters at 1.5m diameter, expands to 5.5m. 5.5m diameter > area = 95.03
	total_mass_flow = feeder_valve_openage*95.03*expansion_ratio*0.598*sqrt(steam_velocity * 4.2 * (1-(air2.return_pressure()/air1.return_pressure())**0.23))
	var/mass_difference = total_mass_flow - air1.get_mass()
	if(mass_difference > 0)
		air1.suction_moles = mass_difference / air1.specific_mass()
	else
		air1.suction_moles = 0
	total_mass_flow = min(total_mass_flow, air1.get_mass())

	//create the internal gas mixture and transfer inlet steam to it
	var/datum/gas_mixture/air_all = new(air1.volume * (feeder_valve_openage + 0.05))
	pump_passive(air1, air_all, total_mass_flow)

	//logging
	inlet_temperature = air_all.temperature
	inlet_pressure = air1.return_pressure()

	//get the kinetic energy received from steam and cool it down
	var/end_temperature = max(inlet_temperature * expansion_ratio, 390)
	var/temp_delta = inlet_temperature - end_temperature
	kin_total = (air_all.heat_capacity() * temp_delta) * efficiency
	air_all.temperature = end_temperature

	//logging
	exhaust_temperature = air_all.temperature
	exhaust_pressure = air_all.return_pressure()

	//let water accumulate inside the turbine if the exhaust steam is too cold
	if(air_all.temperature < 340)
		if(water_grates_open)
			water_level += 0.01
		else
			water_level += 0.06
	else if(water_grates_open)
		water_level -= 0.05
	water_level = CLAMP01(water_level)

	kin_energy += kin_total * (rotor_integrity * 0.01)
	calculate_vibration(air_all)
	air2.merge(air_all)

/obj/machinery/atmospherics/binary/turbinestage/proc/calculate_efficiency()
	efficiency = 0.23
	if(water_grates_open)
		efficiency -= 0.25
	efficiency -= vibration * 0.005
	efficiency += rpm * 0.00025
	efficiency = Clamp(efficiency, 0.23, initial(efficiency))

/obj/machinery/atmospherics/binary/turbinestage/proc/calculate_vibration(var/datum/gas_mixture/turbine_internals)
	var/tvibration = 0
	//if(turbine_internals.liquids[/decl/material/liquid/water] > 100) //condensing inside of the turbine is incredibly dangerous
	//	tvibration += total_mass_flow * 0.004 * turbine_internals.liquids[/decl/material/liquid/water]
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
				to_chat(H, SPAN_WARNING("All your surroundings vibrate like in an earthquake..."))
				shake_camera(H, 25, 0.8)
				if(prob(5))
					H.playsound_local(get_turf(src), 'sound/machines/vibrations.wav', 100, 0, extrarange = 30)
			rotor_integrity = max(0, rotor_integrity - 0.1)
		if(51 to INFINITY)
			for(var/mob/living/carbon/human/H in human_mob_list)
				if(get_dist(H.loc, loc) < 10)
					to_chat(H, SPAN_DANGER("Everything around you shakes and rattles like in a powerful earthquake!"))
					shake_camera(H, 25, 1.3)
				else if(get_dist(H.loc, loc) < 50)
					to_chat(H, SPAN_WARNING("Everything around you vibrates and resonates throughout your body, almost like something is tearing itself apart!"))
					shake_camera(H, 25, 0.2)
				if(prob(5))
					H.playsound_local(get_turf(H), 'sound/machines/vibrations_heavy.wav', 100, 0)
			rotor_integrity = max(0, rotor_integrity - 0.5)
			shaft_integrity = max(0, shaft_integrity - 0.1)
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
		turbine.generator = src

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
	var/datum/sound_token/sound_token
	var/sound_id
	var/obj/machinery/atmospherics/binary/turbinestage/turbine_stage

/obj/structure/turbine_visual/Initialize()
	. = ..()
	sound_id = "[/obj/structure/turbine_visual]_[sequential_id(/obj/structure/turbine_visual)]"
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

/obj/structure/turbine_visual/proc/on_rpm_change(new_rpm)
	if(sound_token)
		sound_token.SetVolume((new_rpm / TURBINE_ABNORMAL_RPM) * 150)

/obj/structure/turbine_visual/proc/spool_up()
	sound_token = play_looping_sound(src, sound_id, 'sound/machines/turbine_mid.ogg', 30, 15, 7)

/obj/structure/turbine_visual/proc/spool_down()
	QDEL_NULL(sound_token)