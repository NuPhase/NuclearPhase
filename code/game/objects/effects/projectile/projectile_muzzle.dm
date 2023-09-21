/obj/effect/projectile/muzzle
	name = "muzzle flash"
	icon = 'icons/effects/projectiles/muzzle.dmi'

/obj/effect/projectile/muzzle/laser
	icon_state = "muzzle_laser"
	light_color = LIGHT_COLOR_RED

/obj/effect/projectile/muzzle/laser/blue
	icon_state = "muzzle_laser_blue"
	light_color = LIGHT_COLOR_BLUE

/obj/effect/projectile/muzzle/disabler
	icon_state = "muzzle_omni"
	light_color = LIGHT_COLOR_CYAN

/obj/effect/projectile/muzzle/xray
	icon_state = "muzzle_xray"
	light_color = LIGHT_COLOR_GREEN

/obj/effect/projectile/muzzle/pulse
	icon_state = "muzzle_u_laser"
	light_color = LIGHT_COLOR_BLUE

/obj/effect/projectile/muzzle/plasma
	icon = 'icons/effects/projectiles/large.dmi'
	icon_state = "muzzle"
	light_color = LIGHT_COLOR_VIOLET
	pixel_x = -16
	pixel_y = -16

/obj/effect/projectile/muzzle/plasma/Initialize(mapload, angle_override, p_x, p_y, color_override, scaling)
	light_color = pick(LIGHT_COLOR_VIOLET, LIGHT_COLOR_BLUE, LIGHT_COLOR_CYAN, LIGHT_COLOR_RED, LIGHT_COLOR_YELLOW)
	. = ..()

/obj/effect/projectile/muzzle/gauss
	icon_state = "muzzle_gauss"
	light_color = LIGHT_COLOR_BLUE

/obj/effect/projectile/muzzle/plasma_cutter
	icon_state = "muzzle_plasmacutter"
	light_color = LIGHT_COLOR_CYAN

/obj/effect/projectile/muzzle/stun
	icon_state = "muzzle_stun"
	light_color = LIGHT_COLOR_YELLOW

/obj/effect/projectile/muzzle/heavy_laser
	icon_state = "muzzle_beam_heavy"
	light_color = LIGHT_COLOR_RED

/obj/effect/projectile/muzzle/cult
	name = "arcane flash"
	icon_state = "muzzle_cult"
	light_color = LIGHT_COLOR_VIOLET
	appearance_flags = NO_CLIENT_COLOR

/obj/effect/projectile/muzzle/cult/heavy
	icon_state = "muzzle_hcult"

/obj/effect/projectile/muzzle/solar
	icon_state = "muzzle_solar"
	light_color = LIGHT_COLOR_FIRE

/obj/effect/projectile/muzzle/eyelaser
	icon_state = "muzzle_eye"
	light_color = LIGHT_COLOR_RED

/obj/effect/projectile/muzzle/emitter
	icon_state = "muzzle_emitter"
	light_color = LIGHT_COLOR_GREEN

/obj/effect/projectile/muzzle/bullet
	icon_state = "muzzle_bullet"
	light_color = LIGHT_COLOR_YELLOW

/obj/effect/projectile/muzzle/particle
	icon_state = "muzzle_particle"
	light_color = LIGHT_COLOR_VIOLET

/obj/effect/projectile/muzzle/darkmatter
	icon_state = "muzzle_darkmatter"
	light_color = LIGHT_COLOR_VIOLET

/obj/effect/projectile/muzzle/darkmattertaser
	icon_state = "muzzle_darkt"
	light_color = LIGHT_COLOR_VIOLET

/obj/effect/projectile/muzzle/incen
	icon_state = "muzzle_incen"
	light_color = LIGHT_COLOR_RED

/obj/effect/projectile/muzzle/pd
	icon_state = "muzzle_pd"
	light_color = LIGHT_COLOR_YELLOW

/obj/effect/projectile/muzzle/variable
	icon_state = "muzzle_laser_white"
	overlay_state = "_overlay"
	light_color = COLOR_WHITE

/obj/effect/projectile/muzzle/variable_heavy
	icon_state = "muzzle_laser_heavy_white"
	overlay_state = "_overlay"
	light_color = COLOR_WHITE
