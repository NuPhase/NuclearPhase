/obj/machinery/blood_circulator
	name = "ABCS unit"
	desc = "Artificial Blood Circulation System. Requires an open chest cavity for connection."
	icon = 'icons/obj/structures/iv_drip.dmi'
	icon_state = "abcs-off"
	density = 1
	active_power_usage = 200
	var/mob/living/carbon/human/connected = null
	var/set_mcv = 1200

/obj/machinery/blood_circulator/Initialize()
	. = ..()
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/blood_circulator/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("[src] is circulating [set_mcv]ml of blood per minute."))

/obj/machinery/blood_circulator/physical_attack_hand(user)
	. = ..()
	var/new_mcv = input(user, "Select the pumping capacity of the [src] in milliliters per minute", "MCV setting", initial(set_mcv)) as null|num
	if(new_mcv)
		set_mcv = Clamp(new_mcv, 0, 12000)

/obj/machinery/blood_circulator/proc/disconnect(var/forceful = FALSE)
	if(!forceful)
		visible_message(SPAN_NOTICE("[connected] gets disconnected from [src]."))
	else
		visible_message("The tubes of the [src] get ripped out of [connected]!")
		connected.apply_damage(20, BRUTE, BP_CHEST, damage_flags=DAM_SHARP)
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	connected.add_mcv = 0
	connected = null
	icon_state = "abcs-off"

/obj/machinery/blood_circulator/proc/connect(mob/living/carbon/human/to_connect, mob/user)
	var/obj/item/organ/external/chest = GET_EXTERNAL_ORGAN(to_connect, BP_CHEST)
	if(!chest.how_open())
		to_chat(user, SPAN_WARNING("You can't access [to_connect]'s coronary channels without cutting them open first!"))
		return
	connected = to_connect
	visible_message(SPAN_NOTICE("[connected] gets connected to [src]."))
	spawn(2 SECONDS)
		if(connected)
			visible_message(SPAN_NOTICE("[src] slowly whirs up."))
			icon_state = "abcs-on"
			START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/blood_circulator/Process()
	if(connected)
		if(!Adjacent(connected))
			disconnect(TRUE)
			return PROCESS_KILL
	else
		return PROCESS_KILL
	connected.add_mcv = Interpolate(connected.add_mcv, set_mcv, 0.2)

	if(!connected.has_chemical_effect(CE_BLOOD_THINNING)) //blood clotting
		var/obj/item/organ/internal/heart/H = GET_INTERNAL_ORGAN(connected, BP_HEART)
		if(H)
			H.stability_modifiers["ABCS clotting"] = set_mcv * 0.005 * -1
	connected.adjustToxLoss(0.01)
	connected.adjust_immunity(-1)
	if(prob(0.1)) //spontaneus blood vessel damage
		connected.take_overall_damage(15)

/obj/machinery/blood_circulator/handle_mouse_drop(atom/over, mob/user)
	if(connected)
		disconnect(FALSE)
		return TRUE
	if(ishuman(over))
		connect(over, user)
		return TRUE
	. = ..()