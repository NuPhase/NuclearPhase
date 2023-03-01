/mob/living/carbon/human/xenomorph
	name = "xenomorph"
	icon = 'icons/mob/species/xenomorph/praetorian.dmi'
	icon_state = "Normal Praetorian Walking"

/mob/living/carbon/human/xenomorph/setup(var/species_name = SPECIES_XENOMORPH, var/datum/dna/new_dna = null)
	if(new_dna)
		species_name = new_dna.species
		src.dna = new_dna
	else if(!species_name)
		species_name = global.using_map.default_species //Humans cannot exist without a species!

	set_species(species_name)

	set_real_name("Xenomorph ([rand(111, 999)])")
	dna.ready_dna(src) //regen dna filler only if we haven't forced the dna already

	species.handle_pre_spawn(src)
	if(!LAZYLEN(get_external_organs()))
		species.create_missing_organs(src) //Syncs DNA when adding organs
	apply_species_cultural_info()
	species.handle_post_spawn(src)
	potenzia = (prob(80) ? rand(9, 14) : pick(rand(5, 13), rand(15, 20)))//funny
	resistenza = (prob(80) ? rand(150, 300) : pick(rand(10, 100), rand(350,600)))

/mob/living/carbon/human/xenomorph/refresh_visible_overlays()

	if(HasMovementHandler(/datum/movement_handler/mob/transformation) || QDELETED(src))
		return

	update_fire(FALSE)
	UpdateDamageIcon(FALSE)
	update_icon()

/mob/living/carbon/human/xenomorph/on_update_icon()
	SHOULD_CALL_PARENT(FALSE)
	pixel_x = -16
	if(incapacitated(INCAPACITATION_STUNNED))
		icon = icon(icon, "Normal Praetorian Knocked Down")
		return
	if(resting)
		icon = icon(icon, "Normal Praetorian Sleeping")
		return
	icon_state = "Normal Praetorian Walking"

/mob/living/carbon/human/xenomorph/update_transform()
	return