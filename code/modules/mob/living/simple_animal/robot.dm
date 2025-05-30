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
	default_pixel_x = -9
	default_pixel_y = -9
	pixel_x = -9
	pixel_y = -9

	var/obj/item/gun/projectile/automatic/snapdragon/robot/nonlethal_rifle
	var/obj/item/gun/projectile/automatic/smg/robot/lethal_rifle

/mob/living/simple_animal/robot/has_dexterity(dex_level)
	. = dex_level <= DEXTERITY_WEAPONS

/mob/living/simple_animal/robot/Initialize()
	. = ..()
	fcontrol.combat_drones += src
	nonlethal_rifle = new(src)
	nonlethal_rifle.safety_state = FALSE
	nonlethal_rifle.sel_mode = 2
	nonlethal_rifle.burst = 5
	lethal_rifle = new(src)
	lethal_rifle.safety_state = FALSE
	lethal_rifle.sel_mode = 2
	lethal_rifle.burst = 5

/mob/living/simple_animal/robot/Destroy()
	. = ..()
	fcontrol.combat_drones -= src
	QDEL_NULL(nonlethal_rifle)
	QDEL_NULL(lethal_rifle)

/mob/living/simple_animal/robot/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(!our_ai)
		to_chat(user, SPAN_NOTICE("It is inactive, and it's legs are dug into the floor."))

/mob/living/simple_animal/robot/death(gibbed, deathmessage, show_dead_message)
	. = ..()
	QDEL_NULL(our_ai)
	cell_explosion(get_turf(src), 300, 60)
	qdel(src)

/obj/item/natural_weapon/robot
	name = "twin-blade scissors"
	attack_verb = list("slashed", "split")
	damtype = BRUTE
	force = 15
	sharp = TRUE
	edge = TRUE
	hitsound = 'sound/weapons/rapidslice.ogg'

/mob/living/simple_animal/robot/proc/activate()
	if(our_ai)
		return
	our_ai = new(src)
	anchored = FALSE
	update_icon()
	playsound(src, 'sound/effects/alarms/robot_powerup.ogg', 50, 1)

/mob/living/simple_animal/robot/proc/deactivate()
	if(!our_ai)
		return
	QDEL_NULL(our_ai)
	anchored = TRUE
	update_icon()

/mob/living/simple_animal/robot/on_update_icon()
	. = ..()
	cut_overlays()
	if(our_ai && icon_state == ICON_STATE_WORLD)
		add_overlay(emissive_overlay(icon, "lights"))