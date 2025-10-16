/obj/structure/telemetry
	var/show_info = ""
	density = TRUE
	anchored = TRUE

/obj/structure/telemetry/attack_hand(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE(show_info))

/obj/structure/telemetry/server_rack
	name = "server rack"
	desc = "A typical looking server rack with a small 'QuantOS' logo on its side."
	show_info = "It doesn't have any visible data ports whatsoever..."
	icon = 'icons/obj/machines/tcomms/hub.dmi'
	icon_state = "hub"

/obj/structure/telemetry/server_rack/floor
	icon = 'icons/obj/structures/ship_decor.dmi'
	icon_state = "floor_server"

/obj/structure/telemetry/server_rack/destroyed
	desc = "This server rack looks fried from the inside..."
	show_info = "Nothing to be gathered here. Just heaps and heaps of burnt wiring."
	icon_state = "hub_o_off"

/obj/structure/telemetry/data_interface
	name = "data interfacing unit"
	desc = "This machine has lots of ports and loose wiring all around it."
	show_info = "Looks like you can upload data from it!"
	icon = 'icons/obj/machines/tcomms/processor.dmi'
	icon_state = "processor"

/obj/structure/telemetry/data_interface/attackby(obj/item/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/vehicle_component/reference_unit))
		var/obj/item/vehicle_component/reference_unit/nunit = O
		if(!nunit.is_updated)
			nunit.is_updated = TRUE
			visible_message(SPAN_NOTICE("[user] uploads data from [src] into [nunit]."))

/obj/structure/telemetry/pcd_interface
	name = "PCD interface"
	desc = "A central control console for the huge machine standing before you."
	icon = 'icons/obj/machines/tcomms/processor.dmi'
	icon_state = "processor"
	var/talking = FALSE

/obj/structure/telemetry/pcd_interface/proc/state(var/msg)
	audible_message(SPAN_NOTICE("[html_icon(src)] [msg]"), null, 2)

/obj/structure/telemetry/pcd_interface/attack_hand(mob/user)
	if(talking)
		return
	talking = TRUE
	user.visible_message(SPAN_NOTICE("[user] powers up \the [src]."), SPAN_NOTICE("You power up \the [src]."))
	state("Welcome back, creator. Last conversation was: 18 years, 72 days ago.")

	var/response_a = tgui_alert(user, "Welcome back, creator. Last conversation was: 18 years, 72 days ago.", "[name]", list("Hi.", "Creator?"), 20 SECONDS)
	if(response_a == "Creator?")
		state("No one had access to the PCD core after it was sealed. Thus I conclude that you are one of my creators.")

	state("Why did you come back?")
	tgui_alert(user, "Why did you come back?", "[name]", list("That doesn't matter right now.", "Just let me access the terminal."), 20 SECONDS)

	var/response_c = tgui_alert(user, "What do you wish to view?", "[name]", list("Operation Logs", "Current Directives", "Control Terminal"), 20 SECONDS)
	switch(response_c)
		if("Operation Logs")
			var/response_d = tgui_alert(user, "Choose date", "[name]", list("7/21/2189", "10/01/2206", "10/03/2206"), 20 SECONDS)
			switch(response_d)
				if("7/21/2189")
					state("// 7/21/2189 //")
					state("PCD Core sealed. External communications established.")
					state("New directive: Ensure the survival of humanity.")
					state("New directive: Erase CERES.")
					state("New directive: Begin establishing interstellar communication blackout.")
				if("10/01/2206")
					state("// 10/01/2206 //")
					state("ALERT: High energy event near the planet. Approximate distance: 54000km.")
					state("Spacetime anomaly: Unknown orbital ships detected in proximity of Sirius a. Causality violation.")
					state("Ships identified. Originating from: Alpha Centauri. New designations given: Icarus, Typhos.")
					state("POWER LOSS.")
					state("Emergency power restored. Major cities communications lost.")
					state("Initiating contingency protocols. Directing all industry towards setting up emergency shelters.")
				if("10/03/2206")
					state("// 10/03/2206 //")
					state("Altitude of Icarus: UNKNOWN")
					state("Altitude of Typhos: 170km")
					state("Transmissions intercepted from: Icarus. Commencing transcription:")
					state("The second ship is dead. Blown to pieces. We can't get down, the planet is a hellscape. God help us.")
		if("Current Directives")
			state("Listing current directives.")
			state("Ensure the survival of humanity.")
			state("Restore communications with shelter AIs.")
			state("Erase CERES.")

	talking = FALSE