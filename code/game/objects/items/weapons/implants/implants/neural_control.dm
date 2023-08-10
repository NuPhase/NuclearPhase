/obj/item/implant/neural_control
	name = "neural link implant"
	desc = "Something's not right with this one..."
	known = 1
	var/corruption = 0 //0-100
	var/serial_number

/obj/item/implant/neural_control/Initialize(ml, material_key)
	. = ..()
	serial_number = rand(111111, 999999)

/obj/item/implant/neural_control/get_data()
	return {"
	<b>CERES Neuralink v4.2</b><BR>
	<b>Serial number:</b> [serial_number]<BR>
	<b>Specification:</b> Research use.<BR>
	ENGINEERING PROTOTYPE, DANGER: Internal data filters have not yet been installed.<BR>
	<b>Usage on living humans will cause damage in both the user and the recipient.</b>"}

/obj/item/implant/neural_control/implanted(mob/living/carbon/human/source)
	source.StoreMemory("You've had a CERES neural control implant installed.", /decl/memory_options/system)
	to_chat(source, SPAN_ERP("|'CERES Neuralink v4.2' bootup initiated...|"))
	var/bootup_progress = 0
	while(bootup_progress < 99)
		bootup_progress = min(100, bootup_progress + rand(15, 25))
		sleep(15)
		to_chat(source, SPAN_ERP("|[bootup_progress]%|"))
	to_chat(source, SPAN_OCCULT("You feel as if you can access more parts of your brain than before."))
	return TRUE

/obj/item/implant/neural_control/meltdown()
	if(malfunction == MALFUNCTION_PERMANENT) return
	var/obj/item/organ/external/head/explodey_head = GET_EXTERNAL_ORGAN(imp_in, BP_HEAD)
	explosion(get_turf(imp_in), -10, 0, 1, 2)
	explodey_head.take_external_damage(500, used_weapon = "Electronics meltdown")
	name = "melted implant"
	desc = "Charred circuit in melted plastic case. Wonder what that used to be..."
	icon_state = "implant_melted"
	malfunction = MALFUNCTION_PERMANENT

/obj/item/implanter/neural_control
	name = "neural link implanter"
	imp = /obj/item/implant/neural_control

/obj/item/implantcase/neural_control
	name = "glass case - 'neural link'"
	imp = /obj/item/implant/neural_control