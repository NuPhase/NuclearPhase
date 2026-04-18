/obj/machinery/ai_mainframe
	name = "large mainframe"
	desc = "A large mainframe with a logo on it. It reads: 'S.C.S. MAINFRAME'."
	icon = 'icons/obj/machines/inertial_damper.dmi'
	icon_state = "damper_on"
	color = COLOR_STEEL
	anchored = TRUE
	density = TRUE
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 100
	active_power_usage = 100000
	bound_x = -32
	bound_y  = -32
	bound_width = 96
	bound_height = 96
	pixel_x = -32
	pixel_y = -32

/obj/machinery/ai_mainframe/Process()
	fcontrol.Process()
