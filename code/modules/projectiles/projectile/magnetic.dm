// Rod for railguns. Slightly less nasty than the sniper round.
/obj/item/projectile/bullet/magnetic
	name = "rod"
	icon_state = "gauss"
	damage = 35
	penetrating = 2
	armor_penetration = 85
	penetration_modifier = 1.1
	stun = 1
	fire_sound = 'sound/weapons/railgun.ogg'
	distance_falloff = 1
	muzzle_type = /obj/effect/projectile/muzzle/gauss
	var/rail_wear = 0

/obj/item/projectile/bullet/magnetic/slug
	name = "slug"
	icon_state = "gauss_silenced"
	damage = 45
	armor_penetration = 90
	fire_sound = 'sound/weapons/rapidslice.ogg'
	rail_wear = 0.5

/obj/item/projectile/bullet/magnetic/staged
	name = "railgun shell"
	icon_state = "bullet1"
	damage = 50
	armor_penetration = 100
	rail_wear = 1.5

/obj/item/projectile/bullet/magnetic/staged/modified
	rail_wear = 1
	damage = 45

/obj/item/projectile/bullet/magnetic/gas
	name = "plasma cloud"
	icon_state = "incendiary"
	color = LIGHT_COLOR_BLUE
	damage = 50
	armor_penetration = 100
	rail_wear = 1.5
	damage_type = BURN
	damage_flags = DAM_LASER
	eyeblur = 2
	agony = 20

/obj/item/projectile/bullet/shotgun/incendiary/on_hit(atom/target, blocked)
	if(..(target, blocked))
		deflagration(get_turf(target), 150, 50, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, shock_color = LIGHT_COLOR_BLUE)