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
	..()
	var/data = ""
	data = "RPM: NO DATA.<br>\
			Temperature: NO DATA<br>\
			Mass flow: NO DATA<br>\
			Status: NO DATA<br>"
	return data