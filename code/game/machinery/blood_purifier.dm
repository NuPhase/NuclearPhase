/obj/machinery/medical/blood_purifier
	name = "Dialysis machine"
	desc = "A machine that cleans blood of impurities."
	icon = 'icons/obj/structures/iv_drip.dmi'
	icon_state = "abcs-off"
	active_power_usage = 400

	required_skill_type = SKILL_MEDICAL
	required_skill_level = SKILL_ADEPT
	connection_time = 20 SECONDS

/obj/machinery/medical/blood_oxygenator/disconnect(mob/living/carbon/human/user)
	icon_state = "abcs-off"
	. = ..()

/obj/machinery/medical/blood_oxygenator/connect(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	icon_state = "abcs-on"

/obj/machinery/medical/blood_oxygenator/Process()
	connected.bloodstr.remove_any(1)