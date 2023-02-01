/mob/living/carbon/human/proc/debug_medicine(mob/user)
	to_chat(user, "Debugging [src]...")
	spawn(10)
	to_chat(user, "Heart Rate: [bpm]")
	to_chat(user, "MCV: [mcv]")
	to_chat(user, "TPVR: [tpvr]")
	to_chat(user, "Blood Pressure: ([syspressure]/[dyspressure])")
	to_chat(user, "Oxygen Amount: ([oxygen_amount]/[max_oxygen_capacity])ml")
	return
