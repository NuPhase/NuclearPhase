/obj/item/organ/internal/brain/synthetic
	name = "main computational unit"
	desc = "This hefty gold-plated computer has a large 'M.C.U.' logo on its front. "
	color = COLOR_GOLD
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "computer"
	prosthetic_icon = "computer"
	prosthetic_dead_icon = "computer_broken"
	max_damage = 50 //a little more durable than other units
	relative_size = 40
	organ_properties = ORGAN_PROP_PROSTHETIC
	parent_organ = BP_CHEST
	weight = 14

/obj/item/organ/internal/brain/synthetic/do_install(mob/living/carbon/target, affected, in_place, update_icon, detached)
	. = ..()
	target.key = brainmob.last_ckey

/obj/item/organ/internal/brain/synthetic/Initialize(mapload, material_key, datum/dna/given_dna)
	. = ..()
	if(!owner)
		return
	var/random_identifier = rand(111, 999)
	if(owner.gender == MALE)
		desc += "A small sign on its side reads: 'Model: GeminusBeta-[random_identifier]'"
	else
		desc += "A small sign on its side reads: 'Model: ArcusBeta-[random_identifier]'"