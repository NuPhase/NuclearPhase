/mob/living/carbon/human
	var/hunger_mes_cooldown = 0
	var/list/adrenaline_messages = list(
	"YOU'VE GOTTA RUN!",
	"DO SOMETHING!",
	"SAVE YOUR LIFE!",
	"ESCAPE!"
)
/mob/living/carbon/human/proc/release_adrenaline(amount = 1, make_message = FALSE)
	if(adrenaline_cooldown)
		return
	bloodstr.add_reagent_max(/decl/material/liquid/adrenaline, amount, 0.5)
	if(make_message && amount > 2)
		to_chat(src, SPAN_DANGER(pick(adrenaline_messages)))
	adrenaline_cooldown = TRUE
	spawn(amount * 20)
		adrenaline_cooldown = FALSE

//<150 - general hunger
//<100 - starvation mode
//<50 - organ failure

/mob/living/carbon/human/proc/handle_nutrition()
	var/message
	var/cooldown = 50

	switch(nutrition)
		if(100 to 150)
			cooldown = 300
			message = pick(
				"You feel a little bit hungry.",
				"You feel slightly lightheaded.",
				"Maybe it's time to eat something?",
				"Your stomach feels empty.",
				"It'd be nice to have a lunch.")
		if(50 to 100) // Хочу жрать сука!!!
			var/obj/item/organ/internal/heart/cur_heart = GET_INTERNAL_ORGAN(src, BP_HEART)
			cooldown = 200
			message = pick( //АЭЭЭ ДУМАТЬ ПРИХОДИТСЯ
				"Your stomach feels weak.",
				"You're very hungry.",
				"You feel tired, maybe it's time to eat something?",
				"Your stomach cramps in hunger.",
				"You want to eat something.")
			cur_heart.bpm_modifiers["Starvation Mode"] = rand(20, 30)
			vessel.remove_any(1) //anemia
		if(0 to 50)
			var/obj/item/organ/internal/heart/cur_heart = GET_INTERNAL_ORGAN(src, BP_HEART)
			cooldown = 100
			message = pick(
				"You REALLY want to eat something!",
				"Your stomach is in pain!",
				"You crave food!",
				"You have to eat!",
				"You feel your body dying of hunger!")
			vessel.remove_any(2) //anemia
			cur_heart.bpm_modifiers["Starvation"] = rand(30, 40)
			add_chemical_effect(CE_PRESSURE, -30)
			var/datum/reagents/ingested = get_ingested_reagents()
			if(ingested.has_reagent(/decl/material/liquid/nutriment, 15) && !ingested.has_reagent(/decl/material/liquid/electrolytes, 0.1)) //refeeding syndrome
				cur_heart.stability_modifiers["Refeeding Syndrome"] = -25
				cur_heart.bpm_modifiers["Refeeding Syndrome"] = -60
				add_chemical_effect(CE_PRESSURE, -50)

	if(message && world.time > hunger_mes_cooldown)
		to_chat(src, SPAN_WARNING(message))
		hunger_mes_cooldown = world.time + cooldown