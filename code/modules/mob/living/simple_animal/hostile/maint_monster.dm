/mob/living/simple_animal/hostile/maint_monster // женщина
	name = "maintenance monster"
	desc = "What the hell is this?"
	icon = 'icons/mob/simple_animal/faithless.dmi'
	speak_chance = 0
	speed = 5
	move_to_delay = 2
	maxHealth = 300
	health = 300

	harm_intent_damage = 30
	natural_weapon = /obj/item/natural_weapon/giant

	min_gas = null
	max_gas = null
	minbodytemp = 0
	faction = "carp"

/mob/living/simple_animal/hostile/maint_monster/Initialize()
	. = ..()
	spawn(24 SECONDS)
		qdel(src)