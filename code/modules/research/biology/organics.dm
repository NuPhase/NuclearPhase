/obj/item/organic
	name = "organic matter"

	var/dna_owner = null
	var/dna_quality = 0 //0-100
	var/dna_contamination = 0 //0-100

/obj/item/organic/skin //can be used to fully heal burns
	name = "skin piece"
	desc = "A piece of someone's skin."
	dna_quality = 20
	dna_contamination = 80

/obj/item/organic/bone_marrow //can be used to make blood and new bones
	name = "bone marrow chunk"
	desc = "A small, precision-cut piece of bone marrow."
	dna_quality = 100

/obj/item/organic/brain_matter //can be used to study damage and calibrate neural interfaces
	name = "brain matter"
	desc = "Uh-oh, someone got their head drilled."
	dna_quality = 95

/obj/item/organic/hair //easily found on clothes, can be used for hair transplants
	name = "hair strand"
	desc = "A bunch of hair strands."
	dna_quality = 50
	dna_contamination = 30