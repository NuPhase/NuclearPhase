/mob/living/silicon/robot/syndicate
	lawupdate = 0
	scrambledcodes = 1
	icon = 'icons/mob/robots/robot_security.dmi'
	modtype = "Security"
	lawchannel = "State"
	laws = /datum/ai_laws/syndicate_override
	idcard = /obj/item/card/id/syndicate
	module = /obj/item/robot_module/syndicate
	silicon_radio = /obj/item/radio/borg/syndicate
	spawn_sound = 'sound/mecha/nominalsyndi.ogg'
	cell = /obj/item/cell/super
	pitch_toggle = 0

/mob/living/silicon/robot/combat
	lawupdate = 0
	scrambledcodes = 1
	modtype = "Combat"
	module = /obj/item/robot_module/security/combat
	spawn_sound = 'sound/mecha/nominalsyndi.ogg'
	cell = /obj/item/cell/super
	pitch_toggle = 0

/mob/living/silicon/robot/engineering
	lawupdate = 0
	modtype = "Engineering"
	module = /obj/item/robot_module/engineering
	cell = /obj/item/cell/lithium_array
	speed = -1
	weight = 370 //FUCKING HEAVY
	icon = 'icons/mob/robots/robot_engineer_drake.dmi'
	icon_selected = TRUE
	default_pixel_x = -16