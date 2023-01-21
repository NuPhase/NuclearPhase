/obj/machinery/atmospherics/binary/pump/adv
	icon = 'icons/obj/atmospherics/components/binary/pump.dmi'
	icon_state = "map_off"
	level = 1

	name = "advanced rotary pump"
	desc = "A special pump designed to pump fluids. Works poorly with gases."

	target_pressure = MAX_PUMP_PRESSURE

	//var/max_volume_transfer = 10000

	use_power = POWER_USE_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 70000			// 30000 W ~ 40 HP
	identifier = "AFP"

	max_pressure_setting = MAX_PUMP_PRESSURE

/obj/machinery/atmospherics/binary/pump/adv/Process()
	last_power_draw = 0
	last_flow_rate = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/power_draw = -1
	var/pressure_delta = target_pressure - air2.return_pressure()

	if(pressure_delta > 0.01 && air1.temperature > 0)
		//Figure out how much gas to transfer to meet the target pressure.
		var/datum/pipe_network/output = network_in_dir(dir)
		var/transfer_moles = calculate_transfer_moles(air1, air2, pressure_delta, output?.volume)
		power_draw = pump_fluid(src, air1, air2, transfer_moles, power_rating)

		if(transfer_moles > 0)
			update_networks()

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

	return 1