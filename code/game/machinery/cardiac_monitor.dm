/datum/composite_sound/pulse_monitor
	mid_sounds = list('sound/machines/heart_monitor/beep.wav'=1)
	mid_length = 10
	volume = 15
	sfalloff = 1
	distance = -3

/datum/composite_sound/monitor_light_alarm
	mid_sounds = list('sound/machines/heart_monitor/light_alarm.mp3'=1)
	mid_length = 20
	volume = 50
	sfalloff = 1
	distance = -1

/datum/composite_sound/monitor_heavy_alarm
	mid_sounds = list('sound/machines/heart_monitor/heavy_alarm.mp3'=1)
	mid_length = 22
	volume = 60
	sfalloff = 1
	distance = -1

/obj/machinery/cardiac_monitor/verb/configure()
	set name = "Configure"
	set category = "Object"
	set src in view(1)

	var/list/to_turn_on = tgui_input_checkboxes(usr, "Select which alarm should be turned on.", "Alarm Config", list("Metronome"), 0)
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
	var/datum/composite_sound/monitor_light_alarm/light_alarm = null
	var/datum/composite_sound/monitor_heavy_alarm/heavy_alarm = null

	var/metronome = TRUE
	var/muted_until = 0

	//1 - light alarm, 2 - heavy alarm
	var/pulse_alarm = 0
	var/oxygen_alarm = 0
	var/pressure_alarm = 0
	var/breath_alarm = 0
	var/heart_alarm = 0 //arrythmias

	var/datum/beam/connection_beam

/obj/machinery/cardiac_monitor/MouseDrop(mob/living/carbon/human/over_object, src_location, over_location)
	. = ..()
	if(!Adjacent(over_object))
		return

	if(attached)
		visible_message("\The [attached] is taken off \the [src]")
		attached = null
		playsound(src, 'sound/machines/heart_monitor/off.wav', 50, 0)
		QDEL_NULL(pulse_loop)
		QDEL_NULL(light_alarm)
		QDEL_NULL(heavy_alarm)
		QDEL_NULL(connection_beam)
	else if(over_object)
		if(!ishuman(over_object))
			return
		if(!do_after(usr, 30, over_object))
			return
		if(attached)
			return
		visible_message("\The [usr] connects \the [over_object] up to \the [src].")
		attached = over_object
		START_PROCESSING(SSobj, src)
		playsound(src, 'sound/machines/heart_monitor/on.wav', 50, 0)
		connection_beam = Beam(attached, "1-full", time = INFINITY, beam_color = COLOR_GREEN_GRAY)
		if(metronome)
			pulse_loop = new(list(src), FALSE)
			spawn(15)
				pulse_loop.sound_loop()

	update_icon()

/obj/machinery/cardiac_monitor/Destroy()
	STOP_PROCESSING(SSobj, src)
	attached = null
	QDEL_NULL(light_alarm)
	QDEL_NULL(heavy_alarm)
	QDEL_NULL(connection_beam)
	. = ..()

/obj/machinery/cardiac_monitor/on_update_icon()
	cut_overlays()
	if(use_power == POWER_USE_OFF)
		icon_state = "mon"
		set_light(0)
		return
	if(!attached)
		icon_state = "mon-on"
		set_light(0)
		return
	set_light(l_range = 1, l_power = 0.8, l_color = "#daf9ff")
	add_overlay(emissive_overlay(icon, "mon-active"))
	var/obj/item/organ/internal/heart/H = attached.get_organ(BP_HEART, /obj/item/organ/internal/heart)
	var/obj/item/organ/internal/lungs/L = attached.get_organ(BP_LUNGS, /obj/item/organ/internal/lungs)

	if(!H)
		add_overlay(emissive_overlay(icon, "mon-r"))
		return

	if(H.pulse)
		var/has_shockable_rhythm = FALSE
		for(var/decl/arrythmia/cur_r in H.arrythmias)
			if(cur_r.can_be_shocked)
				has_shockable_rhythm = TRUE
				break
		if(has_shockable_rhythm)
			add_overlay(emissive_overlay(icon, "mon-Vfib"))
		else
			add_overlay(emissive_overlay(icon, "mon-Sinus rhythm"))
	else
		add_overlay(emissive_overlay(icon, "mon-Asystole"))

	if(length(H.arrythmias))
		heart_alarm = 1
		if((GET_DECL(/decl/arrythmia/ventricular_flaunt) in H.arrythmias) || (GET_DECL(/decl/arrythmia/ventricular_fibrillation) in H.arrythmias) || (GET_DECL(/decl/arrythmia/asystole) in H.arrythmias))
			heart_alarm = 2
	else
		heart_alarm = 0

	if(attached.meanpressure < BLOOD_PRESSURE_LBAD || attached.meanpressure > BLOOD_PRESSURE_HBAD)
		pressure_alarm = 1
		if(attached.meanpressure < BLOOD_PRESSURE_L2BAD || attached.meanpressure > BLOOD_PRESSURE_H2BAD)
			add_overlay(emissive_overlay(icon, "mon-y"))
			pressure_alarm = 2
	else
		pressure_alarm = 0

	if(H.pulse > BPM_HIGH || H.pulse < BPM_LOW)
		pulse_alarm = 1
		if(H.pulse > BPM_2HIGH || H.pulse < BPM_2LOW)
			pulse_alarm = 2
			add_overlay(emissive_overlay(icon, "mon-r"))
	else
		pulse_alarm = 0

	var/displayed_perfusion = CLAMP01(attached.get_blood_saturation() * attached.get_blood_perfusion())
	if(displayed_perfusion < 0.9)
		oxygen_alarm = 1
		if(displayed_perfusion < 0.7)
			oxygen_alarm = 2
			add_overlay(emissive_overlay(icon, "mon-c"))
	else
		add_overlay(emissive_overlay(icon, "mon-ox"))
		oxygen_alarm = 0

	if(L.breath_rate > 25 || L.breath_rate < 12)
		breath_alarm = 1
		if(L.breath_rate > 40 || L.breath_rate < 5)
			breath_alarm = 2
	else
		breath_alarm = 0

	var/do_heavy_alarm = pulse_alarm == 2 || oxygen_alarm == 2 || pressure_alarm == 2 || breath_alarm == 2 || heart_alarm == 2
	if(do_heavy_alarm && world.time > muted_until)
		if(!heavy_alarm)
			heavy_alarm = new(list(src), TRUE)
	else
		QDEL_NULL(heavy_alarm)

	var/do_light_alarm = pulse_alarm || oxygen_alarm || pressure_alarm || breath_alarm || heart_alarm
	if(do_light_alarm && world.time > muted_until)
		if(!light_alarm)
			light_alarm = new(list(src), TRUE)
	else
		QDEL_NULL(light_alarm)

