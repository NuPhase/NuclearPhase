/obj/machinery/drug_dispenser
	name = "drug dispenser"
	desc = "A smart machine for dispensing drugs."
	icon = 'icons/obj/vending.dmi'
	icon_state = "fridge_sci"
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	density = TRUE
	idle_power_usage = 5
	active_power_usage = 100
	atom_flags = ATOM_FLAG_NO_REACT
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE
	atmos_canpass = CANPASS_NEVER
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES
	var/list/reagent_volumes = list(/decl/material/liquid/nanoblood/saline = 40000) // /decl/material = amount
	var/list/all_categories = list(
		DRUG_CATEGORY_PAIN_SLEEP,
		DRUG_CATEGORY_ANTIBIOTICS,
		DRUG_CATEGORY_MISC,
		DRUG_CATEGORY_RESUSCITATION,
		DRUG_CATEGORY_CARDIAC,
		DRUG_CATEGORY_TOX
	)

	var/vials_in_storage = 25
	var/syringes_in_storage = 30
	var/iv_packs_in_storage = 4

	var/dosage = 0.5 //0.01 - 1

/obj/machinery/drug_dispenser/Initialize()
	. = ..()
	for(var/reagent_type in reagent_volumes)
		reagent_volumes[reagent_type] = SSpersistence.take_reagent(reagent_type, reagent_volumes[reagent_type])
	prune_reagents()

/obj/machinery/drug_dispenser/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/chems/syringe))
		put_in_storage(I, user)
		return TRUE
	if(istype(I, /obj/item/chems/glass/beaker/vial))
		put_in_storage(I, user)
		return TRUE
	if(istype(I, /obj/item/chems/ivbag))
		put_in_storage(I, user)
		return TRUE
	. = ..()

/obj/machinery/drug_dispenser/proc/put_in_storage(obj/item/I, mob/user)
	switch(I.type)
		if(/obj/item/chems/syringe)
			syringes_in_storage++
		if(/obj/item/chems/glass/beaker/vial)
			syringes_in_storage++
		if(/obj/item/chems/ivbag)
			iv_packs_in_storage++
	if(I.reagents)
		for(var/mat_type in I.reagents.reagent_volumes)
			reagent_volumes[mat_type] += I.reagents.reagent_volumes[mat_type]
	qdel(I)

/obj/machinery/drug_dispenser/physical_attack_hand(user)
	tgui_interact(user)

/obj/machinery/drug_dispenser/proc/prune_reagents()
	for(var/mat_type in reagent_volumes)
		if(0 >= reagent_volumes[mat_type])
			reagent_volumes -= mat_type

/obj/machinery/drug_dispenser/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("dispense")
			var/available_saline = reagent_volumes[/decl/material/liquid/nanoblood/saline]
			if(!available_saline)
				to_chat(usr, SPAN_WARNING("There is no saline in the drug dispenser."))
				return
			var/dispense_string = params["dispense_string"]
			var/dispense_type
			switch(dispense_string)
				if("syringe")
					if(!syringes_in_storage)
						return
					dispense_type = /obj/item/chems/syringe
					syringes_in_storage -= 1
				if("vial")
					if(!vials_in_storage)
						return
					dispense_type = /obj/item/chems/glass/beaker/vial
					vials_in_storage -= 1
				if("ivpack")
					if(!iv_packs_in_storage)
						return
					dispense_type = /obj/item/chems/ivbag
					iv_packs_in_storage -= 1
			var/true_reagent_type = text2path(params["reagent_type"])
			if(!true_reagent_type)
				return
			var/decl/material/dispense_reagent = GET_DECL(true_reagent_type)
			var/obj/item/chems/dispense_object = new dispense_type(get_turf(src))
			available_saline = min(available_saline, dispense_object.volume)
			var/reagent_to_dispense = available_saline * dosage
			reagent_to_dispense = min(reagent_to_dispense, reagent_volumes[true_reagent_type])
			available_saline -= reagent_to_dispense
			dispense_object.reagents.add_reagent(true_reagent_type, reagent_to_dispense)
			dispense_object.reagents.add_reagent(/decl/material/liquid/nanoblood/saline, available_saline)
			reagent_volumes[/decl/material/liquid/nanoblood/saline] -= available_saline
			reagent_volumes[true_reagent_type] -= reagent_to_dispense
			dispense_object.name = "[dispense_object.name] ([dispense_reagent.name] [dosage]mg/ml)"
			dispense_object.update_icon()
			prune_reagents()
			return TRUE

		if("change_dosage")
			dosage = params["new_dosage"]
			return TRUE

/obj/machinery/drug_dispenser/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DrugDispenser", "Drug Dispenser")
		ui.open()

/obj/machinery/drug_dispenser/tgui_static_data(mob/user)
	return list("categories" = all_categories)

/obj/machinery/drug_dispenser/tgui_data(mob/user)
	return list("reagent_list" = assemble_reagent_list(),
				"vial_available" = vials_in_storage > 0,
				"syringe_available" = syringes_in_storage > 0,
				"iv_pack_available" = iv_packs_in_storage > 0,
				"dosage" = dosage)

/obj/machinery/drug_dispenser/proc/assemble_reagent_list()
	var/list/reagent_list = list()
	for(var/mat_type in reagent_volumes)
		var/decl/material/mat = GET_DECL(mat_type)
		reagent_list += list(list("name" = mat.name, "description" = mat.lore_text, "uid" = mat.uid, "category" = mat.drug_category, "amount" = reagent_volumes[mat_type], "rtype" = mat.type))
	return reagent_list

/obj/machinery/drug_dispenser/stocked
	reagent_volumes = list(
		/decl/material/liquid/nanoblood/saline = 80000,
		/decl/material/liquid/adrenaline = 117,
		/decl/material/liquid/noradrenaline = 174,
		/decl/material/liquid/atropine = 47,
		/decl/material/liquid/antibiotics/penicillin = 296,
		/decl/material/liquid/antibiotics/amicile = 102,
		/decl/material/liquid/antibiotics/ceftriaxone = 82,
		/decl/material/liquid/opium/morphine = 144,
		/decl/material/liquid/opium/fentanyl = 63.1,
		/decl/material/liquid/opium = 800,
		/decl/material/liquid/ethanol = 720,
		/decl/material/liquid/nitroglycerin = 182,
		/decl/material/liquid/potassium_iodide = 409,
		/decl/material/liquid/pentenate_calcium_trisodium = 45,
		/decl/material/liquid/propofol = 880,
		/decl/material/liquid/suxamethonium = 34,
		/decl/material/liquid/heparin = 94,
		/decl/material/liquid/adenosine = 56,
		/decl/material/liquid/dopamine = 83,
		/decl/material/liquid/metoclopramide = 146,
		/decl/material/liquid/naloxone = 42,
		/decl/material/liquid/dronedarone = 33,
		/decl/material/solid/betapace = 96,
		/decl/material/liquid/nutriment/glucose = 130
	)