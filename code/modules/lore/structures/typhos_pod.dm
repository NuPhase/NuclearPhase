/obj/machinery/computer/typhos_pod
	name = "medevac ship console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	icon_keyboard = "security_key"
	icon_screen = "shuttle"
	light_color = "#1587a9"
	initial_access = list(access_cent_medical)
	var/talking = FALSE
	var/starting = FALSE

/obj/machinery/computer/typhos_pod/physical_attack_hand(mob/user)
	if(talking || starting)
		return
	talking = TRUE
	user.visible_message(SPAN_NOTICE("[user] powers up \the [src]."), SPAN_NOTICE("You power up \the [src]."))
	state("Greetings. Are you currently in a state of emergency?")
	var/response_a = tgui_alert(user, "Greetings. Are you currently in a state of emergency?", "[name]", list("Yes", "No"), 30 SECONDS)
	if(response_a == "No")
		state("Have a good day.")
		return
	state("Have you received approval to launch this medevac ship from the Typhos commander?")
	var/response_b = tgui_alert(user, "Have you received approval to launch this medevac ship from a Typhos commander?", "[name]", list("Yes", "No"), 30 SECONDS)
	if(response_b == "No")
		state("Is the current Typhos commander alive?")
		var/response_c = tgui_alert(user, "Is there a Typhos commander alive?", "[name]", list("Yes", "No"), 20 SECONDS)
		if(response_c == "Yes")
			state("You'll need to get the commander's approval. Have a good day.")
			return
	state("Have you hit absolute rock bottom, with no way in sight?")
	tgui_alert(user, "Have you hit absolute rock bottom, with no way in sight?", "[name]", list("Yes"), 30 SECONDS)
	state("Are you sure what you're doing is worth it, [user.real_name]?")
	tgui_alert(user, "Are you sure what you're doing is worth it, [user.real_name]?", "[name]", list("No", "No!", "No?"), 30 SECONDS)
	state("Requesting final confirmation. Starting the countdown will sound an alarm.")
	var/response_f = tgui_alert(user, "Requesting final confirmation. Starting the countdown will sound an alarm.", "[name]", list("HELL YEAH", "No"), 30 SECONDS)
	if(response_f == "No")
		state("Have a good day.")
		return

/obj/machinery/computer/typhos_pod/proc/start_countdown()
	playsound(src, 'sound/effects/Evacuation.ogg', 50, 0, 15)
	state("Startup sequence initialized. 10 minutes until launch.")
	addtimer(CALLBACK(src, PROC_REF(start_final)), 10 MINUTES, TIMER_CLIENT_TIME)
	starting = TRUE

/obj/machinery/computer/typhos_pod/proc/start_final()

/obj/machinery/computer/typhos_pod/proc/launch()