/obj/machinery/atmospherics/binary/pump/adv
	icon = 'icons/obj/atmospherics/components/binary/pump.dmi'
	icon_state = "map_off"
	level = 1

	name = "advanced rotary pump"
	desc = "A special pump designed to pump fluids. Works poorly with gases."

	use_power = POWER_USE_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 30000
	identifier = "AFP"

	var/flow_capacity = 600 //kg/s

/obj/machinery/atmospherics/binary/pump/adv/Process()
	last_power_draw = 0
	last_flow_rate = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/power_draw = -1
	var/air1_mass = air1.get_mass()
	var/mass_transfer = max(air1_mass, flow_capacity)

	power_draw = pump_fluid(src, air1, air2, mass_transfer, flow_capacity, power_rating)

	if(mass_transfer > 0)
		update_networks()

	if(power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

	return 1