/datum/composite_sound/transformer
	mid_sounds = list('sound/machines/transformer/loop1.wav', 'sound/machines/transformer/loop2.wav', 'sound/machines/transformer/loop3.wav', 'sound/machines/transformer/loop4.wav')
	mid_length = 49
	volume = 40

/obj/machinery/power/generator/transformer
	name = "power transformer"
	icon = 'icons/obj/power.dmi'
	icon_state = "transformer"
	density = 1
	var/coef = 2
	var/obj/machinery/power/generator/transformer/connected = null
	var/max_cap = 250000 //w
	var/should_transfer_demand = FALSE
	var/on = 1
	var/critical = FALSE

	efficiency = 0.9
	should_heat = TRUE

	var/off_icon_state
	var/on_icon_state
	var/open_icon_state

	var/datum/composite_sound/transformer/soundloop = null

/obj/machinery/power/generator/transformer/start_ambience()
	if(!soundloop && on)
		soundloop = new(list(src), TRUE)

/obj/machinery/power/generator/transformer/stop_ambience()
	QDEL_NULL(soundloop)

/obj/machinery/power/generator/transformer/large
	icon_state = "transformer_back"

/obj/machinery/power/generator/transformer/Process()
	if(connected)
		return
	connected = locate(/obj/machinery/power/generator/transformer, get_step(src, dir))
	if(connected)
		connected.connected = src

/obj/machinery/power/generator/transformer/get_voltage()
	if(!powernet || !connected.powernet || (available() > connected.available()))
		return 0
	return connected.powernet.voltage * coef

/obj/machinery/power/generator/transformer/available_power()
	if(!powernet || !connected.powernet || (available() > connected.available()) || !connected.on)
		return 0
	return min(max_cap, connected.available())

/obj/machinery/power/generator/transformer/on_power_drain(w)
	if(!powernet || !connected.powernet || (available() > connected.available()))
		return 0
	return connected.draw_power(w)

/obj/machinery/power/generator/transformer/switchable
	name = "transformer breaker"
	var/RCon_tag = "NO_TAG"
	var/update_locked = 0
	var/busy = 0
	var/max_temperature = 368
	on = 0

/obj/machinery/power/generator/transformer/switchable/Process()
	process_electrocution()

	if(on)
		var/datum/gas_mixture/environment = loc.return_air()
		if(environment.temperature > max_temperature)
			trip()

	. = ..()

/obj/machinery/power/generator/transformer/switchable/Initialize()
	. = ..()
	if(!off_icon_state)
		off_icon_state = initial(icon_state)
		on_icon_state = initial(icon_state)
		open_icon_state = initial(icon_state)
	if(on)
		START_PROCESSING_MACHINE(src, null)
		icon_state = on_icon_state
	var/area/A = get_area(loc)
	A.ambient_objects += src

/obj/machinery/power/generator/transformer/switchable/examine(mob/user)
	. = ..()
	if(on)
		to_chat(user, "<span class='good'>Its lever is in 'RESET' position.</span>")
		to_chat(user, "<span class='notice'>The load is: [connected.powernet.ldemand]W.</span>")
	else
		to_chat(user, "<span class='warning'>Its lever is in 'TRIP' position.</span>")

/obj/machinery/power/generator/transformer/switchable/physical_attack_hand(mob/user)
	if(update_locked)
		to_chat(user, "<span class='warning'>System locked. Please try again later.</span>")
		return TRUE

	if(busy)
		to_chat(user, "<span class='warning'>System is busy. Please wait until current operation is finished before changing power settings.</span>")
		return TRUE

	busy = 1
	user.visible_message(SPAN_NOTICE("\The [user] starts switching \the [src]!"))
	if(do_after(user, 50,src))
		on = !on
		playsound(loc, 'sound/machines/transformerswitch.ogg', 50, 1)
		user.visible_message(
			SPAN_NOTICE("\The [user] [on ? "enabled" : "disabled"] \the [src]!"),\
			SPAN_NOTICE("You [on ? "enabled" : "disabled"] \the [src]!"))
		update_locked = 1
		spawn(50)
			update_locked = 0
		if(on)
			start_ambience()
			START_PROCESSING_MACHINE(src, null)
			icon_state = on_icon_state
			var/electrocution_chance = 10
			var/mob/living/carbon/human/H = user
			if(H.fire_stacks < 0)
				electrocution_chance += 20
			electrocution_chance = user.skill_fail_chance(SKILL_ELECTRICAL, electrocution_chance, SKILL_EXPERT, 1.5)
			if(prob(electrocution_chance))
				start_electrocution(user)
		else
			STOP_PROCESSING_MACHINE(src, null)
			icon_state = off_icon_state
			stop_ambience()
	busy = 0
	return TRUE

/obj/machinery/power/generator/transformer/switchable/proc/trip()
	on = FALSE
	update_locked = 1
	spawn(50)
		update_locked = 0
	STOP_PROCESSING_MACHINE(src, null)
	spawn(rand(1, 50))
		playsound(loc, 'sound/machines/power_down2.ogg', 50, 1)
		spark_at(src, amount = 7, cardinal_only = FALSE)
		icon_state = off_icon_state

/obj/machinery/power/generator/transformer/switchable/on
	on = 1

/obj/machinery/power/generator/transformer/switchable/on/large
	icon_state = "transformer_front_on"
	off_icon_state = "transformer_front_off"
	on_icon_state = "transformer_front_on"
	open_icon_state = "transformer_front_open"