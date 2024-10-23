/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	damage = 50
	damage_type = BRUTE
	damage_flags = DAM_BULLET | DAM_SHARP
	nodamage = 0
	embed = 1
	space_knockback = 1
	penetration_modifier = 1.0
	var/mob_passthrough_check = 0
	var/caliber

	muzzle_type = /obj/effect/projectile/muzzle/bullet
	miss_sounds = list('sound/weapons/guns/miss1.ogg','sound/weapons/guns/miss2.ogg','sound/weapons/guns/miss3.ogg','sound/weapons/guns/miss4.ogg')
	ricochet_sounds = list('sound/weapons/guns/ricochet1.ogg', 'sound/weapons/guns/ricochet2.ogg',
							'sound/weapons/guns/ricochet3.ogg', 'sound/weapons/guns/ricochet4.ogg')
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_BULLET_MEAT, BULLET_IMPACT_METAL = SOUNDS_BULLET_METAL)

/obj/item/projectile/bullet/get_autopsy_descriptors()
	. = ..()
	if(caliber)
		. += "matching caliber [caliber]"

/obj/item/projectile/bullet/on_hit(var/atom/target, var/blocked = 0)
	if (..(target, blocked))
		var/mob/living/L = target
		shake_camera(L, 1, 2)

/obj/item/projectile/bullet/attack_mob(var/mob/target_mob, var/distance, var/miss_modifier)
	if(penetrating > 0 && damage > 20 && prob(damage))
		mob_passthrough_check = 1
	else
		mob_passthrough_check = 0
	. = ..()

	if(. == 1 && iscarbon(target_mob))
		damage *= 0.7 //squishy mobs absorb KE

/obj/item/projectile/bullet/can_embed()
	//prevent embedding if the projectile is passing through the mob
	if(mob_passthrough_check)
		return 0
	return ..()

/obj/item/projectile/bullet/check_penetrate(var/atom/A)
	if(QDELETED(A) || !A.density) return 1 //if whatever it was got destroyed when we hit it, then I guess we can just keep going

	if(ismob(A))
		if(!mob_passthrough_check)
			return 0
		return 1

	var/chance = damage
	if(has_extension(A, /datum/extension/penetration))
		var/datum/extension/penetration/P = get_extension(A, /datum/extension/penetration)
		chance = P.PenetrationProbability(chance, damage, damage_type)

	if(prob(chance))
		if(A.opacity)
			//display a message so that people on the other side aren't so confused
			A.visible_message("<span class='warning'>\The [src] pierces through \the [A]!</span>")
		return 1

	return 0

/* short-casing projectiles, like the kind used in pistols or SMGs */

/obj/item/projectile/bullet/pistol
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	damage = 45
	distance_falloff = 3

/obj/item/projectile/bullet/pistol/cryogenic
	fire_sound = 'sound/weapons/gunshot/sniper.ogg' //we pack POWER
	damage = 65
	distance_falloff = 3
	penetration_modifier = 1.5

/obj/item/projectile/bullet/pistol/holdout
	damage = 20
	penetration_modifier = 1.2
	distance_falloff = 2

/obj/item/projectile/bullet/pistol/strong
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	damage = 50
	penetration_modifier = 0.8
	distance_falloff = 2.5
	armor_penetration = 15

/obj/item/projectile/bullet/pistol/rubber //"rubber" bullets
	name = "rubber bullet"
	damage_flags = 0
	damage = 10
	agony = 30
	embed = 0

/obj/item/projectile/bullet/pistol/rubber/holdout
	agony = 20

/* shotgun projectiles */

/obj/item/projectile/bullet/shotgun
	name = "slug"
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	damage = 65
	armor_penetration = 10

/obj/item/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	damage = 25
	damage_flags = 0
	agony = 60
	embed = 0
	armor_penetration = 0
	stun = 3
	weaken = 2
	distance_falloff = 3

/obj/item/projectile/bullet/shotgun/incendiary
	name = "dragon breath"
	icon_state = "incendiary"
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	damage_type = BURN
	damage_flags = DAM_LASER
	damage = 25
	eyeblur = 2
	agony = 20
	armor_penetration = 0
	distance_falloff = 0.5 //we're large so falloff is lower

/obj/item/projectile/bullet/shotgun/incendiary/after_move()
	. = ..()
	new /obj/effect/fake_fire/dragon_breath(loc)

/obj/item/projectile/bullet/shotgun/incendiary/on_hit(atom/target, blocked)
	if(..(target, blocked))
		if(isliving(target))
			var/mob/living/L = target
			L.adjust_fire_stacks(rand(5,8))
			L.IgniteMob()
	deflagration(get_turf(target), 150, 25, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, shock_color = FIRE_COLOR_DEFAULT)

/obj/item/projectile/bullet/shotgun/riot
	name = "riot control"
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	damage_type = BRUTE
	damage_flags = DAM_BULLET
	damage = 5
	eyeblur = 5
	agony = 200
	armor_penetration = 0

