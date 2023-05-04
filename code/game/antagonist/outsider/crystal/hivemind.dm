/decl/special_role/crystal_hivemind
	name = "Crystal Hivemind"
	welcome_text = "..."
	flags = ANTAG_OVERRIDE_MOB | ANTAG_OVERRIDE_JOB
	mob_path = /mob/living/crystal_hivemind

/mob/living/crystal_hivemind //stationary. Think of the blob.
	name = "Patient Zero"
	desc = "A barely recognizable crystal mass merged with something that looks like a human."
	var/eye_type = /mob/observer/eye/freelook
	var/datum/visualnet/eyenet
	universal_understand = TRUE
	mob_sort_value = 5

	meat_type = null
	meat_amount = 0
	skin_material = null
	skin_amount = 0
	bone_material = null
	bone_amount = 0

	var/organic_matter = 100
	var/crystal_matter = 100

/mob/living/crystal_hivemind/Initialize()
	. = ..()
	eyenet = new()
	eyeobj = new eye_type(get_turf(src), eyenet)
	eyeobj.possess(src)
	eyenet.add_source(src)