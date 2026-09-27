#define MAX_COIL_CHARGE 1000000000
#define MAX_COIL_TEMP 95
#define MAX_VOLTAGE 200000
#define MIN_VOLTAGE 180000
#define INTERNAL_HEAT_CAPACITY 1000000

/obj/machinery/multitile/particle_accelerator
	name = "particle accelerator"
	icon = 'icons/obj/atmospherics/multiport/particle_accelerator.dmi'

	map_port_volume = 500

	width = 4
	height = 4
	bound_width = 160
	bound_height = 160

	map_ports = list(
		list(0, 0, WEST, "Coolant In"),
		list(4, 0, EAST, "Coolant Out")
	)
	spawn_power_terminal = TRUE

	var/coil_temperature = T20C
	var/coil_charge = 0

	var/moderation = 0

	var/exposure_ticks = 10

	var/obj/item/contained

/obj/machinery/multitile/particle_accelerator/get_mechanics_info()
	return "Needs to be cooled to below 95K to function."

/obj/machinery/multitile/particle_accelerator/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("It's charged to [round(coil_charge/1000000)]MJ."))
	to_chat(user, SPAN_NOTICE("Its temperature is [round(coil_temperature, 0.1)]K."))
	if(!power_port.powernet || !power_port.powernet.max_power)
		return
	if(power_port.powernet.voltage < MIN_VOLTAGE)
		to_chat(user, SPAN_WARNING("It receives too little voltage."))
	else if(power_port.powernet.voltage > MAX_VOLTAGE)
		to_chat(user, SPAN_WARNING("It receives too much voltage."))

/obj/machinery/multitile/particle_accelerator/proc/fire()
	if(!contained)
		return
	var/neutron_moles = coil_charge / 68900000
	var/datum/gas_mixture/gasmix = new(0.01, 80)

	if(istype(contained, /obj/item/tank))
		var/obj/item/tank/cur_tank = contained
		gasmix.merge(cur_tank.air_contents.remove_ratio(1))
	else if(contained.reagents)
		for(var/rtype in contained.reagents.reagent_volumes)
			var/decl/material/mat = GET_DECL(rtype)
			gasmix.adjust_gas(rtype, contained.reagents.reagent_volumes[rtype] / mat.molar_volume, FALSE)
		contained.reagents.clear_reagents()
	else
		return

	var/fast_neutrons = neutron_moles * (1 - moderation)
	var/slow_neutrons = neutron_moles * moderation

	var/lost_neutrons = 0

	for(var/index = 1 to exposure_ticks)
		var/list/returned_list = gasmix.handle_nuclear_reactions(slow_neutrons, fast_neutrons, FALSE)
		slow_neutrons = max(returned_list["slow_neutrons_changed"], 0)
		fast_neutrons = max(returned_list["fast_neutrons_changed"], 0)
		lost_neutrons += fast_neutrons * 0.01
		lost_neutrons += slow_neutrons * 0.01
		fast_neutrons *= 0.99
		slow_neutrons *= 0.99

	var/end_neutrons = fast_neutrons + slow_neutrons + lost_neutrons
	SSradiation.radiate(src, end_neutrons * 68900000)
	playsound(src, 'sound/effects/bangtaper.ogg', 50, 0)
	coil_charge = 0

	if(istype(contained, /obj/item/tank))
		var/obj/item/tank/cur_tank = contained
		cur_tank.air_contents.merge(gasmix.remove_ratio(1), FALSE)
		cur_tank.air_contents.temperature = T0C
		cur_tank.air_contents.update_values()
	else if(contained.reagents)
		var/alist/all_fluid = gasmix.get_fluid()
		for(var/mtype, amt in all_fluid)
			var/decl/material/mat = GET_DECL(mtype)
			contained.reagents.add_reagent(mtype, amt * mat.molar_volume)

/obj/machinery/multitile/particle_accelerator/Process()
	if(coil_charge && coil_temperature > MAX_COIL_TEMP)
		quench()
		return
	handle_charging()
	handle_temploss()
	handle_cooling()

