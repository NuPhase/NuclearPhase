/datum/composite_sound/pulse_monitor
	mid_sounds = list('sound/machines/heart_monitor/beep.wav'=1)
	mid_length = 10
	volume = 15
	sfalloff = 1
	distance = -3

/datum/composite_sound/alarm_monitor
	mid_sounds = list('sound/machines/heart_monitor/alarm1.wav'=1)
	mid_length = 24
	volume = 60
	sfalloff = 1
	distance = -1

/obj/machinery/cardiac_monitor/verb/toggle_alarms()
	set name = "Toggle Alarms"
	set category = "Object"
	set src in view(1)

	alarms_active = !alarms_active
	if(alarms_active)
		visible_message(SPAN_NOTICE("[usr] switches on the alarms on \the [src]."))
	else
		visible_message(SPAN_WARNING("[usr] switches off the alarms on \the [src]."))

/obj/machinery/cardiac_monitor
	name = "\improper cardiac monitor"
	icon = 'icons/obj/medicine.dmi'
	icon_state = "mon"
	use_power = POWER_USE_IDLE
	anchored = 0
	density = 0
	interact_offline = TRUE
	var/mob/living/carbon/human/attached
	var/datum/composite_sound/pulse_monitor/pulse_loop = null
	var/datum/composite_sound/alarm_monitor/alarm_loop = null
	var/alarms_active = TRUE

/obj/machinery/cardiac_monitor/MouseDrop(mob/living/carbon/human/over_object, src_location, over_location)
	. = ..()
	if(!Adjacent(over_object))
		return

	if(attached)
		visible_message("\The [attached] is taken off \the [src]")
		attached = null
		playsound(src, 'sound/machines/heart_monitor/off.wav', 50, 0)
		QDEL_NULL(pulse_loop)
		QDEL_NULL(alarm_loop)
	else if(over_object)
		if(!ishuman(over_object))
			return
		if(!do_after(usr, 30, over_object))
			return
		visible_message("\The [usr] connects \the [over_object] up to \the [src].")
		attached = over_object
		START_PROCESSING(SSobj, src)
		playsound(src, 'sound/machines/heart_monitor/on.wav', 50, 0)
		pulse_loop = new(list(src), FALSE)
		spawn(15)
			pulse_loop.sound_loop()

	update_icon()

/obj/machinery/cardiac_monitor/Destroy()
	STOP_PROCESSING(SSobj, src)
	attached = null
	qdel(pulse_loop)
	qdel(alarm_loop)
	. = ..()

/obj/machinery/cardiac_monitor/on_update_icon()
	overlays.Cut()
	var/should_alarm = FALSE
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
		should_alarm = TRUE
		icon_state = "mon-Asystole"

	if(attached.meanpressure < BLOOD_PRESSURE_L2BAD || attached.meanpressure > BLOOD_PRESSURE_H2BAD)
		overlays += image(icon, "mon-y")
		should_alarm = TRUE
	if(H.pulse > 120)
		overlays += image(icon, "mon-r")
	if(attached.get_blood_perfusion() < 0.7)
		overlays += image(icon, "mon-c")
		should_alarm = TRUE
	else
		overlays += image(icon, "mon-ox")

	if(should_alarm && alarms_active)
		if(!alarm_loop)
			alarm_loop = new(list(src), TRUE)
	else
		QDEL_NULL(alarm_loop)

/obj/machinery/cardiac_monitor/Process()
	if(!attached)
		return PROCESS_KILL
	if(!Adjacent(attached))
		attached = null
		update_icon()
		QDEL_NULL(pulse_loop)
		QDEL_NULL(alarm_loop)
		playsound(src, 'sound/machines/heart_monitor/off.wav', 50, 0)
		visible_message(SPAN_WARNING("\The [src] announces: \"ECG electrodes disconnected!\""))
		return PROCESS_KILL
	update_icon()
	var/obj/item/organ/internal/heart/H = attached?.get_organ(BP_HEART, /obj/item/organ/internal/heart)
	var/datum/timedevent/timer = gettimer(pulse_loop.timerid, SStimer)
	if(H.pulse)
		var/cur_pulse = min(180, H.pulse)
		timer.wait = 60 / cur_pulse * 10
	else
		timer.wait = 10000 //kinda bad

/obj/machinery/cardiac_monitor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CardiacMonitor", "ECG Monitor")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/machinery/cardiac_monitor/tgui_data(mob/user)
	if(!attached)
		return

	var/obj/item/organ/internal/heart/H = attached.get_organ(BP_HEART, /obj/item/organ/internal/heart)
	var/obj/item/organ/internal/lungs/L = attached.get_organ(BP_LUNGS, /obj/item/organ/internal/lungs)

	return list(
		"name" = "[attached]",
		"status" = (attached.stat == CONSCIOUS) ? "RESPONSIVE" : "UNRESPONSIVE",
		"pulse" = H.pulse,
		"pressure" = "[round(attached.syspressure)]/[round(attached.dyspressure)]",
		"saturation" = round(attached.get_blood_saturation() * 100),
		"rhythm" = H.get_rhythm_fluffy(),
		"breath_rate" = round(L.breath_rate + rand(-1, 1), 1),
		"tpvr" = round(attached.tpvr),
		"mcv" = round(attached.mcv)/1000
	)

/obj/machinery/cardiac_monitor/attack_hand(mob/user)
	. = ..()
	tgui_interact(user)

/obj/machinery/cardiac_monitor/examine(mob/user)
	. = ..()
	tgui_interact(user)