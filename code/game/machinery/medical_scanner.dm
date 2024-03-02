
/obj/machinery/medical_scanner
	name = "scanner suite"
	desc = "A complex scanner suite with XRay and ultasound equipment."
	icon =  'icons/obj/virology.dmi'
	icon_state = "isolator_off"
	density = 1

/obj/machinery/medical_scanner/handle_mouse_drop(atom/over, mob/user)
	if(ishuman(over))
		analyze(over, user)
		return TRUE
	. = ..()

/obj/machinery/medical_scanner/proc/analyze(mob/living/carbon/human/H, mob/user)
	if(!do_after(user, 5, src))
		return
	if(!powered(EQUIP))
		return
	var/list/possible_analysis_decls = list()
	for(var/cur_analysis in subtypesof(/decl/scanner_analysis))
		var/decl/scanner_analysis/actual_decl = GET_DECL(cur_analysis)
		if(!actual_decl)
			continue
		if(actual_decl.abstract_type == actual_decl.type)
			continue
		possible_analysis_decls["[actual_decl.name]"] = actual_decl
	var/choice = input(user, "Choose an analysis to perform.", "Analysis choice") as null|anything in possible_analysis_decls
	var/decl/scanner_analysis/chosen_one = possible_analysis_decls[choice]
	if(!chosen_one)
		return
	var/can_conduct = chosen_one.can_conduct()
	if(can_conduct != TRUE)
		to_chat(user, SPAN_WARNING(can_conduct))
		return
	if(!do_after(user, chosen_one.time, H))
		return
	visible_message(SPAN_NOTICE("[user] scans [H]."))
	chosen_one.after_analysis(src)
	spawn(2 SECONDS)
		new /obj/item/paper(get_turf(src), chosen_one.return_analysis(H), "Analysis Results for [H.real_name]")