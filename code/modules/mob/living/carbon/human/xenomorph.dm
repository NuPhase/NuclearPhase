/mob/living/carbon/human/xenomorph
	name = "xenomorph"
	icon = 'icons/mob/species/xenomorph/praetorian.dmi'
	icon_state = "Normal Praetorian Walking"
	default_pixel_x = -16

/mob/living/carbon/human/xenomorph/process_hemodynamics()
	var/obj/item/organ/internal/heart/heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
	bpm = heart.pulse + heart.external_pump
	tpvr = rand(345, 370)
	if(bpm)
		syspressure = rand(190, 240)
		dyspressure = rand(180, 190)
		mcv = rand(7600, 7900)
	else
		syspressure = 0
		dyspressure = 0
		mcv = 0

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
	potenzia = rand(40, 60)
	resistenza = (prob(80) ? rand(400, 600) : pick(rand(200, 400), rand(600,1200)))

/mob/living/carbon/human/xenomorph/refresh_visible_overlays()

	if(HasMovementHandler(/datum/movement_handler/mob/transformation) || QDELETED(src))
		return

	update_fire(FALSE)
	UpdateDamageIcon(FALSE)
	update_icon()

/mob/living/carbon/human/xenomorph/UpdateLyingBuckledAndVerbStatus()
	. = ..()
	pixel_x = -16
	if(incapacitated(INCAPACITATION_STUNNED))
		icon = icon(icon, "Normal Praetorian Knocked Down")
		return
	if(lying)
		icon = icon(icon, "Normal Praetorian Sleeping")
		return
	icon_state = "Normal Praetorian Walking"

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