/obj/machinery/cardiac_monitor/Process()
	if(!attached)
		return PROCESS_KILL
	if(!Adjacent(attached))
		attached = null
		update_icon()
		QDEL_NULL(pulse_loop)
		QDEL_NULL(light_alarm)
		QDEL_NULL(heavy_alarm)
		QDEL_NULL(connection_beam)
		playsound(src, 'sound/machines/heart_monitor/off.wav', 50, 0)
		visible_message(SPAN_WARNING("\The [src] announces: \"ECG electrodes disconnected!\""))
		return PROCESS_KILL
	update_icon()
	if(metronome)
		var/obj/item/organ/internal/heart/H = attached?.get_organ(BP_HEART, /obj/item/organ/internal/heart)
		var/datum/timedevent/timer = gettimer(pulse_loop.timerid, SStimer)
		if(!H)
			timer.wait = 10000 //kinda bad lol
			return
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

/obj/machinery/cardiac_monitor/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(action == "mute_alarms")
		muted_until = world.time + 1 MINUTE
		playsound(loc, "button", 30)

/obj/machinery/cardiac_monitor/tgui_static_data(mob/user)
	if(!attached)
		return
	return list("name" = "[attached]")

/obj/machinery/cardiac_monitor/tgui_data(mob/user)
	if(!attached)
		return

	var/obj/item/organ/internal/heart/H = attached.get_organ(BP_HEART, /obj/item/organ/internal/heart)
	var/obj/item/organ/internal/lungs/L = attached.get_organ(BP_LUNGS, /obj/item/organ/internal/lungs)

	var/list/data = list(
		"status" = (attached.stat == CONSCIOUS) ? "RESPONSIVE" : "UNRESPONSIVE",
		"systolic_pressure" = round(attached.syspressure),
		"diastolic_pressure" = round(attached.dyspressure),
		"mean_pressure" = round(attached.meanpressure),
		"tpvr" = round(attached.tpvr),
		"mcv" = round(attached.mcv)/1000,
		"pulse_alarm" = pulse_alarm,
		"oxygen_alarm" = oxygen_alarm,
		"pressure_alarm" = pressure_alarm,
		"breath_alarm" = breath_alarm,
		"heart_alarm" = heart_alarm,
		"muted" = world.time < muted_until
	)

	if(attached.mcv > 800)
		data["saturation"] = round(CLAMP01(attached.get_blood_saturation() * attached.get_blood_perfusion()) * 100)
	else
		data["saturation"] = 0

	if(H)
		if(H.pulse > 310)
			data["pulse"] = 0
		else
			data["pulse"] = round(H.pulse, 1)
		data["rhythm"] = H.get_rhythm_fluffy()
	else
		data["pulse"] = 0
		data["rhythm"] = "NO HEART"

	if(L)
		data["breath_rate"] = round(L.breath_rate, 1)
	else
		data["breath_rate"] = 0

	return data

/obj/machinery/cardiac_monitor/attack_hand(mob/user)
	. = ..()
	tgui_interact(user)

/obj/machinery/cardiac_monitor/examine(mob/user)
	. = ..()
	tgui_interact(user)