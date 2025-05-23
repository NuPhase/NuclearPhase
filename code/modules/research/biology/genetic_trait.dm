#define GENE_FLAG_GOOD 1
#define GENE_FLAG_NEUTRAL 0
#define GENE_FLAG_BAD -1

/decl/genetic_trait
	var/name = "debug gene"
	var/description = "You shouldn't see this."
	var/flag = GENE_FLAG_NEUTRAL

/decl/genetic_trait/proc/process_effects(mob/living/carbon/human/H)
	return