//Detects broken wiring, tesla coils, magnetic fields and other similiar dangers.
#define HOT_STICK_RANGE 6

/obj/item/hot_stick
	name = "EMF hot stick"
	desc = "A safety device designed to detect various electrical hazards."
	icon = 'icons/obj/items/tool/hotstick.dmi'
	icon_state = ICON_STATE_WORLD
	var/sensitivity = 0.7 //a range modifier
	w_class = ITEM_SIZE_LARGE
	weight = 0.3

#undef HOT_STICK_RANGE