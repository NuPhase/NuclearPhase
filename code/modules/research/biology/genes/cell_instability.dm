/decl/genetic_trait/cell_instability
	name = "Minor Cell Instability"
	description = "The subject's cells are slightly unreliable in their division. They're more prone to genetic mutations."
	var/instability_mod = 1.5
	flag = GENE_FLAG_BAD

/decl/genetic_trait/cell_instability/process_effects(mob/living/carbon/human/H)
	. = ..()
	for(var/obj/item/organ/external/E in H.get_external_organs())
		if(!BP_IS_PROSTHETIC(E) && prob(0.01 * instability_mod) && !(E.status & ORGAN_MUTATED))
			E.mutate()
			E.limb_flags |= ORGAN_FLAG_DEFORMED

/decl/genetic_trait/cell_instability/medium
	name = "Medium Cell Instability"
	description = "The subject's cells ocasionally fail to divide properly. They're prone to genetic mutations and may acquire random mutations."
	instability_mod = 3

/decl/genetic_trait/cell_instability/major
	name = "Major Cell Instability"
	description = "The subject's genome slowly falls apart due to unstable cell division. They are very likely to get genetic mutations and cancerous growths. Their lifespan is shortened significantly."
	instability_mod = 10

/decl/genetic_trait/cell_instability/lethal
	name = "Lethal Cell Instability"
	description = "The subject's genome decays swiftly, resulting in major mutations and soon-to-follow death. Their lifespan is less than a full day."
	instability_mod = 50