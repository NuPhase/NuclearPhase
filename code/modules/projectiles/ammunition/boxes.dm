/obj/item/ammo_magazine/speedloader
	icon = 'icons/obj/ammo/speedloader.dmi'
	icon_state = ICON_STATE_WORLD
	caliber = CALIBER_PISTOL_MAGNUM
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	material = /decl/material/solid/metal/steel
	max_ammo = 6
	var/static/list/bullet_offsets = list(
		list("x" = 0, "y" = 0),
		list("x" = -2, "y" = -3),
		list("x" = -2, "y" = -7),
		list("x" = 0, "y" = -10),
		list("x" = 2, "y" = -7),
		list("x" = 2, "y" = -3)
	)

/obj/item/ammo_magazine/speedloader/on_update_icon()
	. = ..()
	if(!length(stored_ammo))
		return
	switch(icon_state)
		if("world")
			var/ammo_state = "world-some"
			if(length(stored_ammo) == 1)
				ammo_state = "world-one"
			else if(length(stored_ammo) == max_ammo)
				ammo_state = "world-full"
			var/obj/item/ammo_casing/A = stored_ammo[1]
			add_overlay(overlay_image(icon, ammo_state, A.color, RESET_COLOR))
			add_overlay(overlay_image(icon, "[ammo_state]-bullets", A.bullet_color, flags = RESET_COLOR))
			if(A.marking_color)
				add_overlay(overlay_image(icon, "[ammo_state]-markings", A.marking_color, RESET_COLOR))
		if("inventory")
			for(var/i = 1 to length(stored_ammo))
				var/obj/item/ammo_casing/A = stored_ammo[i]
				var/image/I = overlay_image(icon, "casing", A.color, RESET_COLOR)
				if(A.marking_color)
					I.overlays += overlay_image(icon, "marking", A.marking_color, RESET_COLOR)
				if(A.BB)
					I.overlays += overlay_image(icon, "bullet", A.bullet_color, RESET_COLOR)
				I.pixel_x = bullet_offsets[i]["x"]
				I.pixel_y = bullet_offsets[i]["y"]
				add_overlay(I)

/obj/item/ammo_magazine/shotholder
	name = "shotgun slug holder"
	desc = "A convenient pouch that holds 12 gauge shells."
	icon_state = "shotholder"
	caliber = CALIBER_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun
	material = /decl/material/solid/metal/steel
	max_ammo = 4
	multiple_sprites = 1
	var/marking_color

/obj/item/ammo_magazine/shotholder/on_update_icon()
	..()
	overlays.Cut()
	if(marking_color)
		var/image/I = image(icon, "shotholder-marking")
		I.color = marking_color
		overlays += I

/obj/item/ammo_magazine/shotholder/attack_hand(mob/user)
	if((user.a_intent == I_HURT) && (stored_ammo.len))
		var/obj/item/ammo_casing/C = stored_ammo[stored_ammo.len]
		stored_ammo-=C
		user.put_in_hands(C)
		user.visible_message("\The [user] removes \a [C] from [src].", "<span class='notice'>You remove \a [C] from [src].</span>")
		update_icon()
	else
		..()

/obj/item/ammo_magazine/shotholder/shell
	name = "shotgun shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	marking_color = COLOR_RED_GRAY

/obj/item/ammo_magazine/shotholder/beanbag
	name = "beanbag shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	material = /decl/material/solid/metal/steel
	marking_color = COLOR_PAKISTAN_GREEN

/obj/item/ammo_magazine/shotholder/incendiary
	name = "dragon breath shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/dragon_breath
	material = /decl/material/solid/metal/steel
	marking_color = COLOR_ORANGE

/obj/item/ammo_magazine/shotholder/riot
	name = "riot control shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/riot
	material = /decl/material/solid/metal/steel
	marking_color = COLOR_RED_LIGHT

/obj/item/ammo_magazine/shotholder/flash
	name = "illumination shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/flash
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	marking_color = COLOR_PALE_YELLOW

/obj/item/ammo_magazine/shotholder/stun
	name = "stun shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/stunshell
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	marking_color = COLOR_MUZZLE_FLASH

/obj/item/ammo_magazine/shotholder/empty
	name = "shotgun ammunition holder"
	material = /decl/material/solid/metal/steel
	initial_ammo = 0

/obj/item/ammo_magazine/smg
	name = "top mounted magazine"
	icon_state = "smg_top"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/small
	material = /decl/material/solid/metal/steel
	caliber = CALIBER_PISTOL_SMALL
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/smg/empty
	initial_ammo = 0

/obj/item/ammo_magazine/smg/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/small/rubber

/obj/item/ammo_magazine/smg/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/small/practice

/obj/item/ammo_magazine/smg/c11x25
	name = "11x25 CL SMG magazine"
	caliber = "11x25"
	ammo_type = /obj/item/ammo_casing/caseless/c11x25
	max_ammo = 60

/obj/item/ammo_magazine/pistol
	name = "11x25 pistol magazine"
	icon_state = "pistol"
	origin_tech = @'{"combat":2}'
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL
	material = /decl/material/solid/metal/steel
	ammo_type = /obj/item/ammo_casing/c11x25
	max_ammo = 15
	multiple_sprites = 1

