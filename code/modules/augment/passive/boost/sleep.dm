/obj/item/organ/internal/augment/boost/sleep_processor
	name = "memory processor"
	desc = "A sophisticated data processing suite made to completely diminish the need for sleep in a user."
	buffs = list(SKILL_LITERACY = 1)
	injury_debuffs = list(SKILL_LITERACY = -1)
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE
	)
	origin_tech = "{'materials':2,'magnets':3,'programming':5,'biotech':2}"

/obj/item/organ/internal/augment/boost/sleep_processor/buff()
	if((. = ..()))
		to_chat(owner, SPAN_NOTICE("Notice: Memory processing online. You do not need to sleep anymore."))

/obj/item/organ/internal/augment/boost/sleep_processor/debuff()
	if((. = ..()))
		to_chat(owner, SPAN_WARNING("E%r00r: dAmage detect-ted to cerebral memory."))