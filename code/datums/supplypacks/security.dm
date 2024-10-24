/decl/hierarchy/supply_pack/security
	name = "Security"

/decl/hierarchy/supply_pack/security/specialops
	name = "Grenades - Special Ops supplies"
	contains = list(/obj/item/storage/box/emps,
					/obj/item/grenade/smokebomb = 3,
					/obj/item/grenade/incendiary)
	containername = "special ops crate"
	hidden = 1

/decl/hierarchy/supply_pack/security/lightarmor
	name = "Armor - Light"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/light = 4,
					/obj/item/clothing/head/helmet =4)
	containertype = /obj/structure/closet/crate/secure
	containername = "light armor crate"
	access = access_security

/decl/hierarchy/supply_pack/security/armor
	name = "Armor - Unmarked"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/medium = 2,
					/obj/item/clothing/head/helmet =2)
	containertype = /obj/structure/closet/crate/secure
	containername = "armor crate"
	access = access_security

/decl/hierarchy/supply_pack/security/tacticalarmor
	name = "Armor - Tactical"
	contains = list(/obj/item/clothing/under/tactical,
					/obj/item/clothing/suit/armor/pcarrier/green/tactical,
					/obj/item/clothing/head/helmet/tactical,
					/obj/item/clothing/mask/balaclava/tactical,
					/obj/item/clothing/glasses/tacgoggles,
					/obj/item/storage/belt/holster/security/tactical,
					/obj/item/clothing/shoes/jackboots/tactical,
					/obj/item/clothing/gloves/tactical)
	containertype = /obj/structure/closet/crate/secure
	containername = "tactical armor crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/blackguards
	name = "Armor - Arm and leg guards, black"
	contains = list(/obj/item/clothing/accessory/armguards = 2,
					/obj/item/clothing/accessory/legguards = 2)
	containertype = /obj/structure/closet/crate/secure
	containername = "arm and leg guards crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/riotarmor
	name = "Armor - Riot gear"
	contains = list(/obj/item/shield/riot = 4,
					/obj/item/clothing/head/helmet/riot = 4,
					/obj/item/clothing/suit/armor/riot = 4,
					/obj/item/storage/box/flashbangs,
					/obj/item/storage/box/teargas)
	containertype = /obj/structure/closet/crate/secure
	containername = "riot armor crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/ballisticarmor
	name = "Armor - Ballistic"
	contains = list(/obj/item/clothing/head/helmet/ballistic = 4,
					/obj/item/clothing/suit/armor/bulletproof = 4)
	containertype = /obj/structure/closet/crate/secure
	containername = "ballistic suit crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/ablativearmor
	name = "Armor - Ablative"
	contains = list(/obj/item/clothing/head/helmet/ablative = 4,
					/obj/item/clothing/suit/armor/laserproof = 4)
	containertype = /obj/structure/closet/crate/secure
	containername = "ablative suit crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/weapons
	name = "Weapons - Security basic"
	contains = list(/obj/item/flash = 4,
					/obj/item/chems/spray/pepper = 4,
					/obj/item/baton/loaded = 4,
					/obj/item/gun/energy/taser = 4)
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "weapons crate"
	access = access_security

/decl/hierarchy/supply_pack/security/egun
	name = "Weapons - Energy sidearms"
	contains = list(/obj/item/gun/energy/gun/secure = 4)
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "energy sidearms crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/egun/shady
	name = "Weapons - Energy sidearms (For disposal)"
	contains = list(/obj/item/gun/energy/gun = 4)
	contraband = 1
	security_level = null

/decl/hierarchy/supply_pack/security/ion
	name = "Weapons - Electromagnetic"
	contains = list(/obj/item/gun/energy/ionrifle = 2,
					/obj/item/storage/box/emps)
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "electromagnetic weapons crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/shotgun
	name = "Weapons - Shotgun"
	contains = list(/obj/item/gun/projectile/shotgun/pump = 2)
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "shotgun crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/flashbang
	name = "Weapons - Flashbangs"
	contains = list(/obj/item/storage/box/flashbangs = 2)
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "flashbang crate"
	access = access_security

/decl/hierarchy/supply_pack/security/teargas
	name = "Weapons - Tear gas grenades"
	contains = list(/obj/item/storage/box/teargas = 2)
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "tear gas grenades crate"
	access = access_security

