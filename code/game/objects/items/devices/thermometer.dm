/obj/item/thermometer
	name = "digital thermometer"
	desc = "A simple digital infrared thermometer. Contact distance: 2 meters."
	icon = 'icons/obj/items/device/thermometer.dmi'
	icon_state = "white"

/obj/item/thermometer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	var/message = ""

	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		message = "[H]'s body temperature is: [H.bodytemperature - T0C]C|[H.bodytemperature]K."
	else if(istype(target, /obj/machinery/atmospherics/unary))
		var/obj/machinery/atmospherics/unary/U
		message = "[U]'s hull temperature is: [round(U.air_contents.temperature - T0C)]C|[round(U.air_contents.temperature)]K."

	if(message)
		user.visible_message(SPAN_NOTICE("[user] scans \the [target] with a [src]."))
		to_chat(user, SPAN_NOTICE(message))