/decl/aspect/perk
	aspect_flags = ASPECTS_PHYSICAL

/decl/aspect/perk/positive
	category = "Perks - Positive"
	aspect_cost = 1

/decl/aspect/perk/negative
	category = "Perks - Negative"
	aspect_cost = -1

/decl/aspect/perk/neutral
	category = "Perks - Neutral"
	aspect_cost = 0


/decl/aspect/perk/negative/heliophobia
	name = "Heliophobia"
	desc = "You fear light."

/decl/aspect/perk/neutral/astraphobia
	name = "Astraphobia"
	desc = "You fear bad weather. And space."

/decl/aspect/perk/neutral/astraphobia/apply(mob/living/carbon/human/holder)
	. = ..()
	holder.add_mood(/datum/mood/astraphobia)

/decl/aspect/perk/negative/gourmand
	name = "Gourmand"
	desc = "You love food. You crave food. Food."

/decl/aspect/perk/negative/hydro_homie
	name = "Hydro Homie"
	desc = "You can't live without water."

/decl/aspect/perk/positive/believer
	name = "Believer"
	desc = "Your prayers are more likely to be answered. Holy water heals you a little."
	aspect_cost = 2

/decl/aspect/perk/negative/asthmatic
	name = "Asthmatic"
	desc = "Your lungs are weak. You ocasionally have asthmatic attacks."
	aspect_cost = -3

/decl/aspect/perk/negative/smoke_intolerance
	name = "Smoke Intolerance"
	desc = "You absolutely hate when people smoke."
	aspect_cost = -2

/decl/aspect/perk/negative/addiction
	name = "Random Addiction"
	desc = "You are addicted to something."

/decl/aspect/perk/negative/addiction/nicotine
	name = "Nicotine Addiction"
	desc = "You are addicted to nicotine."

/decl/aspect/perk/negative/addiction/caffeine
	name = "Caffeine Addiction"
	desc = "You are addicted to caffeine."

/decl/aspect/perk/negative/addiction/opioid
	name = "Opioid Addiction"
	desc = "You are addicted to opioids."
	aspect_cost = -2

/decl/aspect/perk/neutral/engineer_master
	name = "Master Engineer"
	desc = "You are very vocal about your skill with machinery."

/decl/aspect/perk/negative/heart_problem
	name = "Weak Heart"
	desc = "Your heart is weak."
	aspect_cost = -2

/decl/aspect/perk/negative/heart_failure
	name = "Heart Failure"
	desc = "Your heart is barely functioning. You might need a transplant or intense treatment. You carry Amiodarone pills with you at all times."
	aspect_cost = -5