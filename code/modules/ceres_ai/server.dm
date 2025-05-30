/obj/machinery/ai_server
	name = "large server"
	desc = "A large mainframe with a logo on it. It reads: 'S.C.S. SUPPORT SYSTEMS'."
	icon = 'icons/obj/machines/ai_server.dmi'
	icon_state = "frame"
	anchored = TRUE
	density = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 100
	active_power_usage = 45000 //a huge rack
	power_channel = EQUIP
	var/corruption = 0

/obj/machinery/ai_server/on_update_icon()
	cut_overlays()
	if(!powered())
		return
	var/light_state
	switch(corruption)
		if(0 to 0.25)
			light_state = "lights_3"
		if(0.25 to 0.5)
			light_state = "lights_2"
		if(0.5 to 0.75)
			light_state = "lights_1"
		if(0.75 to 1)
			light_state = "lights_0"
	add_overlay(emissive_overlay(icon, light_state))

/obj/machinery/ai_server/Initialize()
	. = ..()
	fcontrol.add_server(src)
	update_icon()

/obj/machinery/ai_server/Destroy()
	. = ..()
	fcontrol.remove_server(src)