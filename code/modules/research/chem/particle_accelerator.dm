/obj/machinery/linear_accelerator
	name = "linear particle accelerator"
	desc = "A very powerful electron gun."
	icon = 'icons/obj/power.dmi'
	icon_state = "potato"
	active_power_usage = 150000
	idle_power_usage = 100
	power_channel = EQUIP

	var/max_capacity = 10000000
	var/charge = 0

	var/exposure_ticks = 10

	var/moderation = 0 // 0-1

	var/obj/item/contained

/obj/machinery/linear_accelerator/Process()
	if(!powered(EQUIP))
		return
	if(charge == max_capacity)
		if(use_power == POWER_USE_ACTIVE)
			update_use_power(POWER_USE_ACTIVE)
		return
	if(use_power == POWER_USE_IDLE)
		update_use_power(POWER_USE_ACTIVE)
	charge = min(charge + active_power_usage, max_capacity)

/obj/machinery/linear_accelerator/proc/fire()
	if(!contained)
		return
	var/neutron_moles = charge / 68900000
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
		var/list/returned_list = gasmix.handle_nuclear_reactions(slow_neutrons, fast_neutrons)
		slow_neutrons = max(returned_list["slow_neutrons_changed"], 0)
		fast_neutrons = max(returned_list["fast_neutrons_changed"], 0)
		lost_neutrons += fast_neutrons * 0.01
		lost_neutrons += slow_neutrons * 0.01
		fast_neutrons *= 0.99
		slow_neutrons *= 0.99

	var/end_neutrons = fast_neutrons + slow_neutrons + lost_neutrons
	SSradiation.radiate(src, end_neutrons * 68900000)
	playsound(src, 'sound/effects/bangtaper.ogg', 50, 0)
	charge = 0

	if(istype(contained, /obj/item/tank))
		var/obj/item/tank/cur_tank = contained
		cur_tank.air_contents.merge(gasmix.remove_ratio(1), FALSE)
		cur_tank.air_contents.temperature = T0C
		cur_tank.air_contents.update_values()
	else if(contained.reagents)
		var/list/all_fluid = gasmix.get_fluid()
		for(var/mtype in all_fluid)
			var/decl/material/mat = GET_DECL(mtype)
			contained.reagents.add_reagent(mtype, all_fluid[mtype] * mat.molar_volume)

/obj/machinery/linear_accelerator/attackby(obj/item/I, mob/user)
	if(contained)
		return
	contained = I
	user.drop_from_inventory(I, src)
	return
	. = ..()

/obj/machinery/linear_accelerator/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/linear_accelerator_remove_item)
	LAZYADD(., /decl/interaction_handler/linear_accelerator_start)

/decl/interaction_handler/linear_accelerator_start
	name = "Start"
	expected_target_type = /obj/machinery/linear_accelerator

/decl/interaction_handler/linear_accelerator_start/invoked(obj/machinery/linear_accelerator/target, mob/user)
	if(!do_after(user, 5, target))
		return
	if(!target.charge || !target.contained)
		return
	playsound(target, 'sound/effects/Evacuation.ogg', 50, 0)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/obj/machinery/linear_accelerator, fire)), 13 SECONDS)

/decl/interaction_handler/linear_accelerator_remove_item
	name = "Remove Item"
	expected_target_type = /obj/machinery/linear_accelerator

/decl/interaction_handler/linear_accelerator_remove_item/invoked(obj/machinery/linear_accelerator/target, mob/user)
	if(!target.contained)
		return
	user.put_in_hands(target.contained)
	target.contained = null