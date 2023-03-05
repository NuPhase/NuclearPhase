/datum/reagent/macro
	var/energy_value = 0
	var/density = 0

/datum/reagent/macro/carbohydrate
/datum/reagent/macro/fat
/datum/reagent/macro/protein

var/list/adrenaline_messages = list(
	"YOU'VE GOTTA RUN!",
	"DO SOMETHING!",
	"SAVE YOUR LIFE!",
	"ESCAPE!",
	"YOU HAVE NO TIME, RUN!"
)
/mob/living/carbon/human/proc/release_adrenaline(amount = 1, make_message = FALSE)
	if(adrenaline_cooldown)
		return
	bloodstr.add_reagent(/decl/material/liquid/adrenaline, amount)
	if(make_message && amount > 5)
		to_chat(src, SPAN_DANGER(pick(adrenaline_messages)))
	adrenaline_cooldown = TRUE
	spawn(amount * 10)
		adrenaline_cooldown = FALSE