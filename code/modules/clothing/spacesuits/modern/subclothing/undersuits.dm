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