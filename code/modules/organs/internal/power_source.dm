//Power sources are implantable organs that power synthetics and cyborgs.
//Prosthetic biomechanical limbs shouldn't function without them.

/obj/item/organ/internal/power_source
	icon = 'icons/obj/items/stock_parts/modular_components.dmi'
	icon_state = "battery_ultra"
	prosthetic_icon = "battery_ultra"
	organ_properties = ORGAN_PROP_PROSTHETIC
	scale_max_damage_to_species_health = FALSE
	organ_tag = BP_POWER

/obj/item/organ/internal/power_source/proc/is_powered()
	return TRUE

//Implement internally, should return the amount of power actually consumed.
/obj/item/organ/internal/power_source/proc/consume_power(amount)
	return amount

/obj/item/organ/internal/power_source/battery
	name = "integrated battery"
	desc = "A compact battery to be installed in someone."
	var/charge = 300 //watt/hour
	relative_size = 10
	parent_organ = BP_CHEST

/obj/item/organ/internal/power_source/battery/is_powered()
	return charge


//we place the power source in the head to allow for air cooling through the nose
/obj/item/organ/internal/power_source/reactor
	name = "closed cycle RTG"
	desc = "It looks like some kind of nuclear electric power generator. What was this doing inside a person's head?"
	relative_size = 75
	parent_organ = BP_HEAD

	max_damage = 90 //nuclear casket lol
	min_bruised_damage = 70
	weight = 5

/obj/item/organ/internal/power_source/reactor/die()
	. = ..()
	SSradiation.radiate(src, 12)