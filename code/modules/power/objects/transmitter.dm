/obj/machinery/power/transmitter
	icon = 'icons/obj/power.dmi'
	icon_state = "transmitter"

	var/obj/machinery/power/transmitter/up

	efficiency = 0.75

/obj/machinery/power/transmitter/Process()
	if(up)
		return

	var/obj/machinery/power/transmitter/dup = locate(/obj/machinery/power/transmitter, get_step(src, UP))
	if(dup)
		up = dup
	else
		return
	// FIXME: this thing will create supersayan bugs.
	merge_powernets(powernet, dup.powernet)