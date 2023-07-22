/obj/machinery/drainage_pump
	name = "fluid drainage pump"
	desc = "A portable pump designed to clean up spilled fluids."
	icon = 'icons/obj/atmospherics/atmos.dmi'
	icon_state = "siphon:0"
	use_power = POWER_USE_IDLE
	idle_power_usage = 130
	active_power_usage = 3700
	var/last_gurgle = 0

/obj/machinery/drainage_pump/Process()
	if(use_power != POWER_USE_ACTIVE)
		return
	var/turf/T = get_turf(src)
	if(!istype(T)) return
	var/fluid_here = T.get_fluid_depth()
	if(fluid_here <= 0)
		icon_state = "siphon:T"
		return
	icon_state = "siphon:1"
	T.remove_fluid(CEILING(fluid_here*0.5))
	T.show_bubbles()
	if(world.time > last_gurgle + 80)
		last_gurgle = world.time
		playsound(T, pick(SSfluids.gurgles), 50, 1)