/obj/machinery/drainage_pump
	name = "fluid drainage pump"
	desc = "A portable pump designed to clean up spilled fluids."
	icon = 'icons/obj/atmospherics/atmos.dmi'
	icon_state = "siphon:0"
	use_power = POWER_USE_IDLE
	density = 1
	anchored = 1
	idle_power_usage = 130
	active_power_usage = 3700
	var/last_gurgle = 0

/obj/machinery/drainage_pump/Initialize()
	. = ..()
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_ALL)

/obj/machinery/drainage_pump/physical_attack_hand(user)
	. = ..()
	if(use_power == POWER_USE_IDLE)
		use_power = POWER_USE_ACTIVE
		visible_message("[user] switches on \the [src].")
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	else
		use_power = POWER_USE_IDLE
		visible_message("[user] switches off \the [src].")
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

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
	T.remove_fluid(CEILING(fluid_here*0.5 + 5))
	T.show_bubbles()
	if(world.time > last_gurgle + 80)
		last_gurgle = world.time
		playsound(T, pick(SSfluids.gurgles), 50, 1)