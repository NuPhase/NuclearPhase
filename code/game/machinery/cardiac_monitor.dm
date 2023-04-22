/obj/machinery/cardiac_monitor
	name = "\improper cardiac monitor"
	icon = 'icons/obj/medicine.dmi'
	icon_state = "mon"
	use_power = POWER_USE_IDLE
	anchored = 0
	density = 0
	var/mob/living/carbon/human/attached

/obj/machinery/cardiac_monitor/MouseDrop(mob/living/carbon/human/over_object, src_location, over_location)
	. = ..()
	if(!Adjacent(over_object))
		return

	if(attached)
		visible_message("\The [attached] is taken off \the [src]")
		attached = null
	else if(over_object)
		if(!ishuman(over_object))
			return
		if(!do_after(usr, 30, over_object))
			return
		visible_message("\The [usr] connects \the [over_object] up to \the [src].")
		attached = over_object
		START_PROCESSING(SSobj, src)

	update_icon()

/obj/machinery/cardiac_monitor/Destroy()
	STOP_PROCESSING(SSobj, src)
	attached = null
	. = ..()

/obj/machinery/cardiac_monitor/on_update_icon()
	overlays.Cut()
	if(use_power == POWER_USE_OFF)
		icon_state = "mon"
		return
	if(!attached)
		icon_state = "mon-on"
		return
	icon_state = "mon-active"
	var/obj/item/organ/internal/heart/H = attached.get_organ(BP_HEART, /obj/item/organ/internal/heart)

	if(!H)
		icon_state = "mon-Asystole"
		return

	if(H.pulse)
		icon_state = "mon-Sinus rhythm"
	else
		icon_state = "mon-Asystole"

	if(attached.meanpressure < BLOOD_PRESSURE_L2BAD || attached.meanpressure > BLOOD_PRESSURE_H2BAD)
		overlays += image(icon, "mon-y")
	if(H.pulse > 120)
		overlays += image(icon, "mon-r")
	if(attached.get_blood_perfusion() < 0.7)
		overlays += image(icon, "mon-c")
	else
		overlays += image(icon, "mon-ox")

/obj/machinery/cardiac_monitor/Process()
	if(!attached)
		return PROCESS_KILL
	if(!Adjacent(attached))
		attached = null
		update_icon()
		return PROCESS_KILL
	update_icon()

/obj/machinery/cardiac_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/obj/item/organ/internal/heart/H = attached?.get_organ(BP_HEART, /obj/item/organ/internal/heart)
	if(!attached || !H)
		return

	var/list/data = list()
	data["name"] = "[attached]"
	data["hr"] = round(H.pulse)
	data["rythme"] = H.get_rhythm_fluffy()
	data["bp"] = attached.get_blood_pressure_fluffy()
	switch(attached.meanpressure)
		if(-INFINITY to BLOOD_PRESSURE_L2BAD)
			data["bp_s"] = "bad"
		if(BLOOD_PRESSURE_L2BAD to BLOOD_PRESSURE_NORMAL - 30)
			data["bp_s"] = "average"
		if(BLOOD_PRESSURE_HBAD to BLOOD_PRESSURE_H2BAD)
			data["bp_s"] = "average"
		if(BLOOD_PRESSURE_H2BAD to INFINITY)
			data["bp_s"] = "bad"

	switch(attached.get_blood_perfusion())
		if(0 to 0.6)
			data["perfusion_s"] = "bad"
		if(0.6 to 0.8)
			data["perfusion_s"] = "average"
	data["ischemia"] = H.oxygen_deprivation
	data["saturation"] = round(attached.get_blood_saturation() * 100)
	data["perfusion"] = round(attached.get_blood_perfusion() * 100)
	data["status"] = (attached.stat == CONSCIOUS) ? "RESPONSIVE" : "UNRESPONSIVE"

	data["ecg"] = list()
/*
	var/obj/item/organ/internal/brain/brain = attached.get_organ(BP_BRAIN, /obj/item/organ/internal/brain)
	if(attached.stat == DEAD || !brain)
		data["ecg"] += list("Neurological activity not present")
	else
		data["ecg"] += list("Neurological system activity: [100 - round(100 * CLAMP01(brain.damage / brain.max_damage))]% of normal.")
*/
	if(H.oxygen_deprivation)
		data["ecg"] += list("Ischemia: [H.oxygen_deprivation]%")
	data["ecg"] += list("TPVR: [round(attached.tpvr)] N·s·m<sup><small>-5</small></sup>")
	data["ecg"] += list("MCV: [round(attached.mcv)/1000] L/m")

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "cardiac_monitor.tmpl", "Cardiac Monitor", 450, 270)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/obj/machinery/cardiac_monitor/attack_hand(mob/user)
	. = ..()
	ui_interact(user)

/obj/machinery/cardiac_monitor/examine(mob/user)
	. = ..()
	ui_interact(user)