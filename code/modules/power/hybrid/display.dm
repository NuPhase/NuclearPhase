/obj/machinery/reactor_display
	name = "digital display"
	icon = 'icons/obj/reactor_display.dmi'
	icon_state = "display"
	var/special_description = ""

/obj/machinery/reactor_display/examine(mob/user)
	. = ..()
	if(special_description)
		to_chat(user, special_description)
	to_chat(user, "<span class='notice'>[get_display_data()]</span>")

/obj/machinery/reactor_display/proc/get_display_data()
	if(!powered())
		return "<span class='warning'>The [name] is blank.</span>"
	if(emagged)
		return "<span class='warning'>The [name] reads: 'NIGGER ALARM'.</span>"

/obj/machinery/reactor_display/group
	name = "group of displays"
	icon_state = "displaygroup"

/obj/machinery/reactor_display/feedpumps
	name = "feed pumps display"

/obj/machinery/reactor_display/feedpumps/get_display_data()
	. = ..()
	var/data = ""
	data = "RPM: NO DATA.<br>\
			Temperature: NO DATA<br>\
			Mass flow: NO DATA<br>\
			Status: NO DATA<br>"
	return data

/obj/machinery/reactor_monitor
	name = "digital monitor"
	icon = 'icons/obj/modernmonitor.dmi'
	icon_state = "off"
	active_power_usage = 480
	idle_power_usage = 50
	use_power = POWER_USE_IDLE
	var/program_overlay = ""
	var/on = FALSE

/obj/machinery/reactor_monitor/proc/get_display_data()
	if(emagged)
		return "<span class='warning'>The [name] reads: 'NIGGER ALARM'.</span>"

/obj/machinery/reactor_monitor/examine(mob/user)
	. = ..()
	if(on)
		to_chat(user, "<span class='notice'>[get_display_data()]</span>")

/obj/machinery/reactor_monitor/Initialize()
	. = ..()
	if(on)
		turn_on()

/obj/machinery/reactor_monitor/physical_attack_hand(user)
	. = ..()
	if(on)
		turn_off()
	else
		turn_on()

/obj/machinery/reactor_monitor/on_update_icon()
	overlays.Cut()
	if(on)
		overlays += image(icon, "overlay-[program_overlay]")

/obj/machinery/reactor_monitor/proc/turn_on()
	icon_state = "on"
	on = TRUE
	update_icon()

/obj/machinery/reactor_monitor/proc/turn_off()
	icon_state = "off"
	on = FALSE
	update_icon()