/obj/item/ammo_magazine/pistol/srec
	name = "11x25 SREC magazine"
	desc = "What the fuck did you do???"
	ammo_type = /obj/item/ammo_casing/caseless/c11x25/srec

/obj/item/ammo_magazine/pistol/oneround
	initial_ammo = 1

/obj/item/ammo_magazine/pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/pistol/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/pistol/cryogenic
	name = "cryogenic pistol magazine"
	desc = "It feels extremely cold."
	material = /decl/material/solid/metal/titanium
	ammo_type = /obj/item/ammo_casing/pistol/cryogenic
	max_ammo = 8

/obj/item/ammo_magazine/pistol/small
	icon_state = "holdout"
	material = /decl/material/solid/metal/steel
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 8

/obj/item/ammo_magazine/pistol/small/empty
	initial_ammo = 0

/obj/item/ammo_magazine/box/smallpistol
	name = "ammunition box (pistol, small)"
	icon_state = "smallpistol"
	origin_tech = @'{"combat":2}'
	material = /decl/material/solid/metal/steel
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 30

/obj/item/ammo_magazine/box/pistol
	name = "ammunition box (pistol)"
	icon_state = "smallpistol"
	origin_tech = @'{"combat":2}'
	caliber = CALIBER_PISTOL
	material = /decl/material/solid/metal/steel
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 30

/obj/item/ammo_magazine/box/pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/box/emp/pistol
	name = "ammunition box (pistol, haywire)"
	desc = "A box containing loose rounds of standard EMP ammo."
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/emp
	caliber = CALIBER_PISTOL
	max_ammo = 15
	origin_tech = @'{"combat":2,"magnets":2,"powerstorage":2}'

/obj/item/ammo_magazine/box/emp/smallpistol
	name = "ammunition box (pistol, small, haywire)"
	desc = "A box containing loose rounds of small EMP ammo."
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/small/emp
	caliber = CALIBER_PISTOL_SMALL
	max_ammo = 8
	origin_tech = @'{"combat":2,"magnets":2,"powerstorage":2}'

/obj/item/ammo_magazine/rifle
	name = "assault rifle magazine"
	icon_state = "bullup"
	origin_tech = @'{"combat":2}'
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE
	material = /decl/material/solid/metal/steel
	ammo_type = /obj/item/ammo_casing/rifle
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/rifle/empty
	initial_ammo = 0

/obj/item/ammo_magazine/rifle/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/rifle/practice

/obj/item/ammo_magazine/c6p8x51
	name = "6.8x51 rifle magazine"
	caliber = "6.8x51"
	ammo_type = /obj/item/ammo_casing/c6p8x51
	max_ammo = 25
	icon_state = "assault_rifle"
	mag_type = MAGAZINE
/obj/item/ammo_magazine/c6p8x51/ap
	name = "6.8x51 AP magazine"
	ammo_type = /obj/item/ammo_casing/c6p8x51/ap
/obj/item/ammo_magazine/c6p8x51/fmj
	name = "6.8x51 FMJ magazine"
	ammo_type = /obj/item/ammo_casing/c6p8x51/fmj
/obj/item/ammo_magazine/c6p8x51/hp
	name = "6.8x51 HP magazine"
	ammo_type = /obj/item/ammo_casing/c6p8x51/hp

/obj/item/ammo_magazine/snapdragon
	name = "snapdragon rifle magazine"
	caliber = CALIBER_RIFLE_SNAPDRAGON
	ammo_type = /obj/item/ammo_casing/caseless/snapdragon
	max_ammo = 30
	icon_state = "bullup"
	mag_type = MAGAZINE

/obj/item/ammo_magazine/c127x99
	name = "50 BMG sniper magazine"
	caliber = CALIBER_ANTI_MATERIEL
	ammo_type = /obj/item/ammo_casing/shell
	max_ammo = 5
	icon_state = "bullup"
	mag_type = MAGAZINE
/obj/item/ammo_magazine/c127x99/ap
	name = "50 BMG AP sniper magazine"
	ammo_type = /obj/item/ammo_casing/shell/ap
/obj/item/ammo_magazine/c127x99/tracer
	name = "50 BMG Tracer sniper magazine"
	ammo_type = /obj/item/ammo_casing/shell/tracer
/obj/item/ammo_magazine/c127x99/tracer/heavy
	name = "50 BMG Incendiary sniper magazine"
	ammo_type = /obj/item/ammo_casing/shell/tracer/heavy
/obj/item/ammo_magazine/c127x99/tracer/explosive
	name = "50 BMG Explosive sniper magazine"
	ammo_type = /obj/item/ammo_casing/shell/tracer/explosive

/obj/item/ammo_magazine/caps
	name = "speed loader"
	desc = "A cheap plastic speed loader for some kind of revolver."
	icon_state = "T38"
	caliber = CALIBER_CAPS
	ammo_type = /obj/item/ammo_casing/cap
	material = /decl/material/solid/metal/steel
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/speedloader/laser_revolver
	caliber = CALIBER_PISTOL_LASBULB
	ammo_type = /obj/item/ammo_casing/lasbulb

/obj/item/ammo_magazine/railgunfletchette
	name = "3x20 heatshielded magazine"
	icon_state = "railgun"
	caliber = "3x20"
	ammo_type = /obj/item/ammo_casing/magneticfletchette
	max_ammo = 120
	mag_type = MAGAZINE