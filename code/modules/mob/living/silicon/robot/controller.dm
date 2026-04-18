/obj/item/unit_control_tablet
	name = "unit control computer"
	desc = "A small, portable microcomputer."
	icon = 'icons/obj/modular_computers/modular_tablet.dmi'
	icon_state = "tabletsol"

	w_class = ITEM_SIZE_SMALL

	weight = 0.45

	var/weakref/controlled

/obj/item/unit_control_tablet/get_mechanics_info()
	return "Use this tablet on an engineering robot to control it. When in control, head to Remote Control > Stop Remote Control to terminate control."

/obj/item/unit_control_tablet/Initialize(ml, material_key)
	. = ..()
	global.listening_objects += src

/obj/item/unit_control_tablet/Destroy()
	. = ..()
	global.listening_objects -= src

/obj/item/unit_control_tablet/attack(mob/living/M, mob/living/user, target_zone, animate)
	if(istype(M, /mob/living/silicon/robot/engineering))
		var/mob/living/silicon/robot/engineering/our_robot = M
		if(our_robot.controller || our_robot.ckey)
			to_chat(user, SPAN_WARNING("This robot is already controlled by someone."))
			return
		to_chat(user, SPAN_NOTICE("You take control of this robot."))
		controlled = weakref(our_robot)
		user.teleop = "robot"
		our_robot.controller = weakref(user)
		our_robot.ckey = user.ckey
		addtimer(CALLBACK(our_robot, TYPE_PROC_REF(/mob/living/silicon/robot, set_stat), CONSCIOUS), 5 SECONDS)
	else
		. = ..()

/obj/item/unit_control_tablet/hear_talk(mob/M, text, verb, decl/language/speaking)
	if(!controlled)
		return
	var/mob/controlled_mob = controlled.resolve()
	if(!controlled_mob)
		return
	controlled_mob.hear_say(text, verb, speaking, speaker = M)

/obj/item/unit_control_tablet/dropped(mob/user)
	. = ..()
	if(!controlled)
		return
	var/mob/living/silicon/robot/engineering/controlled_mob = controlled.resolve()
	if(!controlled_mob)
		return
	controlled_mob.controller = null
	user.ckey = controlled_mob.ckey
	user.teleop = null