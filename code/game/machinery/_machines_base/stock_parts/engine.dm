/obj/item/stock_parts/engine
	name = "tiny electric motor"
	desc = "A tiny copper-wire engine for small applications."
	icon = 'icons/obj/items/stock_parts/electric_motor.dmi'
	icon_state = "tiny"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/metal/steel = 100, /decl/material/solid/metal/copper = 200)
	base_type = /obj/item/stock_parts/engine
	w_class = ITEM_SIZE_TINY
	weight = 0.2
	rating = 0.5

/obj/item/stock_parts/engine/medium
	name = "electric motor"
	desc = "A medium-sized copper-wire electric motor for various applications."
	icon_state = "medium"
	matter = list(/decl/material/solid/metal/steel = 400, /decl/material/solid/metal/copper = 2000)
	w_class = ITEM_SIZE_NORMAL
	weight = 0.5
	rating = 1

/obj/item/stock_parts/engine/large
	name = "large electric motor"
	desc = "This motor is large and heavy."
	icon_state = "large"
	matter = list(/decl/material/solid/metal/stainlesssteel = 4000, /decl/material/solid/metal/silver = 8000)
	w_class = ITEM_SIZE_LARGE
	weight = 3
	rating = 3

/obj/item/stock_parts/engine/superconducting
	name = "superconducting electric motor"
	desc = "An exotic superconducting motor with extreme power density."
	icon_state = "superconducting"
	matter = list(/decl/material/solid/metal/titanium = 3200, /decl/material/solid/metal/tungsten = 1500)
	w_class = ITEM_SIZE_LARGE
	weight = 1.3
	rating = 10