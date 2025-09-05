/obj/machinery/linear_accelerator
	name = "linear particle accelerator"
	desc = "A very powerful electron gun."
	active_power_usage = 150000
	idle_power_usage = 100

	var/max_capacity = 1000000
	var/charge = 0

	var/exposure_ticks = 10

	var/moderation = 0 // 0-1

	var/obj/item/contained

/obj/machinery/linear_accelerator/proc/fire()
	var/neutron_moles = charge / NEUTRON_MOLE_ENERGY
	var/datum/gas_mixture/gasmix = new(5, 80)

	var/fast_neutrons = neutron_moles * (1 - moderation)
	var/slow_neutrons = neutron_moles * moderation

	var/lost_neutrons = 0

	for(var/index = 1 to exposure_ticks)
		var/list/returned_list = gasmix.handle_nuclear_reactions(slow_neutrons, fast_neutrons)
		slow_neutrons = max(returned_list["slow_neutrons_changed"], 0)
		fast_neutrons = max(returned_list["fast_neutrons_changed"], 0)
		lost_neutrons += fast_neutrons * 0.1
		lost_neutrons += slow_neutrons * 0.1
		fast_neutrons *= 0.9
		slow_neutrons *= 0.9

	var/end_neutrons = fast_neutrons + slow_neutrons + lost_neutrons
	SSradiation.radiate(src, end_neutrons * RADS_PER_NEUTRON)
	playsound(src, 'sound/effects/bangtaper.ogg', 50, 0)

	charge = 0