/mob/living/carbon/human/proc/debug_medicine(user)
	to_chat(user, "------------------------------------------")
	var/obj/item/organ/internal/heart/H = GET_INTERNAL_ORGAN(src, BP_HEART)
	if(H)
		to_chat(user, "Heart Rate: [round(bpm)]")
		to_chat(user, "Heart Instability: [H.instability]")
		to_chat(user, "Heart CO: [H.cardiac_output * 100]%")
	else
		to_chat(user, "No heart.")
	to_chat(user, "MCV: [mcv] ([round(bpm)] * [round(get_stroke_volume())])")
	to_chat(user, "TPVR: [tpvr]")
	to_chat(user, "Blood Pressure: ([syspressure]/[dyspressure]) MAP: [meanpressure]")
	to_chat(user, "Blood Saturation: [get_blood_saturation() * 100]%")
	to_chat(user, "Blood Perfusion: [get_blood_perfusion() * 100]%")
	to_chat(user, "Blood Volume: [get_blood_volume_hemo() * 100]%")
	to_chat(user, "------------------------------------------")
	return

/mob/living/carbon/human/proc/write_hemo_log()
	if(!real_name || real_name == "unknown")
		return
	var/obj/item/organ/internal/heart/H = GET_INTERNAL_ORGAN(src, BP_HEART)
	var/our_file = file("[global.log_directory]/hemo_logs/[real_name].log")
	to_file(our_file, "\
	BPM: [round(bpm)]\t\
	SYS/DYS(MAP): [round(syspressure)]/[round(dyspressure)]([round(meanpressure)])\t\
	SAT/PERF: [round(oxygen_amount / normal_oxygen_capacity, 0.01)]/[round(blood_perfusion, 0.01)]\t\
	TPVR: [round(tpvr)]\t\
	MCV: [round(mcv)]\t\
	SV: [round(get_stroke_volume())]\t\
	INST: [round(H.instability)]")