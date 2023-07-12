/decl/blood_analysis
	var/name
	var/description
	var/time = 5 SECONDS

/decl/blood_analysis/proc/return_analysis(var/mob/living/carbon/human/H)
	return ""

/decl/blood_analysis/potassium
	name = "Potassium|Proteins"

/decl/blood_analysis/potassium/return_analysis(var/mob/living/carbon/human/H)
	var/list/text = ""
	text += "Analysis #[rand(1, 999)] for [name]<br>"
	text += "Potassium: [round(H.bloodstr.has_reagent(/decl/material/solid/potassium), 0.1)] (1-3)<br>"
	text += "Proteins: [round(rand(9, 11) + H.getToxLoss(), 0.1)] (5-17)<br>"
	return jointext(text, "<br>")



/obj/machinery/blood_analysis
	name = "blood analyser"
	desc = "Analyzes centrifuged blood. Needs a vial in it to work."
	idle_power_usage = 50
	active_power_usage = 2100
	core_skill = SKILL_MEDICAL