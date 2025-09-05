/obj/item/stack/material/blankets
	name = "blanket"
	desc = "These blankets have a variety of uses, ranging from medical to engineering applications."
	singular_name = "blanket"
	plural_name = "blankets"
	icon_state = "blanket"
	plural_icon_state = "blanket-mult"
	max_icon_state = "blanket-max"
	w_class = ITEM_SIZE_NORMAL
	attack_cooldown = 21
	melee_accuracy_bonus = -20
	throw_speed = 5
	throw_range = 20
	max_amount = 20
	attack_verb = list("whacked")
	lock_picking_level = 3
	matter_multiplier = 0.3
	material = /decl/material/solid/metal/steel

	pickup_sound = list('sound/foley/tooldrop1.ogg', 'sound/foley/tooldrop2.ogg', 'sound/foley/tooldrop3.ogg')
	drop_sound = list('sound/foley/tooldrop1.ogg', 'sound/foley/tooldrop2.ogg', 'sound/foley/tooldrop3.ogg')

/obj/item/stack/material/blankets/fiberglass
	desc = "Fiberglass blankets are often used as broken bone casts."
	material = /decl/material/solid/fiberglass

/obj/item/stack/material/blankets/inconel
	name = "inconel blankets"
	desc = "Inconel blankets are famous for their resistance to oxidation. They are often found on rocket engines and high-temperature pipes."
	material = /decl/material/solid/metal/inconel