/obj/item/projectile/bullet/shotgun/riot/on_hit(atom/target, blocked)
	. = ..()
	playsound(target.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	new /obj/effect/effect/smoke/mustard(get_turf(target))

/* "Rifle" rounds */

/obj/item/projectile/bullet/rifle
	fire_sound = 'sound/weapons/gunshot/gunshot_556.ogg'
	damage = 70
	armor_penetration = 35
	penetration_modifier = 1.5
	penetrating = 1
	distance_falloff = 1.5

/obj/item/projectile/bullet/rifle/shell
	fire_sound = 'sound/weapons/gunshot/sniper.ogg'
	damage = 80
	stun = 3
	weaken = 3
	penetrating = 3
	armor_penetration = 70
	penetration_modifier = 1.2
	distance_falloff = 0.5

/obj/item/projectile/bullet/rifle/shell/apds
	damage = 70
	penetrating = 5
	armor_penetration = 80
	penetration_modifier = 1.5

/* Miscellaneous */

/obj/item/projectile/bullet/blank
	invisibility = 101
	damage = 1
	embed = 0

/* Practice */

/obj/item/projectile/bullet/pistol/practice
	damage = 5

/obj/item/projectile/bullet/rifle/practice
	damage = 5

/obj/item/projectile/bullet/shotgun/practice
	name = "practice"
	damage = 5

/obj/item/projectile/bullet/pistol/cap
	name = "cap"
	invisibility = 101
	fire_sound = null
	damage_type = PAIN
	damage_flags = 0
	damage = 0
	nodamage = 1
	embed = 0

/obj/item/projectile/bullet/pistol/cap/Process()
	qdel(src)
	return PROCESS_KILL

/obj/item/projectile/bullet/rock //spess dust
	name = "micrometeor"
	icon_state = "rock"
	damage = 40
	armor_penetration = 25
	life_span = 255
	distance_falloff = 0

/obj/item/projectile/bullet/rock/Initialize()
	. = ..()
	icon_state = "rock[rand(1,3)]"
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)



/obj/item/projectile/bullet/modern
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	damage = 45
	armor_penetration = 25
	penetration_modifier = 1.5
	penetrating = 1
	distance_falloff = 1.5

/obj/item/projectile/bullet/modern/snapdragon
	fire_sound = 'sound/weapons/gunshot/laserbulb.ogg'
	icon_state = "bullet1"
	damage_type = BURN
	damage_flags = DAM_LASER
	damage = 20
	eyeblur = 2
	agony = 150
	armor_penetration = ARMOR_LASER_SMALL
	embed = FALSE
	penetrating = FALSE
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_LASER_MEAT, BULLET_IMPACT_METAL = SOUNDS_LASER_METAL)

/obj/item/projectile/bullet/modern/c6p8x51
	fire_sound = 'sound/weapons/gunshot/gunshot_heavy.ogg'
	damage = 35
/obj/item/projectile/bullet/modern/c6p8x51/ap
	armor_penetration = ARMOR_BALLISTIC_RIFLE
/obj/item/projectile/bullet/modern/c6p8x51/fmj
	armor_penetration = ARMOR_BALLISTIC_RESISTANT
/obj/item/projectile/bullet/modern/c6p8x51/hp
	armor_penetration = ARMOR_BALLISTIC_SMALL
	damage = 50

/obj/item/projectile/bullet/modern/c11x25
	fire_sound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	damage = 35
	armor_penetration = ARMOR_BALLISTIC_PISTOL
/obj/item/projectile/bullet/modern/c11x25/srec //same armor penetration, larger damage and higher falloff
	damage = 50
	muzzle_type = /obj/effect/projectile/muzzle/gauss
/obj/item/projectile/bullet/modern/c11x25/srec/launch(atom/target, target_zone, mob/user, params, Angle_override, forced_spread)
	. = ..()
	for(var/mob/living/L in view(1, user))
		L.apply_damage(150, IRRADIATE)

/obj/item/projectile/bullet/modern/c10x77
	fire_sound = 'sound/weapons/gunshot/sniper.ogg'
	damage = 90
	stun = 3
	weaken = 3
	armor_penetration = 70
	penetration_modifier = 1.5
	distance_falloff = 0.5

/obj/item/projectile/bullet/modern/c127x99 //.50 BMG
	fire_sound = 'sound/weapons/gunshot/sniper.ogg'
	damage = 60
	stun = 3
	weaken = 1
	armor_penetration = ARMOR_BALLISTIC_AP
	penetration_modifier = 1.5
	distance_falloff = 0.5
	agony = 650

/obj/item/projectile/bullet/modern/c127x99/ap
	armor_penetration = ARMOR_BALLISTIC_HEAVY
	damage = 50

//light incendiary for setting stuff on fire, etc
/obj/item/projectile/bullet/modern/c127x99/tracer
	damage = 50
	var/fire_stacks = 2
	armor_penetration = ARMOR_BALLISTIC_RIFLE

/obj/item/projectile/bullet/modern/c127x99/tracer/after_move()
	. = ..()
	new /obj/effect/fake_fire/dragon_breath(loc)

/obj/item/projectile/bullet/modern/c127x99/tracer/on_hit(atom/target, blocked)
	if(..(target, blocked))
		if(isliving(target))
			var/mob/living/L = target
			L.adjust_fire_stacks(fire_stacks)
			L.IgniteMob()

//heavy incendiary for setting stuff on fire, etc
/obj/item/projectile/bullet/modern/c127x99/tracer/heavy
	damage = 45
	fire_stacks = 10

//explosive round
/obj/item/projectile/bullet/modern/c127x99/tracer/explosive
	damage = 90
	fire_stacks = 5

/obj/item/projectile/bullet/modern/c127x99/tracer/explosive/on_hit(atom/target, blocked)
	cell_explosion(target, 200, 150, z_transfer = null)
	. = ..()