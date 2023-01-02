/obj/machinery/power/hybrid_reactor
	name = "Hybrid Fission-Fusion Reactor Core"
	density = 1
	anchored = 1
	var/obj/effect/fusion_em_field/owned_field

/obj/machinery/power/hybrid_reactor/Initialize()
	. = ..()
	owned_field = new(loc, src)
	owned_field.ChangeFieldStrength(100)

/obj/machinery/power/hybrid_reactor/Process()
	. = ..()
	var/turf/A = get_turf(src)
	A.air.add_thermal_energy(500000) //Placeholder