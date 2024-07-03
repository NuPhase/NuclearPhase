/obj/machinery/blood_oxygenator
	name = "ECMO unit"
	desc = "Extracorporeal membrane oxygenation, also known as extracorporeal life support, is an extracorporeal technique of providing prolonged cardiac and respiratory support to persons whose heart and lungs are unable to provide an adequate amount of gas exchange or perfusion to sustain life."
	icon = 'icons/obj/structures/iv_drip.dmi'
	icon_state = "ecmo-off"
	density = 1
	active_power_usage = 400
	var/mob/living/carbon/human/connected = null
	var/set_mcv = 1200

/obj/machinery/blood_oxygenator/Initialize()
	. = ..()
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/blood_oxygenator/examine(mob/user)
	. = ..()
	if(connected)
		to_chat(user, SPAN_NOTICE("[src] is connected to [connected]."))
	to_chat(user, SPAN_NOTICE("[src] is circulating [set_mcv]ml of blood per minute."))

/obj/machinery/blood_oxygenator/physical_attack_hand(user)
	. = ..()
	var/new_mcv = input(user, "Select the pumping capacity of the [src] in milliliters per minute", "MCV setting", initial(set_mcv)) as null|num
	if(new_mcv)
		set_mcv = Clamp(new_mcv, 0, 12000)

/obj/machinery/blood_oxygenator/proc/disconnect(var/forceful = FALSE)
	if(!forceful)
		visible_message(SPAN_NOTICE("[connected] gets disconnected from [src]."))
	else
		visible_message("The tubes of the [src] get ripped out of [connected]'s neck!")
		connected.apply_damage(20, BRUTE, BP_HEAD, damage_flags=DAM_SHARP)
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	connected.add_mcv = 0
	connected = null
	icon_state = "ecmo-off"

/obj/machinery/blood_oxygenator/proc/connect(mob/living/carbon/human/to_connect, mob/user)
	var/obj/item/organ/external/head = GET_EXTERNAL_ORGAN(to_connect, BP_HEAD)
	if(!head.how_open())
		to_chat(user, SPAN_WARNING("You can't access [to_connect]'s arteries without cutting their neck open first!"))
		return
	connected = to_connect
	visible_message(SPAN_NOTICE("[connected] gets connected to [src]."))
	spawn(2 SECONDS)
		if(connected)
			visible_message(SPAN_NOTICE("[src] slowly whirs up."))
			icon_state = "ecmo-on"
			START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/blood_oxygenator/handle_mouse_drop(atom/over, mob/user)
	if(connected)
		disconnect(FALSE)
		return TRUE
	if(ishuman(over))
		connect(over, user)
		return TRUE
	. = ..()

/obj/machinery/blood_oxygenator/Process()
	if(connected)
		if(!Adjacent(connected))
			disconnect(TRUE)
			return PROCESS_KILL
	else
		return PROCESS_KILL
	playsound(src, 'sound/machines/pump.ogg', 25)
	connected.add_mcv += set_mcv
	connected.oxygen_amount = Interpolate(connected.oxygen_amount, connected.max_oxygen_capacity, 0.7)
	var/obj/item/organ/internal/brain/B = GET_INTERNAL_ORGAN(connected, BP_BRAIN)
	B.take_internal_damage(0.01)
	var/obj/item/organ/external/head/head = GET_EXTERNAL_ORGAN(connected, BP_HEAD)
	head.germ_level += 1