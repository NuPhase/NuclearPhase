/obj/machinery/lung_ventilator
	name = "lung ventilator"
	desc = "A complex device made for providing oxygen and anaesthesia to a patient in ICU."
	icon = 'icons/obj/structures/iv_drip.dmi'
	icon_state = "ecmo-off"
	density = 1
	active_power_usage = 400
	var/oxygenating = FALSE
	var/sedating = FALSE
	var/oxygen_coef = 0.21
	var/connect_time = 0
	var/mob/living/carbon/human/connected = null

/obj/machinery/lung_ventilator/Initialize()
	. = ..()
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/lung_ventilator/examine(mob/user)
	. = ..()
	if(connected)
		to_chat(user, SPAN_NOTICE("[src] is connected to [connected]."))

/obj/machinery/lung_ventilator/physical_attack_hand(mob/user)
	. = ..()
	var/choice = input(user, "What do you want to toggle?", "Ventilation Switch") in list("Oxygenation", "Anaesthesia", "Oxygen Percentage")
	switch(choice)
		if("Oxygenation")
			oxygenating = !oxygenating
			if(oxygenating)
				user.visible_message(SPAN_NOTICE("[user] switches the [src]'s ventilation pumps on."), SPAN_NOTICE("You switch [src]'s ventilation pumps on."))
			else
				user.visible_message(SPAN_WARNING("[user] switches the [src]'s ventilation pumps off."), SPAN_WARNING("You switch [src]'s ventilation pumps off."))
		if("Anaesthesia")
			sedating = !sedating
			if(sedating)
				user.visible_message(SPAN_WARNING("[user] switches the [src]'s anaesthetic pumps on."), SPAN_WARNING("You switch [src]'s anaesthetic pumps on."))
			else
				user.visible_message(SPAN_NOTICE("[user] switches the [src]'s anaesthetic pumps off."), SPAN_NOTICE("You switch [src]'s anaesthetic pumps off."))
		if("Oxygen Percentage")
			var/inputting = input(user, "Select a new oxygen percentage for the [src].", "Oxygenation Config") as null|num
			if(inputting)
				oxygen_coef = clamp(inputting, 0, 100) * 0.01

/obj/machinery/lung_ventilator/proc/disconnect(var/forceful = FALSE)
	if(!forceful)
		visible_message(SPAN_NOTICE("The [src]'s mask slips back into its storage."))
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	oxygenating = FALSE
	sedating = FALSE
	connected = null
	connect_time = 0
	icon_state = "ecmo-off"

/obj/machinery/lung_ventilator/proc/connect(mob/living/carbon/human/to_connect, mob/user)
	connected = to_connect
	visible_message(SPAN_NOTICE("[connected] gets connected to the [src]."))
	spawn(2 SECONDS)
		if(connected)
			visible_message(SPAN_NOTICE("[src] slowly whirs up."))
			icon_state = "ecmo-on"
			START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/lung_ventilator/handle_mouse_drop(atom/over, mob/user)
	if(connected)
		disconnect(FALSE)
		return TRUE
	if(ishuman(over))
		connect(over, user)
		return TRUE
	. = ..()

/obj/machinery/lung_ventilator/Process()
	if(connected)
		if(!Adjacent(connected))
			disconnect(TRUE)
			return PROCESS_KILL
	else
		return PROCESS_KILL

	if(oxygenating)
		connected.add_oxygen(100 * oxygen_coef)

	if(sedating)
		if(connect_time > 15)
			connected.add_chemical_effect(CE_PRESSURE, 25)
			ADJ_STATUS(connected, STAT_ASLEEP, 1.1)
		else
			ADJ_STATUS(connected, STAT_DIZZY, 3)
			SET_STATUS_MAX(connected, STAT_BLURRY, 10)