/decl/hierarchy/supply_pack/security/shotgunammo
	name = "Ammunition - Lethal shells"
	contains = list(/obj/item/storage/box/ammo/shotgunammo = 2,
					/obj/item/storage/box/ammo/shotgunshells = 2)
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "lethal shotgun shells crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/shotgunbeanbag
	name = "Ammunition - Beanbag shells"
	contains = list(/obj/item/storage/box/ammo/beanbags = 3)
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "beanbag shotgun shells crate"
	access = access_security

/decl/hierarchy/supply_pack/security/pdwammo
	name = "Ammunition - SMG top mounted"
	contains = list(/obj/item/ammo_magazine/smg = 4)
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "SMG ammunition crate"
	access = access_security
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/pdwammorubber
	name = "Ammunition - SMG top mounted rubber"
	contains = list(/obj/item/ammo_magazine/smg/rubber = 4)
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "SMG rubber ammunition crate"
	access = access_security

/decl/hierarchy/supply_pack/security/pdwammopractice
	name = "Ammunition - SMG top mounted practice"
	contains = list(/obj/item/ammo_magazine/smg/practice = 8)
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "SMG practice ammunition crate"
	access = access_security

/decl/hierarchy/supply_pack/security/bullpupammo
	name = "Ammunition - military rifle"
	contains = list(/obj/item/ammo_magazine/rifle = 4)
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "military rifle ammunition crate"
	access = access_security
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/bullpupammopractice
	name = "Ammunition - military rifle practice"
	contains = list(/obj/item/ammo_magazine/rifle/practice = 8)
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "military rifle practice ammunition crate"
	access = access_security

/decl/hierarchy/supply_pack/security/forensics //Not access-restricted so PIs can use it.
	name = "Forensics - Auxiliary tools"
	contains = list(/obj/item/forensics/sample_kit,
					/obj/item/forensics/sample_kit/powder,
					/obj/item/forensics/sample_kit/swabs = 3,
					/obj/item/chems/spray/luminol)
	containername = "auxiliary forensic tools crate"

/decl/hierarchy/supply_pack/security/detectivegear
	name = "Forensics - investigation equipment"
	contains = list(/obj/item/storage/box/evidence = 2,
					/obj/item/radio/headset/headset_sec,
					/obj/item/stack/tape_roll/barricade_tape/police,
					/obj/item/clothing/glasses/sunglasses,
					/obj/item/camera,
					/obj/item/folder/red,
					/obj/item/folder/blue,
					/obj/item/clothing/gloves/forensic,
					/obj/item/taperecorder,
					/obj/item/scanner/spectrometer,
					/obj/item/camera_film = 2,
					/obj/item/storage/photo_album,
					/obj/item/scanner/reagent,
					/obj/item/storage/briefcase/crimekit = 2)
	containertype = /obj/structure/closet/crate/secure
	containername = "forensic equipment crate"
	access = access_forensics_lockers

/decl/hierarchy/supply_pack/security/securitybarriers
	name = "Equipment - Barrier crate"
	contains = list(/obj/machinery/deployable/barrier = 4)
	containertype = /obj/structure/closet/crate/secure/large
	containername = "security barrier crate"
	access = access_security

/decl/hierarchy/supply_pack/security/securitybarriers
	name = "Equipment - Wall shield Generators"
	contains = list(/obj/machinery/shieldwallgen = 2)
	containertype = /obj/structure/closet/crate/secure/large
	containername = "wall shield generators crate"
	access = access_brig

/decl/hierarchy/supply_pack/security/securitybiosuit
	name = "Gear - Security biohazard gear"
	contains = list(/obj/item/clothing/head/bio_hood/security,
					/obj/item/clothing/suit/bio_suit/security,
					/obj/item/clothing/mask/gas,
					/obj/item/tank/oxygen,
					/obj/item/clothing/gloves/latex)
	containertype = /obj/structure/closet/crate/secure
	containername = "security biohazard gear crate"
	access = access_security

/decl/hierarchy/supply_pack/security/voidsuit_security
	name = "EVA - Security (armored) voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/security/alt,
					/obj/item/clothing/head/helmet/space/void/security/alt,
					/obj/item/clothing/shoes/magboots)
	containername = "security voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_brig
