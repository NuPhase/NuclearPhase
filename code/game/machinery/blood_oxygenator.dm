/obj/machinery/medical/blood_oxygenator
	name = "ECMO unit"
	desc = "Extracorporeal membrane oxygenation, also known as extracorporeal life support, is an extracorporeal technique of providing prolonged cardiac and respiratory support to persons whose heart and lungs are unable to provide an adequate amount of gas exchange or perfusion to sustain life."
	icon = 'icons/obj/structures/iv_drip.dmi'
	icon_state = "ecmo-off"
	active_power_usage = 400

	required_skill_type = SKILL_ANATOMY
	required_skill_level = SKILL_EXPERT
	connection_time = 20 SECONDS

	var/set_mcv = DEFAULT_MCV

/obj/machinery/medical/blood_oxygenator/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("[src] is circulating [set_mcv]ml of blood per minute."))

/obj/machinery/medical/blood_oxygenator/physical_attack_hand(user)
	. = ..()
	var/new_mcv = tgui_input_number(user, "Select the pumping capacity of the [src] in milliliters per minute", "MCV Setting", initial(set_mcv), max_value = 12000, min_value = 0)
	set_mcv = Clamp(new_mcv, 0, 12000)

/obj/machinery/medical/blood_oxygenator/disconnect(mob/living/carbon/human/user)
	connected.add_mcv = 0
	icon_state = "ecmo-off"
	. = ..()

/obj/machinery/medical/blood_oxygenator/can_connect(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/organ/external/head = GET_EXTERNAL_ORGAN(target, BP_HEAD)
	if(!head.how_open())
		return "You can't connect \the [src] without having surgical access to [target]'s head."
	return ..()

/obj/machinery/medical/blood_oxygenator/connect(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	icon_state = "ecmo-on"

/obj/machinery/medical/blood_oxygenator/Process()
	connected.add_mcv += set_mcv * 0.5
	playsound(src, 'sound/machines/pump.ogg', 25)

	var/toxicloss = 0.01
	if(!connected.has_chemical_effect(CE_BLOOD_THINNING)) //blood clotting
		var/obj/item/organ/internal/heart/H = GET_INTERNAL_ORGAN(connected, BP_HEART)
		if(H)
			H.stability_modifiers["ECMO clotting"] = set_mcv * 0.005 * -1
		toxicloss = 1
	connected.adjustToxLoss(toxicloss)
	connected.adjust_immunity(-toxicloss)
	if(prob(0.1)) //spontaneus blood vessel damage
		connected.take_overall_damage(15)
	connected.oxygen_amount = Interpolate(connected.oxygen_amount, connected.max_oxygen_capacity, 0.8)
	var/obj/item/organ/external/head/head = GET_EXTERNAL_ORGAN(connected, BP_HEAD)
	head.germ_level += 1
	var/obj/item/organ/internal/brain/B = GET_INTERNAL_ORGAN(connected, BP_BRAIN)
	B.take_internal_damage(0.01)