/obj/machinery/multitile/particle_accelerator/proc/quench()
	coil_temperature += coil_charge / INTERNAL_HEAT_CAPACITY
	coil_charge = 0
	playsound(src, 'sound/effects/bangtaper.ogg', 50, 0)
	if(!power_port.powernet)
		return
	var/obj/machinery/power/generator/transformer/switchable/supply_trans
	for(var/obj/machinery/power/generator/transformer/ctr in power_port.powernet.nodes)
		if(!ctr.connected)
			continue
		supply_trans = ctr.connected
		break
	supply_trans.trip()

/obj/machinery/multitile/particle_accelerator/proc/handle_temploss()
	var/turf/T = get_turf(src)
	var/datum/gas_mixture/environment = T.return_air()
	if(coil_temperature < environment.temperature)
		coil_temperature += 0.05

/obj/machinery/multitile/particle_accelerator/proc/handle_charging()
	if(coil_charge == MAX_COIL_CHARGE)
		return
	if(!power_port.powernet)
		return
	var/datum/powernet/powernet = power_port.powernet
	if(powernet.voltage < MIN_VOLTAGE || powernet.voltage > MAX_VOLTAGE)
		return

	var/available_power = powernet.max_power
	if(!available_power)
		return
	powernet.draw_power(available_power)

	coil_charge = min(MAX_COIL_CHARGE, coil_charge + (available_power*0.99))
	coil_temperature += (available_power * 0.01) / INTERNAL_HEAT_CAPACITY

/obj/machinery/multitile/particle_accelerator/proc/handle_cooling()
	var/datum/gas_mixture/c_inlet = port_gases["Coolant In"]
	var/datum/gas_mixture/c_outlet = port_gases["Coolant Out"]
	if(!c_inlet.total_moles)
		return
	if(c_inlet.temperature > coil_temperature)
		return
	var/coolant_spec_heat = c_inlet.heat_capacity / c_inlet.total_moles
	var/t_diff = coil_temperature - c_inlet.temperature
	var/required_energy = t_diff * INTERNAL_HEAT_CAPACITY
	var/available_energy = t_diff * c_inlet.heat_capacity
	var/energy_transfer = min(required_energy, available_energy)
	var/datum/gas_mixture/transf = c_inlet.remove(energy_transfer / coolant_spec_heat)
	transf.add_thermal_energy(energy_transfer)
	c_outlet.merge(transf)
	coil_temperature -= energy_transfer / INTERNAL_HEAT_CAPACITY

/obj/machinery/multitile/particle_accelerator/attackby(obj/item/I, mob/user)
	if((. = ..()))
		return
	if(contained)
		return
	contained = I
	user.drop_from_inventory(I, src)

/obj/machinery/multitile/particle_accelerator/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/particle_accelerator_remove_item)
	LAZYADD(., /decl/interaction_handler/particle_accelerator_start)

/decl/interaction_handler/particle_accelerator_start
	name = "Start"
	expected_target_type = /obj/machinery/multitile/particle_accelerator

/decl/interaction_handler/particle_accelerator_start/invoked(obj/machinery/multitile/particle_accelerator/target, mob/user)
	if(!do_after(user, 5, target))
		return
	if(!target.coil_charge || !target.contained)
		return
	playsound(target, 'sound/effects/Evacuation.ogg', 50, 0)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/obj/machinery/multitile/particle_accelerator, fire)), 13 SECONDS)

/decl/interaction_handler/particle_accelerator_remove_item
	name = "Remove Item"
	expected_target_type = /obj/machinery/multitile/particle_accelerator

/decl/interaction_handler/particle_accelerator_remove_item/invoked(obj/machinery/multitile/particle_accelerator/target, mob/user)
	if(!target.contained)
		return
	user.put_in_hands(target.contained)
	target.contained = null

#undef MAX_COIL_CHARGE
#undef MAX_COIL_TEMP
#undef MAX_VOLTAGE
#undef MIN_VOLTAGE
#undef INTERNAL_HEAT_CAPACITY