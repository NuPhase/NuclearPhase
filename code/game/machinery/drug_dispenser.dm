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
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE
	atmos_canpass = CANPASS_NEVER
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES
	var/list/reagent_volumes = list() // /decl/material = amount

	var/vials_in_storage = 25
	var/syringes_in_storage = 10
	var/iv_packs_in_storage = 4

/obj/machinery/drug_dispenser/physical_attack_hand(user)
	tgui_interact(user)

/obj/machinery/lung_ventilator/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DrugDispenser", "Drug Dispenser")
		ui.open()

/obj/machinery/drug_dispenser/tgui_data(mob/user)
	return list("reagent_list" = assemble_reagent_list(),
				"vial_available" = vials_in_storage > 0,
				"syringe_available" = syringes_in_storage > 0,
				"iv_pack_available" = iv_packs_in_storage > 0)

/obj/machinery/drug_dispenser/proc/assemble_reagent_list()
	var/list/reagent_list = list()
	for(var/mat_type in reagent_volumes)
		var/decl/material/mat = GET_DECL(mat_type)
		reagent_list += list(list("name" = mat.name, "category" = mat.drug_category, "amount" = reagent_volumes[mat_type]))
	return reagent_list