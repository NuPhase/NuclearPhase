/obj/item/drill
	name = "handheld drill"
	desc = "A typical drill that can be found in any tech store. Could be, at least."
	icon = 'icons/obj/items/tool/powerdrill.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY | SLOT_EARS
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/metal/stainlesssteel
	center_of_mass = @"{'x':16,'y':7}"
	attack_verb = list("drilled")
	applies_material_colour = FALSE
	drop_sound = 'sound/foley/singletooldrop2.ogg'
	weight = 1.5

/obj/item/screwdriver/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_SCREWDRIVER = TOOL_QUALITY_GOOD))

/obj/item/screwdriver/equipped(mob/user, slot)
	. = ..()
	cut_overlays()
	add_overlay(list("inventory-screw"))

/obj/item/screwdriver/dropped(mob/user)
	. = ..()
	cut_overlays()
	add_overlay(list("world-screw"))