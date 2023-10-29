/obj/machinery/lung_ventilator
	name = "lung ventilator"
	desc = "A complex device made for providing oxygen and anaesthesia to a patient in ICU."
	icon = 'icons/obj/structures/iv_drip.dmi'
	icon_state = "ecmo-off"
	density = 1
	active_power_usage = 400
	var/mob/living/carbon/human/connected = null

	var/obj/item/tank/emergency/oxygen/medical/mixture_holder
	var/obj/item/clothing/mask/breath/medical/contained
	var/pressure_o2 = 29
	var/pressure_n2 = 72
	var/pressure_n2o = 0
	var/operating = FALSE //whether we even send gas down the pipe
	var/pumping = FALSE //whether we force air into the patient's lungs
	var/pump_rate = 15

/obj/machinery/lung_ventilator/Initialize()
	. = ..()
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	mixture_holder = new
	mixture_holder.air_contents.volume = STD_BREATH_VOLUME * 15
	mixture_holder.air_contents.remove(mixture_holder.air_contents.total_moles)
	contained = new

/obj/machinery/lung_ventilator/examine(mob/user)
	. = ..()
	if(connected)
		to_chat(user, SPAN_NOTICE("[src] is connected to [connected]."))

/obj/machinery/lung_ventilator/physical_attack_hand(mob/user)
	tgui_interact(user)
	return TRUE

/obj/machinery/lung_ventilator/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LungVentilator", "Lung Ventilator")
		ui.open()
		ui.set_autoupdate(1)

/obj/machinery/lung_ventilator/tgui_data(mob/user)
	var/total_pressure = pressure_o2 + pressure_n2 + pressure_n2o
	var/list/data = list(
		"pressure_o2" = pressure_o2,
		"pressure_n2" = pressure_n2,
		"pressure_n2o" = pressure_n2o,
		"pressure_total" = total_pressure,
		"isPumping" = pumping,
		"isWorking" = operating,
		"pump_rate" = pump_rate
	)
	return data

/obj/machinery/lung_ventilator/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("toggle")
			operating = !operating
			if(!operating)
				visible_message(SPAN_WARNING("[src] shuts down."))
				pumping = FALSE
				icon_state = "ecmo-off"
				connected.internal = null
			else
				icon_state = "ecmo-on"
				set_internals(connected)
			return TRUE
		if("ventilation")
			if(!operating)
				return FALSE
			pumping = !pumping
			if(!pumping)
				visible_message(SPAN_WARNING("[src]'s pumps slowly come to a stop."))
			else
				visible_message(SPAN_NOTICE("[src]'s pumps spool up."))
			return TRUE
		if("change_o2")
			pressure_o2 = params["entry"]
			return TRUE
		if("change_n2")
			pressure_n2 = params["entry"]
			return TRUE
		if("change_n2o")
			pressure_n2o = params["entry"]
			return TRUE
		if("change_pump_rate")
			pump_rate = params["entry"]
			return TRUE

/obj/machinery/lung_ventilator/proc/can_apply_to_target(var/mob/living/carbon/human/target, mob/user)
	if(!user)
		user = target
	// Check target validity
	if(!GET_EXTERNAL_ORGAN(target, BP_HEAD))
		to_chat(user, "<span class='warning'>\The [target] doesn't have a head.</span>")
		return
	if(!target.check_has_mouth())
		to_chat(user, "<span class='warning'>\The [target] doesn't have a mouth.</span>")
		return

	var/obj/item/mask = target.get_equipped_item(slot_wear_mask_str)
	if(mask && target != connected)
		to_chat(user, "<span class='warning'>\The [target] is already wearing a mask.</span>")
		return
	var/obj/item/head = target.get_equipped_item(slot_head_str)
	if(head && (head.body_parts_covered & SLOT_FACE))
		to_chat(user, "<span class='warning'>Remove their [head] first.</span>")
		return
	if(!Adjacent(target))
		to_chat(user, "<span class='warning'>Please stay close to \the [src].</span>")
		return
	//when there is a breather:
	if(connected)
		to_chat(user, "<span class='warning'>\The pump is already in use.</span>")
		return
	//Checking if breather is still valid
	mask = target.get_equipped_item(slot_wear_mask_str)
	if(target == connected && (!mask || mask != contained))
		to_chat(user, "<span class='warning'>\The [target] is not using the supplied mask.</span>")
		return
	return 1

/obj/machinery/lung_ventilator/proc/disconnect(var/forceful = FALSE)
	if(!forceful)
		visible_message(SPAN_NOTICE("The [src]'s mask slips back into its storage."))
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	mixture_holder.forceMove(src)
	connected.drop_from_inventory(contained, src)
	connected = null

/obj/machinery/lung_ventilator/proc/connect(mob/living/carbon/human/to_connect, mob/user)
	connected = to_connect
	visible_message(SPAN_NOTICE("[connected] gets connected to the [src]."))
	contained.dropInto(connected.loc)
	connected.equip_to_slot(contained, slot_wear_mask_str)
	mixture_holder.forceMove(connected)
	if(operating)
		set_internals(connected)
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/lung_ventilator/handle_mouse_drop(atom/over, mob/user)
	if(connected)
		disconnect(FALSE)
		return TRUE
	if(ishuman(over) && can_apply_to_target(over, user))
		connect(over, user)
		return TRUE
	. = ..()

/obj/machinery/lung_ventilator/proc/MolesForPressure(var/target_pressure = ONE_ATMOSPHERE)
	return (target_pressure * mixture_holder.air_contents.volume) / (R_IDEAL_GAS_EQUATION * T20C)

/obj/machinery/lung_ventilator/proc/set_internals(var/mob/living/carbon/C)
	if(C && istype(C))
		if(!C.internal && mixture_holder)
			connected.set_internals(mixture_holder)

/obj/machinery/lung_ventilator/Process()
	if(operating)
		mixture_holder.air_contents.remove(mixture_holder.air_contents.total_moles)
		if(pressure_o2)
			mixture_holder.air_contents.adjust_gas(/decl/material/gas/oxygen, MolesForPressure(pressure_o2))
		if(pressure_n2)
			mixture_holder.air_contents.adjust_gas(/decl/material/gas/nitrogen, MolesForPressure(pressure_n2))
		if(pressure_n2o)
			mixture_holder.air_contents.adjust_gas(/decl/material/gas/nitrous_oxide, MolesForPressure(pressure_n2o))
		if(pumping && connected)
			var/obj/item/organ/internal/lungs/L = GET_INTERNAL_ORGAN(connected, BP_LUNGS)
			if(!L)
				return
			L.handle_breath(mixture_holder.air_contents, 1, pump_rate)
