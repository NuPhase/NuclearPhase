/obj/machinery/atmospherics/binary/turbine
	name = "turbine"
	desc = "A gas turbine. Converting pressure into energy since 1884."
	icon = 'icons/obj/machines/power/turbine.dmi'
	icon_state = "off"
	layer = STRUCTURE_LAYER
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	level = 1
	density = 1
	//bound_x = 96
	//bound_y = 192

	use_power = POWER_USE_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 30000			// 30000 W ~ 40 HP
	identifier = "TURBINE0"

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/noninteractive

	var/efficiency = 0.4
	var/kin_energy = 0
	var/volume_ratio = 0.5 //AKA expansion ratio. Higher means less steam is used, but results in better overall efficiency.
	var/kin_loss = 0.001

	var/dP = 0

/obj/machinery/atmospherics/binary/turbine/hide(var/i)
	return

/obj/machinery/atmospherics/binary/turbine/Process()
	if(anchored)
		kin_energy *= 1 - kin_loss
		dP = max(air1.return_pressure() - air2.return_pressure(), 0)
		if(dP > 10)
			kin_energy += 1/ADIABATIC_EXPONENT * dP * air1.volume * (1 - volume_ratio**ADIABATIC_EXPONENT) * efficiency
			air1.temperature *= volume_ratio**ADIABATIC_EXPONENT

			var/datum/gas_mixture/air_all = new
			air_all.volume = air1.volume + air2.volume
			air_all.merge(air1.remove_ratio(1))
			air_all.merge(air2.remove_ratio(1))

			air1.merge(air_all.remove(volume_ratio))
			air2.merge(air_all)

		update_icon()
		update_networks()

/obj/machinery/atmospherics/binary/turbine/return_air()
	if(air1.return_pressure() > air2.return_pressure())
		return air1
	else
		return air2

/obj/machinery/turbinegen
	name = "motor"
	desc = "Electrogenerator. Converts rotation into power."
	icon = 'icons/obj/atmospherics/components/unary/pipeturbine.dmi'
	icon_state = "motor"
	anchored = 0
	density = 1
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE

	var/kin_to_el_ratio = 0.1	//How much kinetic energy will be taken from turbine and converted into electricity
	var/obj/machinery/atmospherics/binary/turbine/turbine

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/noninteractive

/obj/machinery/turbinegen/Initialize()
	. = ..()
	updateConnection()

/obj/machinery/turbinegen/proc/updateConnection()
	turbine = null
	if(src.loc && anchored)
		turbine = locate(/obj/machinery/atmospherics/binary/turbine) in get_step(src,dir)
		if (turbine.stat & (BROKEN) || !turbine.anchored || turn(turbine.dir,180) != dir)
			turbine = null

/obj/machinery/turbinegen/wrench_floor_bolts(user)
	. = ..()
	updateConnection()

/obj/machinery/turbinegen/Process()
	updateConnection()
	if(!turbine || !anchored || stat & (BROKEN))
		return

	var/power_generated = kin_to_el_ratio * turbine.kin_energy
	turbine.kin_energy -= power_generated
	generate_power(power_generated)

/obj/machinery/advturbine_computer
	name = "Steam turbine control computer"
	desc = "A computer to remotely control a steam turbine."
	icon = 'icons/obj/modular_computers/modular_laptop.dmi'
	icon_state = "laptop-open"
	layer = STRUCTURE_LAYER
	anchored = 1
	density = 1