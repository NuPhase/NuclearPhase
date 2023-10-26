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

/obj/machinery/cardiac_monitor/verb/configure()
	set name = "Configure"
	set category = "Object"
	set src in view(1)

	var/list/to_turn_on = tgui_input_checkboxes(usr, "Select which alarm should be turned on.", "Alarm Config", list("Metronome", "High/Low BP", "High/Low HR", "Low SAT", "AutoECG"), 0)
	if(!to_turn_on)
		return
	if("Metronome" in to_turn_on)
		metronome = TRUE
		if(!pulse_loop)
			pulse_loop = new(list(src), FALSE)
			spawn(15)
				pulse_loop.sound_loop()
	else
		metronome = FALSE
		QDEL_NULL(pulse_loop)
	if("High/Low BP" in to_turn_on)
		bp_alarm = TRUE
	else
		bp_alarm = FALSE
	if("High/Low HR" in to_turn_on)
		hr_alarm = TRUE
	else
		hr_alarm = FALSE
	if("Low SAT" in to_turn_on)
		ox_alarm = TRUE
	else
		ox_alarm = FALSE
	if("AutoECG" in to_turn_on)
		ecg_alarm = TRUE
	else
		ecg_alarm = FALSE

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

	var/metronome = TRUE
	var/bp_alarm = TRUE
	var/hr_alarm = TRUE
	var/ox_alarm = TRUE
	var/ecg_alarm = FALSE

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
		if(metronome)
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
		icon_state = "mon-Asystole"

	if(length(H.arrythmias))
		if(ecg_alarm)
			should_alarm = TRUE

	if(attached.meanpressure < BLOOD_PRESSURE_L2BAD || attached.meanpressure > BLOOD_PRESSURE_H2BAD)
		overlays += image(icon, "mon-y")
		if(bp_alarm)
			should_alarm = TRUE

	if(H.pulse > 120)
		overlays += image(icon, "mon-r")

	if(attached.get_blood_saturation() < 0.75)
		overlays += image(icon, "mon-c")
		if(ox_alarm)
			should_alarm = TRUE
	else
		overlays += image(icon, "mon-ox")

	if(should_alarm)
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
	if(metronome)
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
		"pulse" = round(H.pulse, 1),
		"pressure" = "[round(attached.syspressure)]/[round(attached.dyspressure)]",
		"saturation" = round(attached.get_blood_saturation() * 100),
		"rhythm" = H.get_rhythm_fluffy(),
		"breath_rate" = round(L.breath_rate, 1),
		"tpvr" = round(attached.tpvr),
		"mcv" = round(attached.mcv)/1000
	)

/obj/machinery/cardiac_monitor/attack_hand(mob/user)
	. = ..()
	tgui_interact(user)

/obj/machinery/cardiac_monitor/examine(mob/user)
	. = ..()
	tgui_interact(user)