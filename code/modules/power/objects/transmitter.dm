/obj/machinery/power/transmittor
	icon = 'icons/obj/power.dmi'
	icon_state = "transmittor"

	var/obj/machinery/power/transmittor/up

	efficiency = 0.75

/obj/machinery/power/transmittor/Process()
	if(up)
		return

	var/obj/machinery/power/transmittor/dup = locate(/obj/machinery/power/transmittor, get_step(src, UP))
	if(dup)
		up = dup
	else
		return
	// FIXME: this thing will create supersayan bugs.
	merge_powernets(powernet, dup.powernet)