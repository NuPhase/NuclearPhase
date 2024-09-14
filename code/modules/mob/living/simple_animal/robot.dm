var/global/list/combat_drones = list()

/mob/living/simple_animal/robot
	name = "Combat Drone"
	real_name = "Drone"
	desc = "An automonous military drone."
	icon = 'icons/mob/robots/robot_ninja.dmi'
	maxHealth = 150
	health = 150
	universal_speak = TRUE
	speak_emote = list("beeps")
	emote_hear = list("buzzes","beeps")
	response_disarm =  "flails at"
	response_harm =    "punches"
	natural_weapon = /obj/item/natural_weapon/robot
	minbodytemp = 0
	maxbodytemp = 4000
	min_gas = null
	max_gas = null
	speed = -1
	stop_automated_movement = 1
	status_flags = 0
	faction = "silicon"
	status_flags = CANSTUN | CANWEAKEN | CANPARALYSE | CANPUSH
	gene_damage = -1

	bleed_colour = "#181933"

	meat_type =     null
	meat_amount =   0
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   0
	var/datum/ai/an_robot/our_ai
	weight = 170 //FUCKING HEAVY
	pickup_capacity = 40
	drag_capacity = 240
	anchored = TRUE
	a_intent = I_HURT

/mob/living/simple_animal/robot/Initialize()
	. = ..()
	combat_drones += src

/mob/living/simple_animal/robot/Destroy()
	. = ..()
	combat_drones -= src

/mob/living/simple_animal/robot/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(!our_ai)
		to_chat(user, SPAN_NOTICE("It is inactive and anchored to the floor."))

/obj/item/natural_weapon/robot
	name = "composite blade"
	attack_verb = list("slashed", "diced")
	damtype = BRUTE
	force = 25

/mob/living/simple_animal/robot/proc/activate()
	our_ai = new(src)
	anchored = FALSE
	update_icon()

/mob/living/simple_animal/robot/on_update_icon()
	. = ..()
	cut_overlays()
	if(our_ai && icon_state == ICON_STATE_WORLD)
		add_overlay(image(icon, icon_state = "world-eyes"))