
/obj/item/ammo_casing/pistol
	desc = "A pistol bullet casing."
	caliber = CALIBER_PISTOL
	projectile_type = /obj/item/projectile/bullet/pistol
	icon = 'icons/obj/ammo/casings/pistol.dmi'

/obj/item/ammo_casing/pistol/cryogenic
	desc = "A cryogenic pistol bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/cryogenic
	icon = 'icons/obj/ammo/casings/pistol.dmi'

/obj/item/ammo_casing/pistol/rubber
	desc = "A rubber pistol bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	bullet_color = COLOR_GRAY40

/obj/item/ammo_casing/pistol/practice
	desc = "A practice pistol bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/practice
	bullet_color = COLOR_OFF_WHITE
	marking_color = COLOR_SUN

/obj/item/ammo_casing/pistol/emp
	name = "haywire round"
	desc = "A pistol bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/item/projectile/ion/small
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/metal/uranium = MATTER_AMOUNT_REINFORCEMENT)
	bullet_color = COLOR_ACID_CYAN
	marking_color = COLOR_LUMINOL

/obj/item/ammo_casing/pistol/small
	desc = "A .23 (6x15mm) bullet casing."
	color = COLOR_POLISHED_BRASS
	icon = 'icons/obj/ammo/casings/small_pistol.dmi'
	caliber = CALIBER_PISTOL_SMALL
	projectile_type = /obj/item/projectile/bullet/pistol/holdout

/obj/item/ammo_casing/pistol/small/rubber
	desc = "A small pistol rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber/holdout
	bullet_color = COLOR_GRAY40

/obj/item/ammo_casing/pistol/small/practice
	desc = "A small pistol practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/practice
	bullet_color = COLOR_OFF_WHITE
	marking_color = COLOR_SUN

/obj/item/ammo_casing/pistol/small/emp
	name = "small haywire round"
	desc = "A small bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/item/projectile/ion/tiny
	bullet_color = COLOR_ACID_CYAN
	marking_color = COLOR_LUMINOL

/obj/item/ammo_casing/pistol/small/shock
	name = "shock round"
	desc = "A small bullet casing fitten with a shock generator for incapacitation."
	projectile_type = /obj/item/projectile/bullet/pistol/electrode

/obj/item/ammo_casing/pistol/magnum
	desc = "A high-power pistol bullet casing."
	caliber = CALIBER_PISTOL_MAGNUM
	color = COLOR_POLISHED_BRASS
	marking_color = COLOR_MAROON
	projectile_type = /obj/item/projectile/bullet/pistol/strong
	icon = 'icons/obj/ammo/casings/magnum.dmi'

/obj/item/ammo_casing/shotgun
	name = "slug shell"
	desc = "A 12 gauge slug shell."
	icon_state = "slshell"
	spent_icon = "slshell-spent"
	caliber = CALIBER_SHOTGUN
	projectile_type = /obj/item/projectile/bullet/shotgun
	material = /decl/material/solid/metal/steel
	fall_sounds = list('sound/weapons/guns/shotgun_fall.ogg')

/obj/item/ammo_casing/shotgun/pellet
	name = "shotgun shell"
	desc = "A 12 gauge buckshot shell."
	icon_state = "gshell"
	spent_icon = "gshell-spent"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun
	material = /decl/material/solid/metal/steel

/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A 12 gauge blank shell."
	icon_state = "blshell"
	spent_icon = "blshell-spent"
	projectile_type = /obj/item/projectile/bullet/blank
	material = /decl/material/solid/metal/steel

/obj/item/ammo_casing/shotgun/practice
	name = "shotgun shell"
	desc = "A 12 gauge practice shell packed with slow, frangible shot."
	icon_state = "pshell"
	spent_icon = "pshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/practice
	material = /decl/material/solid/metal/steel

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A 12 gauge less-than-lethal shell with a pellet-filled soft bag."
	icon_state = "bshell"
	spent_icon = "bshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag
	material = /decl/material/solid/metal/steel

/obj/item/ammo_casing/shotgun/dragon_breath
	name = "dragon breath shell"
	desc = "A 12 gauge shell packed with magnesium pellets that create a fiery blast."
	icon_state = "pshell"
	spent_icon = "pshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/incendiary
	material = /decl/material/solid/metal/steel

/obj/item/ammo_casing/shotgun/riot
	name = "riot shell"
	desc = "A 12 gauge riot shell."
	icon_state = "stunshell"
	spent_icon = "stunshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/riot
	material = /decl/material/solid/metal/steel

