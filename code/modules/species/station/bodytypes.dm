/decl/bodytype/human
	name =                "Male"
	bodytype_category =   BODYTYPE_HUMANOID
	icon_base =           'icons/mob/species/human/body_male.dmi'
	lip_icon =            'icons/mob/species/human/lips.dmi'
	blood_overlays =      'icons/mob/species/human/blood_overlays.dmi'
	bandages_icon =       'icons/mob/species/human/bandage.dmi'
	limb_icon_intensity = 0.7
	associated_gender =   MALE

/decl/bodytype/human/female
	name =                "Female"
	icon_base =           'icons/mob/species/human/body_female.dmi'
	associated_gender =   FEMALE
	uniform_state_modifier = "f"

/decl/bodytype/monkey
	name =              "Monkey"
	bodytype_category = BODYTYPE_MONKEY
	icon_base =         'icons/mob/species/monkey/monkey_body.dmi'
	blood_overlays =    'icons/mob/species/monkey/blood_overlays.dmi'
	health_hud_intensity = 1.75
	bodytype_flag = BODY_FLAG_MONKEY

/decl/bodytype/monkey/Initialize()
	equip_adjust = list(
		BP_L_HAND =          list("[NORTH]" = list("x" = 1, "y" = 3), "[EAST]" = list("x" = -3, "y" = 2), "[SOUTH]" = list("x" = -1, "y" = 3), "[WEST]" = list("x" = 3, "y" = 2)),
		BP_R_HAND =          list("[NORTH]" = list("x" = -1, "y" = 3), "[EAST]" = list("x" = 3, "y" = 2), "[SOUTH]" = list("x" = 1, "y" = 3), "[WEST]" = list("x" = -3, "y" = 2)),
		slot_shoes_str =     list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = -1, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 1, "y" = 7)),
		slot_head_str =      list("[NORTH]" = list("x" = 0, "y" = 0), "[EAST]" = list("x" = -2, "y" = 0), "[SOUTH]" = list("x" = 0, "y" = 0), "[WEST]" = list("x" = 2, "y" = 0)),
		slot_wear_mask_str = list("[NORTH]" = list("x" = 0, "y" = 0), "[EAST]" = list("x" = -1, "y" = 0), "[SOUTH]" = list("x" = 0, "y" = 0), "[WEST]" = list("x" = 1, "y" = 0))
	)
	. = ..()

/obj/item/organ/external/tail/monkey
	tail = "chimptail"

/decl/bodytype/xenomorph
	name =                "Xenomorph"
	bodytype_category =   BODYTYPE_HUMANOID
	icon_base =           'icons/mob/species/xenomorph/praetorian.dmi'
	blood_overlays =      'icons/mob/species/human/blood_overlays.dmi'
	bandages_icon =       'icons/mob/species/human/bandage.dmi'
	limb_icon_intensity = 0.7
	associated_gender =   FEMALE
	pixel_offset_x = -28
	pixel_offset_y = -22