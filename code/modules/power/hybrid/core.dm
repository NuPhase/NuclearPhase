#define FISSION_RATE 0.15
#define NEUTRON_FLUX_RATE 0.05
#define NEUTRONS_PER_RAD 17
#define REACTOR_POWER_MODIFIER

/obj/machinery/power/hybrid_reactor
	name = "reactor superstructure"
	icon = 'icons/obj/machines/power/fission.dmi'
	icon_state = "fission_core"
	density = 1
	anchored = 1
	var/neutron_flux = 1

/obj/machinery/power/hybrid_reactor/Process()
	var/turf/A = get_turf(src)
	var/datum/gas_mixture/GM = A.return_air()
	var/total_radiation = 0
	total_radiation += process_fission(GM)
	total_radiation += process_fusion(GM)
	SSradiation.radiate(src, total_radiation)

/obj/machinery/power/hybrid_reactor/proc/process_fission(datum/gas_mixture/GM)
	var/total_neutron_amount = 20
	for(var/g in GM.gas)
		var/decl/material/mat = GET_DECL(g)
		var/react_amount = GM.gas[g] * FISSION_RATE
		var/neutrons_absorbed = mat.neutron_absorption * react_amount
		if(mat.neutron_production)
			total_neutron_amount += mat.neutron_production * react_amount * neutron_flux
			GM.adjust_gas(mat.uid, !react_amount)
			if(mat.fission_products)
				for(var/fp in mat.fission_products)
					GM.adjust_gas(fp, react_amount)
		total_neutron_amount -= neutrons_absorbed
		GM.add_thermal_energy(mat.fission_energy * neutrons_absorbed * 10)
	neutron_flux = Interpolate(neutron_flux, Clamp(total_neutron_amount * NEUTRON_FLUX_RATE, 10, 1000000000), 0.2)
	return neutron_flux / NEUTRONS_PER_RAD


/obj/machinery/power/hybrid_reactor/proc/process_fusion(datum/gas_mixture/GM)
	//GM.add_thermal_energy(1000000)
	return 100