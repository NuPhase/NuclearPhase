/obj/item/dna_sample_kit
	name = "DNA sample kit"
	desc = "An all-in-one DNA sampling kit. Can take skin, bone marrow, brain matter and hair."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "sample_kit"
	w_class = ITEM_SIZE_NORMAL
	weight = 0.8

/obj/item/organic
	name = "organic matter"
	w_class = ITEM_SIZE_SMALL

	var/weakref/dna_owner = null
	var/dna_quality = 0 //0-100
	var/dna_contamination = 0 //0-100
	weight = 0.1

/obj/item/organic/skin //can be used to fully heal burns
	name = "skin piece"
	desc = "A piece of someone's skin."
	dna_quality = 20
	dna_contamination = 80

/obj/item/organic/bone_marrow //can be used to make blood and new bones
	name = "bone marrow chunk"
	desc = "A small, precision-cut piece of bone marrow."
	dna_quality = 100

/obj/item/organic/brain_matter //can be used to study damage, fix brains and calibrate neural interfaces
	name = "brain matter"
	desc = "Uh-oh, someone got their head drilled."
	dna_quality = 95

/obj/item/organic/hair //easily found on clothes, can be used for hair transplants
	name = "hair strand"
	desc = "A bunch of hair strands."
	dna_quality = 50
	dna_contamination = 30