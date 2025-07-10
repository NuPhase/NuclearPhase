#define REACTOR_PUMP_MODE_OFF 		"OFF"
#define REACTOR_PUMP_MODE_IDLE 		"IDLE"
#define REACTOR_PUMP_MODE_MAX 		"MAX"

#define REACTOR_PUMP_RPM_SAFE 2600
#define REACTOR_PUMP_RPM_MAX  3100

/obj/machinery/atmospherics/binary/pump/adv
	icon = 'icons/obj/atmospherics/components/binary/pump.dmi'
	icon_state = "map_off"
	level = 2

	name = "small rotary pump"
	desc = "A small pump designed to pump fluids. Works poorly with gases. Rated for 5MPa."

	use_power = POWER_USE_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 50000
	power_channel = EQUIP
	identifier = "AFP"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL|CONNECT_TYPE_WATER

	var/flow_capacity = 30 //kg/s
	var/initial_flow_capacity = 0
	var/last_mass_flow = 0
	var/mode = REACTOR_PUMP_MODE_OFF
	var/rpm = 0
	var/target_rpm = 0
	var/max_pressure = 5000
	var/start_speed_coeff = 0.8

	var/map_on = FALSE // Should this pump start itself on roundstart?

	var/sound_id
	var/playing_sound = FALSE
	var/datum/sound_token/sound_token
	var/start_sound = null
	var/start_length = 0
	var/running_sound = 'sound/machines/small_pump_loop.wav'
	var/running_length = 49
	var/sound_volume = 40 // at max flow

	var/initial_volume = 200

/obj/machinery/atmospherics/binary/pump/adv/on
	icon_state = "map_on"
	map_on = TRUE

/obj/machinery/atmospherics/binary/pump/adv/medium
	name = "rotodynamic pump"
	desc = "A medium pump designed to pump fluids. Works poorly with gases. Rated for 15MPa."
	flow_capacity = 100
	max_pressure = 15000
	start_speed_coeff = 0.4
	power_rating = 500000
	running_sound = 'sound/machines/pumploop.ogg'
	running_length = 41
	sound_volume = 60

/obj/machinery/atmospherics/binary/pump/adv/medium/on
	icon_state = "map_on"
	map_on = TRUE

/obj/machinery/atmospherics/binary/pump/adv/large
	name = "multistage centrifugal pump"
	desc = "A complex, large pump designed to pump fluids. Works poorly with gases. Rated for 40MPa, can easily overpressure a line without a relief valve."
	flow_capacity = 300
	max_pressure = 40000
	start_speed_coeff = 0.15
	power_rating = 1500000
	start_sound = 'sound/machines/pumpstart.ogg'
	start_length = 460
	running_sound = 'sound/machines/pumprunning.ogg'
	running_length = 75
	sound_volume = 80

/obj/machinery/atmospherics/binary/pump/adv/large/on
	icon_state = "map_on"
	map_on = TRUE

/obj/machinery/atmospherics/binary/pump/adv/turbineloop
	name = "feedwater pump"
	flow_capacity = 1500 //kgs
	power_rating = 15000000
	start_sound = 'sound/machines/pumpstart.ogg'
	start_length = 460
	running_sound = 'sound/machines/pumprunning.ogg'
	running_length = 75
	start_speed_coeff = 0.1
	sound_volume = 100

/obj/machinery/atmospherics/binary/pump/adv/reactorloop
	name = "molten metal pump"
	desc = "Pumping high density and temperature fluids is hard and tricky, not mentioning the power cost. This pump is a monster."
	//icon = 'icons/obj/atmospherics/components/binary/moltenpump.dmi'
	level = 2
	//layer = STRUCTURE_LAYER
	//icon_state = "off"
	flow_capacity = 1200 //kgs
	power_rating = 15000000
	start_sound = 'sound/machines/pumpstart.ogg'
	start_length = 460
	running_sound = 'sound/machines/pumprunning.ogg'
	running_length = 75
	start_speed_coeff = 0.1
	sound_volume = 80

/obj/machinery/atmospherics/binary/pump/adv/on_update_icon()
	if(stat & NOPOWER)
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"

