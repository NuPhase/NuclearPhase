/decl/loadout_category/augmentation
	name = "Augmentations"

/decl/loadout_option/augmentation
	category = /decl/loadout_category/augmentation
	flags = GEAR_NO_EQUIP | GEAR_NO_FINGERPRINTS
	custom_setup_proc = /obj/item/proc/AttemptAugmentation
	custom_setup_proc_arguments = list(BP_CHEST)

/obj/item/proc/AttemptAugmentation(mob/user, target_zone)
	to_chat(user, SPAN_DANGER("Was unable to augment you with \the [src]."))
	qdel(src)