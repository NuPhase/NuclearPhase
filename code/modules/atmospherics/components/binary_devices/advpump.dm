#define REACTOR_PUMP_MODE_OFF 		"OFF"
#define REACTOR_PUMP_MODE_IDLE 		"IDLE"
#define REACTOR_PUMP_MODE_THROTTLE  "THROTTLE" //the pump throttles to conserve energy
#define REACTOR_PUMP_MODE_MAX 		"MAX"

#define REACTOR_PUMP_RPM_SAFE 2600
#define REACTOR_PUMP_RPM_MAX  3100

/datum/composite_sound/pump
	mid_sounds = list('sound/machines/pumploop.ogg'=1)
	mid_length = 40
	volume = 15

/obj/machinery/atmospherics/binary/pump/adv
	icon = 'icons/obj/atmospherics/components/binary/pump.dmi'
	icon_state = "map_off"
	level = 1

	name = "advanced rotary pump"
	desc = "A special pump designed to pump fluids. Works poorly with gases."

	use_power = POWER_USE_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 30000
	power_channel = EQUIP
	identifier = "AFP"

	var/flow_capacity = 600 //kg/s
	var/initial_flow_capacity = 0
	var/last_mass_flow = 0
	var/mode = REACTOR_PUMP_MODE_OFF
	var/rpm = 0

	var/datum/composite_sound/pump/soundloop

/obj/machinery/atmospherics/binary/pump/adv/on
	icon_state = "on"

/obj/machinery/atmospherics/binary/pump/adv/on/Initialize()
	. = ..()
	mode = REACTOR_PUMP_MODE_IDLE
	rpm = REACTOR_PUMP_RPM_SAFE
	use_power = POWER_USE_IDLE
	soundloop = new(list(src), TRUE)

/obj/machinery/atmospherics/binary/pump/adv/turbineloop
	name = "feedwater pump"
	flow_capacity = 1500 //kgs
	power_rating = 600000 //fucking chonker

/obj/machinery/atmospherics/binary/pump/adv/reactorloop
	name = "molten metal pump"
	desc = "Pumping high density and temperature fluids is hard and tricky, not mentioning the power cost. This pump is a monster."
	icon = 'icons/obj/atmospherics/components/binary/moltenpump.dmi'
	level = 2
	layer = STRUCTURE_LAYER
	icon_state = "off"
	flow_capacity = 300 //kgs
	power_rating = 210000 //molten metals take a lot of energy to move
	pixel_x = -32
	pixel_y = -32
	//bound_x = -32
	//bound_y = -32
	//bound_width = 96
	//bound_height = 64

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
			spool_down()
		if(REACTOR_PUMP_MODE_IDLE)
			spool_up()
	mode = new_mode

/obj/machinery/atmospherics/binary/pump/adv/proc/spool_up()
	icon_state = "on"
	use_power = POWER_USE_IDLE
	soundloop = new(list(src), TRUE)
	while(rpm < REACTOR_PUMP_RPM_SAFE)
		rpm += rand(50, 100)
		sleep(5)

/obj/machinery/atmospherics/binary/pump/adv/proc/spool_down()
	while(rpm)
		rpm = max(rpm - rand(10, 50), 0)
		sleep(5)
	QDEL_NULL(soundloop)
	icon_state = "map_off"
	use_power = POWER_USE_OFF

/obj/machinery/atmospherics/binary/pump/adv/Initialize()
	. = ..()
	if(uid)
		rcontrol.reactor_pumps[uid] = src
	initial_flow_capacity = flow_capacity
	air1.volume = initial_flow_capacity * 20
	air2.volume = initial_flow_capacity * 20

/obj/machinery/atmospherics/binary/pump/adv/Destroy()
	. = ..()
	QDEL_NULL(soundloop)

/obj/machinery/atmospherics/binary/pump/adv/Process()
	last_power_draw = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	flow_capacity = initial_flow_capacity * (rpm / REACTOR_PUMP_RPM_SAFE)

	var/power_draw = -1
	var/air1_mass = air1.get_mass()
	var/mass_transfer = max(air1_mass, flow_capacity)

	power_draw = pump_fluid(src, air1, air2, mass_transfer, flow_capacity, power_rating)
	last_mass_flow = min(air1_mass, flow_capacity)

	if(mass_transfer > 0)
		update_networks()

	if(power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

	return 1

/obj/machinery/atmospherics/binary/pump/adv/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open)
	return