//Can stun in one hit if aimed at the head, but
//is blocked by clothing that stops tasers and is vulnerable to EMP
/obj/item/ammo_casing/shotgun/stunshell
	name = "stun shell"
	desc = "A 12 gauge shell with a pair of electrodes packed inside to shock on hit."
	icon_state = "stunshell"
	spent_icon = "stunshell-spent"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot
	leaves_residue = 0
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = @'{"combat":3,"materials":3}'

/obj/item/ammo_casing/shotgun/stunshell/emp_act(severity)
	if(prob(100/severity)) BB = null
	update_icon()

//Does not stun, only blinds, but has area of effect.
/obj/item/ammo_casing/shotgun/flash
	name = "flash shell"
	desc = "A 12 gauge chemical shell used to signal distress or provide illumination."
	icon_state = "fshell"
	spent_icon = "fshell-spent"
	projectile_type = /obj/item/projectile/energy/flash/flare
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/ammo_casing/shotgun/emp
	name = "haywire slug"
	desc = "A 12 gauge shotgun slug fitted with a single-use ion pulse generator."
	icon_state = "empshell"
	spent_icon = "empshell-spent"
	projectile_type  = /obj/item/projectile/ion
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/metal/uranium = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = @'{"combat":4,"materials":3}'

/obj/item/ammo_casing/shell
	desc = "A .416 (10.56x66mm) full metal jacket bullet casing."
	caliber = CALIBER_ANTI_MATERIEL
	projectile_type = /obj/item/projectile/bullet/modern/heavy_sniper
	material = /decl/material/solid/metal/steel
	color = COLOR_POLISHED_BRASS
	icon = 'icons/obj/ammo/casings/anti_materiel.dmi'

/obj/item/ammo_casing/shell/ap
	desc = "A .416 (10.56x66mm) cemented-core armour-piercing bullet casing."
	marking_color = COLOR_GUNMETAL
	projectile_type = /obj/item/projectile/bullet/modern/heavy_sniper/ap

/obj/item/ammo_casing/shell/tracer
	desc = "A .416 (10.56x66mm) tracer bullet casing."
	projectile_type = /obj/item/projectile/bullet/modern/heavy_sniper/tracer
	bullet_color = COLOR_RED_GRAY
	marking_color = COLOR_NT_RED

/obj/item/ammo_casing/shell/tracer/heavy
	desc = "A .416 (10.56x66mm) immediate action incendiary tracer bullet casing."
	projectile_type = /obj/item/projectile/bullet/modern/heavy_sniper/tracer/heavy
	marking_color = COLOR_ORANGE

/obj/item/ammo_casing/shell/tracer/explosive
	desc = "A .416 (10.56x66mm) high explosive tracer bullet casing."
	projectile_type = /obj/item/projectile/bullet/modern/heavy_sniper/tracer/explosive
	marking_color = COLOR_RED

/obj/item/ammo_casing/rifle
	desc = "A military rifle bullet casing."
	caliber = CALIBER_RIFLE
	projectile_type = /obj/item/projectile/bullet/rifle
	icon = 'icons/obj/ammo/casings/rifle.dmi'

/obj/item/ammo_casing/rifle/practice
	desc = "A military rifle practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/practice
	bullet_color = COLOR_OFF_WHITE
	marking_color = COLOR_SUN

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell"
	projectile_type = /obj/item/missile
	caliber = "rocket"

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	caliber = CALIBER_CAPS
	icon = 'icons/obj/ammo/casings/small_pistol.dmi'
	bullet_color = COLOR_RED
	color = COLOR_RED
	projectile_type = /obj/item/projectile/bullet/pistol/cap

/obj/item/ammo_casing/lasbulb
	name = "lasbulb"
	desc = "A laser-bulb casing."
	caliber = CALIBER_PISTOL_LASBULB
	projectile_type = /obj/item/projectile/beam/pop
	icon = 'icons/obj/ammo/casings/lasbulb.dmi'
	color = COLOR_BLUE_GRAY
	bullet_color = COLOR_BLUE_LIGHT
	material = /decl/material/solid/glass
	matter = list(/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT)

// Assault and Marksman rifle rounds
/obj/item/ammo_casing/medium_rifle
	desc = "A .255 (6.5x35mm) SSA Caseless full metal jacket cartridge."
	caliber = CALIBER_RIFLE
	projectile_type = /obj/item/projectile/bullet/modern/medium_rifle
	icon = 'icons/obj/ammo/casings/rifle.dmi'
/obj/item/ammo_casing/medium_rifle/ap
	desc = "A .255 (6.5x35mm) SSA Caseless tungsten-tipped armour-piercing cartridge."
	projectile_type = /obj/item/projectile/bullet/modern/medium_rifle/ap
/obj/item/ammo_casing/medium_rifle/hp
	desc = "A .255 (6.5x35mm) SSA Caseless hollow-point cartridge."
	projectile_type = /obj/item/projectile/bullet/modern/medium_rifle/hp

