/obj/structure/babbler
	name = "tour speaker"
	icon = 'icons/obj/power.dmi'
	icon_state = "babbler"
	desc = "A speaker containing a prerecorded message."
	density = FALSE
	anchored = TRUE
	unacidable = TRUE
	var/babble_message
	var/last_babble = 0

/obj/structure/babbler/attack_hand(mob/user)
	. = ..()
	if(world.time > last_babble + 10 SECONDS)
		audible_message("<span class='game say'><span class='name'>\The [src]</span> babbles, \"[babble_message]\"</span>")
		last_babble = world.time

/obj/structure/babbler/welcome
	babble_message = "WELCOME! I am Viper, the leading engineer here at the SEC Nuclear Energy Research Facility. We are the first to offer public tours to most secure sites of human ingenuity. You are lucky to be here.\
					First, a basic walkthrough of the Reactor Operations sector will allow you to see what really powers New Tokyo - and how it works. Follow me!"

/obj/structure/babbler/sterile
	babble_message = "Don't forget to be sterile! We don't want any contaminants getting into our machinery. A decontamination a day keeps the doctor away."

/obj/structure/babbler/food
	babble_message = "Our cafeteria is closed since September until November of 2206, but you can still visit it to see where our workers eat and rest! Even the most brilliant minds need some time off."

/obj/structure/babbler/cts
	babble_message = "Our facility also produces highly enriched fuel required to power many, many shuttles in service around the world. CTS is a hungry beast, a very useful nonetheless. Maybe some of you will be lucky enough to catch a ride someday."



