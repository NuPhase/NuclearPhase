/obj/item/organ/internal/brain/synthetic
	name = "main computational unit"
	desc = "This hefty computer has a large 'M.C.U.' logo on its front. "
	max_damage = 50 //a little more durable than other units
	relative_size = 40
	organ_properties = ORGAN_PROP_PROSTHETIC
	parent_organ = BP_CHEST

/obj/item/organ/internal/brain/synthetic/Initialize(mapload, material_key, datum/dna/given_dna)
	. = ..()
	if(!owner)
		return
	var/random_identifier = rand(111, 999)
	if(owner.gender == MALE)
		desc += "A small sign on its side reads: 'Model: GeminusBeta-[random_identifier]'"
	else
		desc += "A small sign on its side reads: 'Model: ArcusBeta-[random_identifier]'"