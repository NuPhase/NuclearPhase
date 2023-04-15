//we place the power source in the head to allow for air cooling through the nose

/obj/item/organ/internal/reactor
	name = "closed cycle RTG"
	desc = "It looks like some kind of electric power generator. What was this doing inside a person's head?"
	icon = 'icons/obj/items/stock_parts/modular_components.dmi'
	icon_state = "battery_ultra"
	prosthetic_icon = "battery_ultra"
	organ_properties = ORGAN_PROP_PROSTHETIC

	scale_max_damage_to_species_health = FALSE
	relative_size = 75
	parent_organ = BP_HEAD

	max_damage = 90 //nuclear casket lol
	min_bruised_damage = 70
	weight = 5

/obj/item/organ/internal/reactor/die()
	. = ..()
	SSradiation.radiate(src, 12)