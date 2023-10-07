/mob/living/carbon/human
	var/arousal = 0 //0-1000
	var/pleasure = 0 //0-1000

/mob/living/carbon/human/proc/has_penis()
	if(gender == MALE && potenzia > -1 && species.genitals)
		return 1
	else return 0

/mob/living/carbon/human/proc/is_nude()
	var/have_blocking_underwear = FALSE
	for(var/piece in worn_underwear)
		if(!istype(piece, /obj/item/underwear/bottom))
			continue

		have_blocking_underwear = TRUE
	return (!_w_uniform ? 1 : 0) && !have_blocking_underwear

/mob/living/carbon/human/proc/get_sound_path(var/string = "")
	var/sound_path
	switch(string)
		if("squirt_short")
			sound_path = "honk/sound/new/ACTIONS/VAGINA/SQUIRT/SHORT/"
		if("squirt_long")
			sound_path = "honk/sound/new/ACTIONS/VAGINA/SQUIRT/LONG/"
		if("swallow")
			sound_path = "honk/sound/new/ACTIONS/MOUTH/SWALLOW/"
		if("climax_male")
			return "honk/sound/interactions/final_m[rand(1, 5)].ogg"
		if("climax_female")
			return "honk/sound/interactions/final_f[rand(1, 3)].ogg"
		if("ejaculation")
			sound_path = "honk/sound/new/ACTIONS/PENIS/CUM/"
	var/sound = pick(flist("[sound_path]"))
	return sound

/mob/living/carbon/human/proc/erosound_checked(var/string = "")
	if(is_muzzled())
		audible_message(SPAN_WARNING("[src]'s lewd sounds get muffled by their muzzle."))
		playsound(loc, get_sound_path(string), 10, 1, -6)
		return
	playsound(loc, get_sound_path(string), 100, 1, -5)

//force is 1-4
//target can be human, floor or underwear/clothing
/mob/living/carbon/human/proc/climax(var/atom/target, type = "surface", force = 1, var/atom/surface_reference)
	var/saved_pleasure = pleasure
	adjust_pleasure(pleasure * -1)
	if(gender == MALE)
		adjust_arousal(rand(-500, -1000))
		erosound_checked("climax_male")
		spawn(10)
			playsound(loc, get_sound_path("ejaculation"), 100, 1, -5)
		if(ishuman(target))
			var/mob/living/carbon/human/H_target = target
			switch(type)
				if("surface")
					H_target.add_examine_descriptor(SPAN_DESCRIPTION("[H_target.pronouns.He] smells of salt and expired chicken."), DESCRIPTOR_SMELL)
				if("oral")
					var/datum/reagents/stomach_internals = H_target.get_ingested_reagents()
					stomach_internals.add_reagent(/decl/material/liquid/semen, rand(10, 30))
					spawn(25 * force)
						playsound(H_target.loc, get_sound_path("swallow"), 100, 1, -5)
			to_chat(H_target, climax_message_receiver(type, force, target))
			to_chat(src, climax_message_giver(type, force, target))
			return
		if(isturf(target))
			var/turf/T = target
			new /obj/effect/decal/cleanable/cum(T)
			to_chat(src, climax_message_giver(type, force, target))
			return
		if(istype(target, /obj/item/clothing) || istype(target, /obj/item/underwear))
			return
	else
		adjust_arousal(rand(-100, -200))
		erosound_checked("climax_female")
		if(ishuman(target))
			var/mob/living/carbon/human/H_target = target
			switch(type)
				if("oral")
					H_target.add_examine_descriptor(SPAN_DESCRIPTION("[H_target.pronouns.His] face is covered in a sticky fluid."), DESCRIPTOR_DIRTINESS)
			to_chat(H_target, climax_message_receiver(type, force, target))
			to_chat(src, climax_message_giver(type, force, target))
			return
		if(isturf(target))
			if(saved_pleasure > MIN_SQUIRT_PLEASURE)
				playsound(loc, get_sound_path(pick("squirt_short", "squirt_long")), 100, 1, -5)
				var/turf/T = target
				var/obj/effect/decal/cleanable/cum/fem/f = new(T)
				var/obj/item/organ/external/groin/dam_groin = GET_EXTERNAL_ORGAN(src, BP_GROIN)
				if(dam_groin.damage > 10)
					blood_squirt(15, T)
				hydration -= 15
				f.add_fingerprint(src)
			to_chat(src, climax_message_giver(type, force))
			return
		if(istype(target, /obj/item/clothing) || istype(target, /obj/item/underwear))
			return