/obj/item/implant/neural_link
	name = "neural link implant"
	desc = "Halucigenia-sama????"
	known = 1
	var/corruption = 0 //0-100
	var/serial_number

/obj/item/implant/neural_link/Initialize(ml, material_key)
	. = ..()
	serial_number = rand(111111, 999999)

/obj/item/implant/neural_link/get_data()
	return {"
	<b>CERES Neuralink v1.7</b><BR>
	<b>Serial number:</b> [serial_number]<BR>
	<b>Specification:</b> Public use."}

/obj/item/implant/neural_link/implanted(mob/living/carbon/human/source)
	source.StoreMemory("You've had a CERES neural link implant installed.", /decl/memory_options/system)
	source.playsound_local(source, 'sound/ambience/sonar.ogg', 50, 0)
	source.add_client_color(/datum/client_color/tritanopia)
	source.set_status(STAT_STUN, 3)
	source.set_status(STAT_WEAK, 15)
	to_chat(source, SPAN_OCCULT("1APfN2lYtdEnFQI5Z&vN$RDOJJ8VdyE&O4sF6^r37U^GJIxs0y"))
	spawn(5)
		to_chat(source, SPAN_OCCULT("zmVx&GKSXJzMT2%6NB*bXr9zF9bY$lYcb$H^sQXX*Wxigm#*zo"))
	spawn(10)
		to_chat(source, SPAN_OCCULT("$HuUiiK@$7NL!cA9hSu@p3SxJkPXpreK9Qkv5@h9#633U$Q7EO"))
	spawn(15)
		to_chat(source, SPAN_OCCULT("!@S1%d!30kwyTOEKpOF*sZ#8*X5C66Vyrdpk*Wc53PvfV&gXfm"))
	spawn(20)
		to_chat(source, SPAN_OCCULT("028FA8bXnncIOf4odaMHQJSdLxnPt9hZorhk$*37n1Z!fTqMd4"))
	spawn(35)
		to_chat(source, SPAN_ERP("|'CERES Neuralink v1.7' bootup initiated...|"))
		var/bootup_progress = 0
		while(bootup_progress < 99)
			bootup_progress = min(100, bootup_progress + rand(5, 15))
			sleep(15)
			to_chat(source, SPAN_ERP("|[bootup_progress]%|"))
		to_chat(source, SPAN_OCCULT("You feel as if you can access more parts of your brain than before."))
		source.remove_client_color(/datum/client_color/tritanopia)
	return TRUE

/obj/item/implant/neural_link/meltdown()
	if(malfunction == MALFUNCTION_PERMANENT) return
	to_chat(imp_in, SPAN_DANGER("You experience a massive headache!"))
	if (part)
		part.take_external_damage(burn = 15, used_weapon = "Electronics meltdown")
	else
		var/mob/living/M = imp_in
		M.apply_damage(15,BURN)
	name = "melted implant"
	desc = "Charred circuit in melted plastic case. Wonder what that used to be..."
	icon_state = "implant_melted"
	malfunction = MALFUNCTION_PERMANENT

/obj/item/implanter/neural_link
	name = "neural link implanter"
	imp = /obj/item/implant/neural_link

/obj/item/implantcase/neural_link
	name = "glass case - 'neural link'"
	imp = /obj/item/implant/neural_link