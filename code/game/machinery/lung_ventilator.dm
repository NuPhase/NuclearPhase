/obj/machinery/medical/lung_ventilator
	name = "lung ventilator"
	desc = "A complex device made for providing oxygen and anaesthesia to a patient in ICU."
	icon = 'icons/obj/structures/iv_drip.dmi'
	icon_state = "vent-off"
	active_power_usage = 400

	required_skill_type = SKILL_MEDICAL
	required_skill_level = SKILL_BASIC
	connection_time = 10 SECONDS

	var/obj/item/tank/emergency/oxygen/medical/mixture_holder
	var/obj/item/clothing/mask/breath/medical/contained
	var/pressure_o2 = 29
	var/pressure_n2 = 72
	var/pressure_n2o = 0
	var/operating = FALSE //whether we even send gas down the pipe
	var/pumping = FALSE //whether we force air into the patient's lungs
	var/pump_rate = 15

/obj/machinery/medical/lung_ventilator/Initialize()
	. = ..()
	mixture_holder = new
	mixture_holder.air_contents.volume = STD_BREATH_VOLUME * 15
	mixture_holder.air_contents.remove(mixture_holder.air_contents.total_moles)
	contained = new

/obj/machinery/medical/lung_ventilator/physical_attack_hand(mob/user)
	tgui_interact(user)
	return TRUE

/obj/machinery/medical/lung_ventilator/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LungVentilator", "Lung Ventilator")
		ui.open()
		ui.set_autoupdate(1)

/obj/machinery/medical/lung_ventilator/tgui_data(mob/user)
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

/obj/machinery/medical/lung_ventilator/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("toggle")
			operating = !operating
			if(!operating)
				visible_message(SPAN_WARNING("[src] shuts down."))
				pumping = FALSE
				icon_state = "vent-off"
				connected.internal = null
			else
				icon_state = "vent-on"
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

/obj/machinery/medical/lung_ventilator/can_connect(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!GET_EXTERNAL_ORGAN(target, BP_HEAD))
		return "\The [target] doesn't have a head."
	if(!target.check_has_mouth())
		return "\The [target] doesn't have a mouth."

	var/obj/item/mask = target.get_equipped_item(slot_wear_mask_str)
	if(mask && target != connected)
		return "\The [target] is already wearing a mask."
	var/obj/item/head = target.get_equipped_item(slot_head_str)
	if(head && (head.body_parts_covered & SLOT_FACE))
		return "Remove their [head] first."

	mask = target.get_equipped_item(slot_wear_mask_str)
	if(target == connected && (!mask || mask != contained))
		return "\The [target] is not using the supplied mask."
	return ..()

/obj/machinery/medical/lung_ventilator/disconnect(mob/living/carbon/human/user)
	mixture_holder.forceMove(src)
	connected.drop_from_inventory(contained, src)
	. = ..()

/obj/machinery/medical/lung_ventilator/connect(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	contained.dropInto(connected.loc)
	connected.equip_to_slot(contained, slot_wear_mask_str)
	mixture_holder.forceMove(connected)
	if(operating)
		set_internals(connected)

/obj/machinery/medical/lung_ventilator/proc/MolesForPressure(var/target_pressure = ONE_ATMOSPHERE)
	return (target_pressure * mixture_holder.air_contents.volume) / (R_IDEAL_GAS_EQUATION * T20C)

/obj/machinery/medical/lung_ventilator/proc/set_internals(var/mob/living/carbon/C)
	if(C && istype(C))
		if(!C.internal && mixture_holder)
			connected.set_internals(mixture_holder)

/obj/machinery/medical/lung_ventilator/Process()
	if(operating)
		mixture_holder.air_contents.remove(mixture_holder.air_contents.total_moles)
		if(pressure_o2)
			mixture_holder.air_contents.adjust_gas(/decl/material/gas/oxygen, MolesForPressure(pressure_o2))
		if(pressure_n2)
			mixture_holder.air_contents.adjust_gas(/decl/material/gas/nitrogen, MolesForPressure(pressure_n2))
		if(pressure_n2o)
			mixture_holder.air_contents.adjust_gas(/decl/material/gas/nitrous_oxide, MolesForPressure(pressure_n2o))
		if(pumping && connected)
			playsound(src, 'sound/machines/pump.ogg', 25)
			var/obj/item/organ/internal/lungs/L = GET_INTERNAL_ORGAN(connected, BP_LUNGS)
			if(!L)
				return
			L.handle_breath(mixture_holder.air_contents, 1, pump_rate)
