/obj/machinery/medical/blood_circulator
	name = "ABCS unit"
	desc = "Artificial Blood Circulation System. Requires an open chest cavity for connection."
	icon = 'icons/obj/structures/iv_drip.dmi'
	icon_state = "abcs-off"

	required_skill_type = SKILL_ANATOMY
	required_skill_level = SKILL_ADEPT
	connection_time = 30 SECONDS

	var/set_mcv = DEFAULT_MCV

/obj/machinery/medical/blood_circulator/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("[src] is circulating [set_mcv]ml of blood per minute."))

/obj/machinery/medical/blood_circulator/physical_attack_hand(user)
	. = ..()
	var/new_mcv = tgui_input_number(user, "Select the pumping capacity of the [src] in milliliters per minute", "MCV Setting", initial(set_mcv), max_value = 12000, min_value = 0)
	set_mcv = Clamp(new_mcv, 0, 12000)

/obj/machinery/medical/blood_circulator/disconnect(mob/living/carbon/human/user)
	connected.add_mcv = 0
	icon_state = "abcs-off"
	. = ..()

/obj/machinery/medical/blood_circulator/can_connect(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/organ/external/chest = GET_EXTERNAL_ORGAN(target, BP_CHEST)
	if(!chest.how_open())
		return "You can't connect \the [src] without having surgical access to [target]'s chest."
	return ..()

/obj/machinery/medical/blood_circulator/connect(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	icon_state = "abcs-on"

/obj/machinery/medical/blood_circulator/Process()
	connected.add_mcv += set_mcv * 0.5
	playsound(src, 'sound/machines/pump.ogg', 25)

	var/toxicloss = 0.01
	if(!connected.has_chemical_effect(CE_BLOOD_THINNING)) //blood clotting
		var/obj/item/organ/internal/heart/H = GET_INTERNAL_ORGAN(connected, BP_HEART)
		if(H)
			H.stability_modifiers["ABCS clotting"] = set_mcv * 0.005 * -1
		toxicloss = 1
	connected.adjustToxLoss(toxicloss)
	connected.adjust_immunity(-toxicloss)
	if(prob(0.1)) //spontaneus blood vessel damage
		connected.take_overall_damage(15)
