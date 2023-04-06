/obj/item/clothing/under/undersuit
	name = "undersuit"
	desc = "This piece of clothing is designed specifically for use with pressure suits. It has active cooling thermal blankets, routing systems and can function as a G-suit."
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_robotics.dmi'
	permeability_coefficient = 0.4
	siemens_coefficient = 0.7
	armor = list(
		rad = ARMOR_RAD_MINOR,
		bio = ARMOR_BIO_MINOR
		)
	w_class = ITEM_SIZE_LARGE
	max_heat_protection_temperature = 420
	min_cold_protection_temperature = 260
	max_pressure_protection = 404
	min_pressure_protection = 40
	valid_accessory_slots = list(ACCESSORY_SLOT_MODULES)
	restricted_accessory_slots = list(ACCESSORY_SLOT_MODULES)

/obj/item/clothing/accessory/spinal_interface
	name = "spinal interface"
	desc = "A neural-network powered device that allows humans to interface with complex devices like exosuits. Attaches to undersuits."
	var/mob/living/carbon/human/bound_to = null
	slot = ACCESSORY_SLOT_MODULES
	icon = 'icons/clothing/accessories/modules/neural_interface.dmi'

/obj/item/clothing/accessory/spinal_interface/proc/activate(mob/living/carbon/human/user)
	if(!bound_to)
		bound_to = user
		to_chat(user, SPAN_NOTICE("Your spine tingles slightly as the [src] initializes."))
		return TRUE
	bound_to = user
	to_chat(user, SPAN_DANGER("Your muscles involuntarily contract all over the place as the [src] attempts to initialize!"))
	user.seizure()
	spawn(10 SECONDS)
		to_chat(user, SPAN_ERPBOLD("You feel as if your muscle memory was somehow entirely rewritten..."))
	return FALSE

/obj/item/clothing/accessory/spinal_connector
	name = "spinal connector"
	desc = "This device allows its user to connect their implanted spinal interface with any complex device. Attaches to undersuits."
	slot = ACCESSORY_SLOT_MODULES
	icon = 'icons/clothing/accessories/modules/neural_connector.dmi'