/obj/item/ammo_casing/heavy_rifle
	desc = "A .308 (7.62x40mm) SSA full metal jacket bullet casing."
	caliber = CALIBER_RIFLE_HEAVY
	projectile_type = /obj/item/projectile/bullet/modern/heavy_rifle
	icon = 'icons/obj/ammo/casings/rifle.dmi'

/obj/item/ammo_casing/heavy_rifle/ap
	desc = "A .308 (7.62x40mm) SSA tungsten-tipped armour-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/modern/heavy_rifle/ap

/obj/item/ammo_casing/heavy_rifle/hp
	desc = "A .308 (7.62x40mm) SSA hollow-point bullet casing."
	projectile_type = /obj/item/projectile/bullet/modern/heavy_rifle/hp

// Pistol rounds
/obj/item/ammo_casing/medium_pistol
	desc = "A .40 (10x21mm) Auto full metal jacket bullet casing."
	caliber = CALIBER_PISTOL
	projectile_type = /obj/item/projectile/bullet/modern/medium_pistol
	icon = 'icons/obj/ammo/casings/pistol.dmi'

/obj/item/ammo_casing/medium_pistol/ap
	desc = "A .40 (10x21mm) Auto armour-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/modern/medium_pistol/ap

/obj/item/ammo_casing/medium_pistol/fhp
	desc = "A .40 (10x21mm) Auto frangible hollow-point bullet casing."
	projectile_type = /obj/item/projectile/bullet/modern/medium_pistol/fhp

/obj/item/ammo_casing/medium_pistol/srec
	desc = "A .40 (10x21mm) Auto SREC-core bullet casing."
	projectile_type = /obj/item/projectile/bullet/modern/medium_pistol/srec

/obj/item/ammo_casing/light_pistol
	desc = "A .35 (9x20mm) Borschevik subcaliber armour-piercing bullet casing."
	caliber = CALIBER_PISTOL_SMG
	projectile_type = /obj/item/projectile/bullet/modern/light_pistol
	icon = 'icons/obj/ammo/casings/pistol.dmi'

/obj/item/ammo_casing/light_pistol/fhp
	desc = "A .35 (9x20mm) Borschevik frangible hollow-point bullet casing."
	projectile_type = /obj/item/projectile/bullet/modern/light_pistol/fhp

/obj/item/ammo_casing/caseless/light_pistol/srec
	desc = "A .35 (9x20mm) Borschevik SREC-core bullet casing."
	projectile_type = /obj/item/projectile/bullet/modern/light_pistol/srec
	icon = 'icons/obj/ammo/casings/pistol.dmi'
	caliber = CALIBER_PISTOL_SMG
	color = COLOR_GUNMETAL
	bullet_color = COLOR_GUNMETAL

/obj/item/ammo_casing/heavy_pistol
	desc = "A .45 (11x33mmRB) Nitro Magnum full metal jacket bullet casing."
	projectile_type = /obj/item/projectile/bullet/modern/heavy_pistol
	icon = 'icons/obj/ammo/casings/pistol.dmi'
	caliber = CALIBER_PISTOL_MAGNUM
	color = COLOR_GUNMETAL

/obj/item/ammo_casing/heavy_pistol/jhp
	desc = "A .45 (11x33mmRB) Nitro Magnum jacketed hollow point bullet casing."
	projectile_type = /obj/item/projectile/bullet/modern/heavy_pistol/jhp

/obj/item/ammo_casing/caseless/snapdragon
	caliber = CALIBER_RIFLE_SNAPDRAGON
	projectile_type = /obj/item/projectile/bullet/modern/snapdragon
	icon = 'icons/obj/ammo/casings/lasbulb.dmi'
	color = COLOR_GOLD
	bullet_color = "#c7e710"
	material = /decl/material/solid/cyclonite
	matter = list(/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/ammo_casing/c10x77
	name = "10x77-HS special casing"
	desc = "A heavy sniper bullet covered in a thin layer of carbon-carbon alloy."
	caliber = "10x77"
	projectile_type = /obj/item/projectile/bullet/modern/c10x77
	material = /decl/material/solid/metal/steel
	color = COLOR_GRAY20
	icon = 'icons/obj/ammo/casings/anti_materiel.dmi'

/obj/item/ammo_casing/magneticfletchette
	name = "3x20 railgun fletchette round"
	desc = "A special heatshielded round for high-speed flight."
	caliber = "3x20"
	projectile_type = /obj/item/projectile/bullet/magnetic
	material = /decl/material/solid/metal/titanium
	color = COLOR_GRAY20
	icon = 'icons/obj/ammo/casings/flechette.dmi'