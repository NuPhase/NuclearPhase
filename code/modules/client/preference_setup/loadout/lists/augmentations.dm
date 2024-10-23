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

/decl/loadout_option/augmentation/sleep_processor
	name = "memory processor"
	description = "A sophisticated data processing suite made to completely diminish the need for sleep in a user."
	path = /obj/item/organ/internal/augment/boost/sleep_processor
	cost = 110

/decl/loadout_option/augmentation/shooting
	name = "gunnery booster"
	description = "The AIM-4 module improves gun accuracy by filtering unnecessary nerve signals."
	path = /obj/item/organ/internal/augment/boost/shooting
	cost = 310