//Modular plate carriers
/obj/item/clothing/suit/armor/pcarrier
	name = "plate carrier"
	desc = "A lightweight plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon = 'icons/clothing/suit/armor/pcarrier_black.dmi'
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_C, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_C, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)
	material = /decl/material/solid/leather
	starting_accessories = null

/obj/item/clothing/suit/armor/pcarrier/handle_shield(mob/user, damage, atom/damage_source, mob/attacker, def_zone, attack_text)
	for(var/obj/item/clothing/accessory/acc_decl in accessories)
		if(acc_decl.handle_shielding(user, damage, damage_source, attacker, def_zone))
			playsound(user, 'sound/effects/armor_reflect.wav', 60, 1, -2)
			return 1
	return 0

/obj/item/clothing/suit/armor/pcarrier/light
	starting_accessories = list(/obj/item/clothing/accessory/armor/plate)

/obj/item/clothing/suit/armor/pcarrier/blue
	name = "blue plate carrier"
	icon = 'icons/clothing/suit/armor/pcarrier_blue.dmi'

/obj/item/clothing/suit/armor/pcarrier/blue/press
	starting_accessories = list(/obj/item/clothing/accessory/armor/plate, /obj/item/clothing/accessory/armor/tag/press)

/obj/item/clothing/suit/armor/pcarrier/green
	name = "green plate carrier"
	icon = 'icons/clothing/suit/armor/pcarrier_green.dmi'

/obj/item/clothing/suit/armor/pcarrier/medium
	starting_accessories = list(/obj/item/clothing/accessory/armor/plate/medium, /obj/item/clothing/accessory/storage/pouches)


/obj/item/clothing/suit/armor/pcarrier/tan
	name = "tan plate carrier"
	icon = 'icons/clothing/suit/armor/pcarrier_tan.dmi'