/obj/machinery/atmospherics/binary/pump/adv/proc/update_mode(new_mode)
	if(mode == new_mode)
		return
	switch(new_mode)
		if(REACTOR_PUMP_MODE_OFF)
			target_rpm = 0
			QDEL_NULL(sound_token)
			air1.suction_moles = 0
		if(REACTOR_PUMP_MODE_IDLE)
			target_rpm = REACTOR_PUMP_RPM_SAFE * 0.3
		if(REACTOR_PUMP_MODE_MAX)
			target_rpm = REACTOR_PUMP_RPM_SAFE
	mode = new_mode

/obj/machinery/atmospherics/binary/pump/adv/proc/change_volume(new_volume, change_input = TRUE, change_output = TRUE)
	if(change_input)
		air1.volume = new_volume
	if(change_output)
		air2.volume = new_volume

/obj/machinery/atmospherics/binary/pump/adv/Initialize()
	. = ..()
	sound_id = "[/obj/machinery/atmospherics/binary/pump/adv]_[sequential_id(/obj/machinery/atmospherics/binary/pump/adv)]"
	if(uid)
		rcontrol.reactor_pumps[uid] = src
	initial_flow_capacity = flow_capacity
	initial_volume = initial_flow_capacity + ATMOS_DEFAULT_VOLUME_PUMP
	change_volume(initial_volume)
	if(map_on)
		update_mode(REACTOR_PUMP_MODE_MAX)
		use_power = POWER_USE_IDLE
		playing_sound = TRUE
		sound_token = play_looping_sound(src, sound_id, running_sound, 80, 10, 3)

/obj/machinery/atmospherics/binary/pump/adv/Destroy()
	. = ..()
	QDEL_NULL(sound_token)

/obj/machinery/atmospherics/binary/pump/adv/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open)
	tgui_interact(user)

/obj/machinery/atmospherics/binary/pump/adv/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FluidPump", "Pump Control")
		ui.open()
		ui.set_autoupdate(1)

/obj/machinery/atmospherics/binary/pump/adv/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(action == "mode_change")
		update_mode(params["mode_change"])

/obj/machinery/atmospherics/binary/pump/adv/tgui_data(mob/user)
	return list(
		"flow_capacity" = initial_flow_capacity,
		"actual_mass_flow" = last_mass_flow,
		"mode" = mode,
		"target_rpm" = target_rpm,
		"actual_rpm" = rpm,
		"power_draw" = last_power_draw,
		"max_power_draw" = power_rating,
		"inlet_pressure" = air1.return_pressure(),
		"exit_pressure" = air2.return_pressure(),
		"temperature" = (air1.temperature + max(TCMB, air2.temperature))/2
	)

/obj/machinery/atmospherics/binary/pump/adv/Process()
	build_network()
	last_power_draw = 0
	last_mass_flow = 0

	if(powered(EQUIP))
		rpm = round(Interpolate(rpm, target_rpm, start_speed_coeff))
	else
		rpm = round(Interpolate(rpm, 0, 0.2))

	if(!rpm)
		QDEL_NULL(sound_token)
		icon_state = "map_off"
		playing_sound = FALSE
		air1.suction_moles = 0
		change_volume(initial_volume)
		return
	else if(!playing_sound)
		playing_sound = TRUE
		if(start_sound)
			playsound(src, start_sound, 80, 0, 7)
		spawn(start_length)
			sound_token = play_looping_sound(src, sound_id, running_sound, sound_volume, 10, 5)
		icon_state = "on"

	flow_capacity = initial_flow_capacity * (rpm / REACTOR_PUMP_RPM_SAFE)

	var/power_draw = -1
	var/air1_mass = air1.get_mass()
	var/mass_transfer = min(air1_mass, flow_capacity)

	// Emulate vacuum suction
	var/deficit = flow_capacity - air1_mass
	if(deficit > 0)
		var/molar_mass = air1.specific_mass()
		if(!molar_mass)
			molar_mass = 0.06
		air1.suction_moles = deficit / molar_mass

	power_draw = pump_fluid(src, air1, air2, mass_transfer, flow_capacity, power_rating)
	last_mass_flow = min(air1_mass, flow_capacity)

	var/flow_coefficient = last_mass_flow / initial_flow_capacity

	change_volume(max(initial_volume, initial_volume * (flow_coefficient * 3)), FALSE, TRUE)
	if(sound_token)
		sound_token.SetVolume(max(sound_volume * 0.1, sound_volume * flow_coefficient))

	update_networks()

	if(power_draw >= 0)
		last_power_draw = power_draw
		change_power_consumption(power_draw, POWER_USE_IDLE)
	else
		change_power_consumption(0, POWER_USE_OFF)

	return 1