#define REACTOR_PUMP_MODE_OFF 		"OFF"
#define REACTOR_PUMP_MODE_IDLE 		"IDLE"
#define REACTOR_PUMP_MODE_MAX 		"MAX"

#define REACTOR_PUMP_RPM_SAFE 2600
#define REACTOR_PUMP_RPM_MAX  3100

/obj/machinery/atmospherics/binary/pump/adv
	icon = 'icons/obj/atmospherics/components/binary/pump.dmi'
	icon_state = "map_off"
	level = 2

	name = "advanced rotary pump"
	desc = "A special pump designed to pump fluids. Works poorly with gases."

	use_power = POWER_USE_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 30000
	power_channel = EQUIP
	identifier = "AFP"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL|CONNECT_TYPE_WATER

	var/flow_capacity = 600 //kg/s
	var/initial_flow_capacity = 0
	var/last_mass_flow = 0
	var/mode = REACTOR_PUMP_MODE_OFF
	var/rpm = 0
	var/target_rpm = 0

	var/sound_id
	var/playing_sound = FALSE
	var/datum/sound_token/sound_token
	var/start_sound = null
	var/start_length = 0
	var/running_sound = 'sound/machines/small_pump_loop.wav'
	var/running_length = 49

/obj/machinery/atmospherics/binary/pump/adv/on
	icon_state = "map_on"

/obj/machinery/atmospherics/binary/pump/adv/on/Initialize()
	. = ..()
	mode = REACTOR_PUMP_MODE_IDLE
	target_rpm = REACTOR_PUMP_RPM_SAFE
	rpm = REACTOR_PUMP_RPM_SAFE
	use_power = POWER_USE_IDLE
	playing_sound = TRUE
	sound_token = play_looping_sound(src, sound_id, running_sound, 80, 10, 3)

/obj/machinery/atmospherics/binary/pump/adv/turbineloop
	name = "feedwater pump"
	flow_capacity = 1500 //kgs
	power_rating = 140000 //fucking chonker
	start_sound = 'sound/machines/pumpstart.ogg'
	start_length = 470
	running_sound = 'sound/machines/pumprunning.ogg'
	running_length = 75

/obj/machinery/atmospherics/binary/pump/adv/reactorloop
	name = "molten metal pump"
	desc = "Pumping high density and temperature fluids is hard and tricky, not mentioning the power cost. This pump is a monster."
	//icon = 'icons/obj/atmospherics/components/binary/moltenpump.dmi'
	level = 2
	//layer = STRUCTURE_LAYER
	//icon_state = "off"
	flow_capacity = 300 //kgs
	power_rating = 210000 //molten metals take a lot of energy to move
	start_sound = 'sound/machines/pumpstart.ogg'
	start_length = 470
	running_sound = 'sound/machines/pumprunning.ogg'
	running_length = 75

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
		if(REACTOR_PUMP_MODE_IDLE)
			target_rpm = REACTOR_PUMP_RPM_SAFE * 0.5
		if(REACTOR_PUMP_MODE_MAX)
			target_rpm = REACTOR_PUMP_RPM_SAFE
	mode = new_mode

/obj/machinery/atmospherics/binary/pump/adv/Initialize()
	. = ..()
	sound_id = "[/obj/machinery/atmospherics/binary/pump/adv]_[sequential_id(/obj/machinery/atmospherics/binary/pump/adv)]"
	if(uid)
		rcontrol.reactor_pumps[uid] = src
	initial_flow_capacity = flow_capacity
	air1.volume = initial_flow_capacity * 40
	air2.volume = initial_flow_capacity * 10

/obj/machinery/atmospherics/binary/pump/adv/Destroy()
	. = ..()
	QDEL_NULL(sound_token)

/obj/machinery/atmospherics/binary/pump/adv/Process()
	build_network()
	last_power_draw = 0

	if(powered(EQUIP))
		rpm = round(Interpolate(rpm, target_rpm, 0.1))
	else
		rpm = round(Interpolate(rpm, 0, 0.15))

	if(!rpm)
		QDEL_NULL(sound_token)
		icon_state = "map_off"
		playing_sound = FALSE
		return
	else if(!playing_sound)
		playing_sound = TRUE
		if(start_sound)
			playsound(src, start_sound, 100, 0, 7)
		spawn(start_length)
			sound_token = play_looping_sound(src, sound_id, running_sound, 80, 10, 5)
		icon_state = "on"

	flow_capacity = initial_flow_capacity * (rpm / REACTOR_PUMP_RPM_SAFE)

	var/power_draw = -1
	var/air1_mass = air1.get_mass()
	var/mass_transfer = max(air1_mass, flow_capacity)

	power_draw = pump_fluid(src, air1, air2, mass_transfer, flow_capacity, power_rating)
	last_mass_flow = min(air1_mass, flow_capacity)

	update_networks()

	if(power_draw >= 0)
		last_power_draw = power_draw
		change_power_consumption(power_draw, POWER_USE_IDLE)
	else
		change_power_consumption(0, POWER_USE_OFF)

	return 1

/obj/machinery/atmospherics/binary/pump/adv/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open)
	return