/obj/effect/oceanborn_burrow
	name = "darkwater burrow"
	desc = "A large hole in the ground, seemingly dug by something very large... It can probably be closed with a shovel."
	icon = 'icons/effects/geyser.dmi'
	icon_state = "geyser"
	anchored = TRUE
	layer = TURF_LAYER + 0.01
	var/spawn_ticks = 0
	var/spawn_period = 20
	var/max_spawns = 15
	var/spawns = 0
	var/list/spawn_types = list(/mob/living/simple_animal/hostile/darkwater/hunter)

/obj/effect/oceanborn_burrow/attackby(obj/item/I, mob/user)
	if(IS_SHOVEL(I))
		visible_message(SPAN_NOTICE("[user] starts closing \the [src]."))
		if(!do_after(user, 100, src))
			return
		qdel(src)
		return
	. = ..()

/obj/effect/oceanborn_burrow/get_mechanics_info()
	return "Use a shovel on it to close it."

/obj/effect/oceanborn_burrow/Process()
	if(spawns > max_spawns)
		return PROCESS_KILL
	spawn_ticks += 1
	if(spawn_ticks > spawn_period)
		var/spawn_type = pick(spawn_types)
		new spawn_type(loc)
		spawn_ticks = 0
		spawns += 1
		playsound(src, 'sound/voice/lizard.ogg', 100, 0, 30)

/obj/effect/oceanborn_burrow/Initialize()
	. = ..()
	set_scale(2, 2)
	START_PROCESSING(SSobj, src)
	playsound(src, 'sound/voice/lizard.ogg', 100, 0, 30)

// A family of creatures themed around underwater oceans.
/mob/living/simple_animal/hostile/darkwater
	name = "creature"
	desc = "You get the feeling you should run."
	icon = 'icons/mob/simple_animal/vagrant.dmi'
	maxHealth = 60
	health = 60
	speak_chance = 0
	turns_per_move = 4
	move_to_delay = 4
	can_escape = TRUE
	faction = "darkwater"
	harm_intent_damage = 10
	natural_weapon = /obj/item/natural_weapon/claws
	light_color = "#4b248b"

	bleed_colour = "#cba5eb"

// The main tank.
/mob/living/simple_animal/hostile/darkwater/hunter
	name = "oceanborn hunter"
	desc = "A grotesque creature, born from the darkness."
	icon = 'icons/mob/simple_animal/oceanborn_hunter.dmi'
	maxHealth = 160
	health = 160
	natural_weapon = /obj/item/natural_weapon/claws
	break_stuff_probability = 10
	destroy_surroundings = 1
	skin_material = /decl/material/solid/skin/fish/purple
	meat_type = /obj/item/chems/food/meat/syntiflesh
	glowing_eyes = TRUE
	speed = -2
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_HEAVY,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
	)