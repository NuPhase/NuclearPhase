/decl/blood_analysis
	var/name
	var/description
	var/time = 5 SECONDS

/decl/blood_analysis/proc/return_analysis(var/mob/living/carbon/human/H, blood_data)
	return ""

/decl/blood_analysis/potassium
	name = "Biochemical Analysis"

/decl/blood_analysis/potassium/return_analysis(var/mob/living/carbon/human/H, blood_data)
	var/list/text = ""
	var/list/chem_data = blood_data["trace_chem"]
	text += "<center><b>Analysis #[rand(1, 999)]</b></center><br>"
	text += "<center><i>Biochemical Analysis</i></center><br>"
	text += "Potassium: [round(0 + chem_data[/decl/material/solid/potassium])] (1-3)<br>"
	text += "Proteins: [round(rand(9, 11), 0.1)] (5-17)<br>"
	text += "Blood pH: [round(rand(7.35, 7.45), 0.01)] (7.35-7.45)<br>"
	return jointext(text, "<br>")

/decl/blood_analysis/blood
	name = "Blood Type Analysis"

/decl/blood_analysis/blood/return_analysis(var/mob/living/carbon/human/H, blood_data)
	var/list/text = ""
	//var/list/chem_data = blood_data["trace_chem"]
	text += "<center><b>Analysis #[rand(1, 999)]</b></center><br>"
	text += "<center><i>Blood Type Analysis</i></center><br>"
	text += "Blood Type: [blood_data["blood_type"]]<br>"
	text += "DNA String: [blood_data["blood_DNA"]]<br>"
	return jointext(text, "<br>")

/decl/blood_analysis/organ
	name = "Organ Function Analysis"

/decl/blood_analysis/organ/return_analysis(var/mob/living/carbon/human/H, blood_data)
	var/list/text = ""
	var/obj/item/organ/internal/heart/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	var/obj/item/organ/internal/liver/liver = GET_INTERNAL_ORGAN(H, BP_LIVER)
	var/obj/item/organ/internal/kidneys/kidneys = GET_INTERNAL_ORGAN(H, BP_KIDNEYS)
	text += "<center><b>Analysis #[rand(1, 999)]</b></center><br>"
	text += "<center><i>Organ Function Analysis</i></center><br>"
	text += "Troponin-T: [rand(0, 0.05) + round(heart.damage * 0.3, 0.01)] (0.04<)<br>"
	text += "Bilirubin: [rand(1.71, 20.5) + round(liver.damage * 0.6, 0.01)] (1.71-20.5)<br>"
	text += "ACR: [rand(0, 29) + round(kidneys.damage * 1.3, 0.01)] (33<)<br>"
	return jointext(text, "<br>")

/obj/machinery/blood_analysis
	name = "blood analyser"
	desc = "Analyzes centrifuged blood. Needs a vial in it to work."
	icon = 'icons/obj/machines/blood_analyzer.dmi'
	icon_state = "idle"
	idle_power_usage = 50
	active_power_usage = 2100
	core_skill = SKILL_MEDICAL
	var/obj/item/chems/glass/beaker/vial/inserted_vial
	var/running = FALSE

/obj/machinery/blood_analysis/on_update_icon()
	if(running)
		icon_state = "running"
		return
	else
		icon_state = "idle"

/obj/machinery/blood_analysis/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/chems/glass/beaker/vial))
		if(inserted_vial)
			return
		inserted_vial = I
		user.drop_from_inventory(I, src)
		visible_message(SPAN_NOTICE("[user] inserts a vial into the blood analyzer."))
		return
	. = ..()

/obj/machinery/blood_analysis/proc/start(decl/blood_analysis/chosen_analysis)
	running = TRUE
	update_icon()
	spawn((40 - REAGENT_VOLUME(inserted_vial.reagents, /decl/material/liquid/separated_blood)) SECONDS)
		visible_message(SPAN_NOTICE("The blood analyzer finishes running."))
		running = FALSE
		var/list/blood_data = inserted_vial.reagents.reagent_data[/decl/material/liquid/separated_blood]
		var/weakref/W = LAZYACCESS(blood_data, "donor")
		if(!W)
			return
		var/mob/living/carbon/human/H = W.resolve()
		new /obj/item/paper(get_turf(src), chosen_analysis.return_analysis(H, blood_data), "Analysis Results for [H.real_name]")
		inserted_vial.reagents.remove_any(inserted_vial.reagents.maximum_volume)
		update_icon()

/obj/machinery/blood_analysis/physical_attack_hand(user)
	. = ..()
	try_handle_interactions(user, get_alt_interactions(user))

/obj/machinery/blood_analysis/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/blood_analysis_remove_vial)
	if(!running)
		LAZYADD(., /decl/interaction_handler/blood_analysis_start)

/decl/interaction_handler/blood_analysis_start
	name = "Start"
	expected_target_type = /obj/machinery/blood_analysis

/decl/interaction_handler/blood_analysis_start/invoked(obj/machinery/blood_analysis/target, mob/user)
	if(!do_after(user, 5, target))
		return
	if(!target.powered(EQUIP))
		return
	if(!target.inserted_vial.reagents.total_volume)
		return
	var/list/possible_analysis_decls = list()
	for(var/cur_analysis in subtypesof(/decl/blood_analysis))
		var/decl/blood_analysis/actual_decl = GET_DECL(cur_analysis)
		possible_analysis_decls["[actual_decl.name]"] = actual_decl
	var/choice = input(user, "Choose an analysis to perform.", "Analysis choice") as null|anything in possible_analysis_decls
	var/chosen_one = possible_analysis_decls[choice]
	if(!chosen_one)
		return
	target.start(chosen_one)
	target.visible_message(SPAN_NOTICE("[user] turns on the blood analyzer."))

/decl/interaction_handler/blood_analysis_remove_vial
	name = "Remove a Vial"
	expected_target_type = /obj/machinery/blood_analysis

/decl/interaction_handler/blood_analysis_remove_vial/invoked(obj/machinery/blood_analysis/target, mob/user)
	if(!target.inserted_vial)
		to_chat(user, SPAN_NOTICE("There are no vial in the blood analyzer."))
		return
	if(target.running)
		return
	var/obj/item/chems/glass/beaker/vial/cur_vial = target.inserted_vial
	user.put_in_hands(cur_vial)
	target.inserted_vial = null
	target.visible_message(SPAN_NOTICE("[user] removes a vial from the blood analyzer."))