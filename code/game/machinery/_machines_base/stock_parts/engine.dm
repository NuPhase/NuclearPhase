/obj/item/stock_parts/engine
	name = "tiny electric engine"
	desc = "A tiny copper-wire engine for small applications."
	icon_state = "advanced_matter_bin"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/metal/steel = 100, /decl/material/solid/metal/copper = 200)
	base_type = /obj/item/stock_parts/engine
	w_class = ITEM_SIZE_TINY
	weight = 0.2

/obj/item/stock_parts/engine/medium
	name = "electric engine"
	desc = "A medium-sized copper-wire electric engine for various applications."
	matter = list(/decl/material/solid/metal/steel = 400, /decl/material/solid/metal/copper = 2000)
	base_type = /obj/item/stock_parts/engine/medium
	w_class = ITEM_SIZE_NORMAL
	weight = 0.5

/obj/item/stock_parts/engine/large
	name = "large electric engine"
	desc = "This engine is large and heavy."
	matter = list(/decl/material/solid/metal/stainlesssteel = 4000, /decl/material/solid/metal/silver = 8000)
	base_type = /obj/item/stock_parts/engine/large
	w_class = ITEM_SIZE_LARGE
	weight = 3