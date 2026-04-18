/zone
	var/datum/composite_sound/metal_groan/groan_loop
	var/datum/composite_sound/fire_noise/fire_loop

/zone/proc/update_ambience()
	if(air.return_pressure() > ONE_ATMOSPHERE*5)
		groan_loop ||= new(list(pick(contents)), TRUE)
	else if(groan_loop)
		QDEL_NULL(groan_loop)
	if(length(fire_tiles))
		fire_loop ||= new(list(pick(contents)), TRUE)
	else if(fire_loop)
		QDEL_NULL(fire_loop)

/datum/composite_sound/metal_groan
	mid_sounds = list('sound/ambience/metal/groan1.mp3'=1, 'sound/ambience/metal/groan2.mp3'=1, 'sound/ambience/metal/groan3.mp3'=1)
	mid_length = 30
	volume = 70
	sfalloff = 3
	distance = 10

/datum/composite_sound/fire_noise
	mid_sounds = list('sound/ambience/objects/fire1.mp3'=1, 'sound/ambience/objects/fire2.mp3'=1, 'sound/ambience/objects/fire3.mp3'=1)
	mid_length = 30
	volume = 50
	sfalloff = 2
	distance = 8