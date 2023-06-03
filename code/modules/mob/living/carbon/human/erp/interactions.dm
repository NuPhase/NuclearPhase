/**********************************
*******Interactions code by HONKERTRON feat TestUnit with translations and code edits by Matt********
**Contains a lot ammount of ERP and MEHANOYEBLYA**
***********************************/

#define FUCK_COOLDOWN_DEFAULT 7

/obj/effect/decal/cleanable/cum
	name = "cream"
	desc = "It's pie cream from a cream pie. Or not..."
	density = 0
	layer = 2
	icon = 'honk/icons/effects/cum.dmi'
	anchored = 1
	random_icon_states = list("cum1", "cum2", "cum3", "cum4", "cum5", "cum6", "cum7", "cum8", "cum9", "cum10", "cum11", "cum12")

/obj/effect/decal/cleanable/cum/attack_hand(mob/living/carbon/human/user)
	. = ..()
	visible_message(SPAN_CUMZONE("[user] licks [src] from the floor."))
	user.nutrition += 5
	qdel(src)

/obj/effect/decal/cleanable/cum/New()
	..()
	icon_state = pick(random_icon_states)

/obj/effect/decal/cleanable/cum/fem
	name = "slippery liquid"
	desc = "Uhh... Someone had fun..."
	icon = 'honk/icons/effects/lewd_decals.dmi'
	random_icon_states = list("femcum_1", "femcum_2", "femcum_3", "femcum_4")

/decl/material/liquid/semen
	solid_name = "semen"
	gas_name = "semen"
	liquid_name = "semen"
	uid = "liquid_semen"
	lore_text = "Something hot and full of love."
	exoplanet_rarity = MAT_RARITY_NOWHERE
	ingest_met = 1
	taste_description = "Something hot and full of love..."
	color = "#FFFFFF" // rgb: 255, 255, 255

/decl/material/liquid/semen/on_mob_life(mob/living/M, metabolism_class, datum/reagents/holder)
	. = ..()
	if(prob(1))
		to_chat(M, SPAN_CUMZONE("You feel something hot and full of love at your face..."))

/mob/living/carbon/human/receive_mouse_drop(mob/M as mob, mob/user as mob)
	if(M == src || src == usr || M != usr)		return
	if(usr.restrained())		return

	var/mob/living/carbon/human/H = usr
	H.partner = src
	make_interaction(machine)

/mob/proc/make_interaction()
	return

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

/decl/species/human
	genitals = TRUE
	anus = TRUE

/mob/living/carbon/human/proc/get_pleasure_amt(hole)
	switch (hole)
		if ("anal")
			return 7 - (potenzia/5)
		if ("anal-2")
			return get_pleasure_amt("anal") * 0.50
		if ("vaginal")
			switch (potenzia)
				if (-INFINITY to 9)
					return potenzia * 0.33
				if (9 to 16)
					return potenzia * 0.66
				if (16 to INFINITY)
					return potenzia * 1.00
		if ("vaginal-2")
			return get_pleasure_amt("vaginal") * 2

/mob/living/carbon/human/make_interaction()
	set_machine(src)

	var/mob/living/carbon/human/H = usr
	var/mob/living/carbon/human/P = H.partner
	var/obj/item/organ/external/temp =  GET_EXTERNAL_ORGAN(H, BP_R_HAND)
	var/hashands = (temp && temp.is_usable())
	if (!hashands)
		temp = GET_EXTERNAL_ORGAN(H, BP_L_HAND)
		hashands = (temp && temp.is_usable())
	temp = GET_EXTERNAL_ORGAN(P, BP_R_HAND)
	var/hashands_p = (temp && temp.is_usable())
	if (!hashands_p)
		temp = GET_EXTERNAL_ORGAN(P, BP_L_HAND)
		hashands = (temp && temp.is_usable())
	var/mouthfree = !(H._wear_mask) && !(H._head && (H._head.body_parts_covered & SLOT_FACE))
	var/mouthfree_p = !(P._wear_mask) && !(P._head && (P._head.body_parts_covered & SLOT_FACE))
	var/haspenis = H.has_penis()
	var/haspenis_p = P.has_penis()
	var/hasvagina = (H.gender == FEMALE && H.species.genitals)
	var/hasvagina_p = (P.gender == FEMALE && P.species.genitals)
	var/hasanus_p = P.species.anus
	var/isnude = H.is_nude()
	var/isnude_p = P.is_nude()
	var/noboots = !P._shoes

	H.lastfucked = null
	H.lfhole = ""

	var/dat = "<B><HR><FONT size=3>INTERACTIONS - [H.partner]</FONT></B><BR><HR>"

	dat +=  {"<A href='?src=\ref[usr];interaction=bow'>Bow.</A><BR>"}
	if (hashands)
		if(H.partner.get_age() >= 16)
			if(H.partner.species.name == "Human")
				dat +=  {"<font size=3><B>Hands:</B></font><BR>"}
				if(get_dist(H,P) <= 1)
					if (Adjacent(P))
						dat +=  {"<A href='?src=\ref[usr];interaction=handshake'>Give handshake.</A><BR>"}
						dat +=  {"<A href='?src=\ref[usr];interaction=hug'>Hug!</A><BR>"}
						dat +=  {"<A href='?src=\ref[usr];interaction=cheer'>Cheer!</A><BR>"}
						dat +=  {"<A href='?src=\ref[usr];interaction=five'>Highfive.</A><BR>"}
						if (hashands_p)
							dat +=  {"<A href='?src=\ref[usr];interaction=slap'><font color=red>Slap!</font></A><BR>"}
						if (hasanus_p)
							dat += {"<A href='?src=\ref[usr];interaction=assslap'><font color=purple>Slap some ass!</font></A><BR>"}
						if (isnude_p)
							if(P.gender == FEMALE)
								dat += {"<A href='?src=\ref[usr];interaction=squeezebreast'><font color=purple>Squeeze breasts!</font></A><BR>"}
							if (hasvagina_p)
								dat += {"<A href='?src=\ref[usr];interaction=fingering'><font color=purple>Put fingers in places...</font></A><BR>"}
						dat +=  {"<A href='?src=\ref[usr];interaction=knock'><font color=red>Knock upside the head.</font></A><BR>"}
				dat +=  {"<A href='?src=\ref[usr];interaction=fuckyou'><font color=red>Insult.</font></A><BR>"}
				dat +=  {"<A href='?src=\ref[usr];interaction=threaten'><font color=red>Threaten.</font></A><BR>"}

	if (mouthfree && (lying == P.lying || !lying))
		if(H.partner.get_age() >= 16)
			if(H.partner.species.name == "Human")
				dat += {"<font size=3><B>Mouth:</B></font><BR>"}
				dat += {"<A href='?src=\ref[usr];interaction=kiss'><font color=purple>Kiss.</font></A><BR>"}
				if(noboots)
					dat += {"<A href='?src=\ref[usr];interaction=footlick'><font color=purple>Lick feet</font></A><BR>"}
				if(get_dist(H,P) <= 1)
					if (Adjacent(P) && isnude_p)
						if (haspenis_p)
							dat += {"<A href='?src=\ref[usr];interaction=handjob'><font color=purple>Masturbate.</font></A><BR>"}
							dat += {"<A href='?src=\ref[usr];interaction=blowjob'><font color=purple>Give head.</font></A><BR>"}
							dat += {"<A href='?src=\ref[usr];interaction=ballsuck'><font color=purple>Suck balls.</font></A><BR>"}
						if (hasvagina_p)
							dat += {"<A href='?src=\ref[usr];interaction=vaglick'><font color=purple>Lick pussy.</font></A><BR>"}
						dat +=  {"<A href='?src=\ref[usr];interaction=spit'><font color=red>Spit.</font></A><BR>"}
					dat +=  {"<A href='?src=\ref[usr];interaction=tongue'><font color=red>Stick out tongue.</font></A><BR>"}

	if (isnude && usr.loc == H.partner.loc)
		if(H.partner.get_age() >= 16)
			if(H.partner.species.name == "Human")
				if(get_dist(H,P) <= 1)
					if (haspenis && hashands)
						dat += {"<font size=3><B>MISTAKES WILL BE MADE:</B></font><BR>"}
						if (isnude_p)
							if(get_dist(H,P) <= 0)
								dat += {"<A href='?src=\ref[usr];interaction=vaginal'><font color=purple>Fuck vagina.</font></A><BR>"}
								if (hasanus_p)
									dat += {"<A href='?src=\ref[usr];interaction=anal'><font color=purple>Fuck ass.</font></A><BR>"}
							if (mouthfree_p)
								dat += {"<A href='?src=\ref[usr];interaction=oral'><font color=purple>Fuck mouth.</font></A><BR>"}
					if (isnude && usr.loc == H.partner.loc && hashands && get_dist(H,P) <= 0)
						if (hasvagina && haspenis_p)
							dat += {"<font size=3><B>Vagina:</B></font><BR>"}
							dat += {"<A href='?src=\ref[usr];interaction=mount'><font color=purple>Mount!</font></A><BR><HR>"}

	var/datum/browser/popup = new(usr, "interactions", "Interactions", 340, 480)
	popup.set_content(dat)
	popup.open()

//INTERACTIONS
/mob/living/carbon/human
	var/mob/living/carbon/human/partner
	var/mob/living/carbon/human/lastfucked
	var/lfhole
	var/lust = 0
	var/multiorgasms = 0
	var/lastmoan
	var/erpcooldown = 1
	var/virgin = FALSE //:mistake:
	var/fuckcooldown = 0

/mob/living/carbon/human/AltClick(mob/user)
	if(src != user)
		. = ..()
		return
	SHOULD_CALL_PARENT(FALSE)
	masturbate()

/mob/living/carbon/human/proc/masturbate()
	if(fuckcooldown > world.time)
		return
	fuckcooldown = world.time + FUCK_COOLDOWN_DEFAULT
	var/message = ""
	var/sound = ""
	var/obj/item/organ/external/temp =  GET_EXTERNAL_ORGAN(src, BP_R_HAND)
	var/hashands = (temp && temp.is_usable())
	if (!hashands)
		temp = GET_EXTERNAL_ORGAN(src, BP_L_HAND)
		hashands = (temp && temp.is_usable())
	var/mouthfree = !(_wear_mask) && !(_head && (_head.body_parts_covered & SLOT_FACE))
	var/haspenis = has_penis()
	var/hasvagina = (gender == FEMALE && species.genitals)
	var/isnude = is_nude()
	if(!hashands)
		return

	if(zone_sel.selecting == BP_GROIN)
		if(isnude)
			if(haspenis && erpcooldown == 0)
				message = pick("strokes his dick.", "masturbates his penis.")
				if (lust < 6)
					lust += 6
				visible_message(SPAN_ERPBOLD("[src] ") + SPAN_ERP(message))
				lust += 8
				if (lust >= resistenza)
					cum(src, src)
				else
					moan()
				if(prob(50))
					sound = pick(flist("honk/sound/new/ACTIONS/PENIS/HANDJOB/"))
					playsound(loc, "honk/sound/new/ACTIONS/PENIS/HANDJOB/[sound]", 90, 1, -5)
				do_fucking_animation(src)
				if (prob(potenzia))
					visible_message(SPAN_ERPBOLD("[src] " + SPAN_ERP("strokes <B>his's</B> [pick("cock","dick","penis")] faster")))

			else if(hasvagina)
				message = pick("fingers herself.", "fingers her pussy.")
				if (prob(35))
					message = pick("fingers herself hard.")
				if (!lfhole)
					message = "shoves their fingers into pussy."
					sound = "honk/sound/new/ACTIONS/VAGINA/INSERTION/"
					playsound(loc, "honk/sound/new/ACTIONS/VAGINA/INSERTION/[sound]", 90, 1, -5)
					lastfucked = src
					lfhole = "vagina"
				if (prob(5) && stat != DEAD)
					lust += 8
				visible_message(SPAN_ERPBOLD("[src] ") + SPAN_ERP(message))
				lust += 8
				if (lust >= resistenza)
					cum(src, src)
				else
					moan(rand(1, 15))
				sound = pick(flist("honk/sound/new/ACTIONS/VAGINA/TOUCH/"))
				playsound(loc, ("honk/sound/new/ACTIONS/VAGINA/TOUCH/[sound]"), 90, 1, -5)
				do_fucking_animation(src)

		else if(hasvagina)
			message = pick("gently rubs her pussy.", "pats her pussy.")
			visible_message(SPAN_ERPBOLD("[src] ") + SPAN_ERP(message))
			lust += 4
			if (lust >= resistenza)
				cum(src, src)
			else
				moan()
			sound = pick(flist("honk/sound/new/ACTIONS/HANDS/RUB/CLOTHES/"))
			playsound(loc, ("honk/sound/new/ACTIONS/HANDS/RUB/CLOTHES/[sound]"), 40, 1, -5)
			do_fucking_animation(src)

	if(zone_sel.selecting == BP_MOUTH && mouthfree)
		var/decl/pronouns/G = get_pronouns()
		message = pick("licks [G.his] finger.", "sucking [G.his] fingers.")
		visible_message(SPAN_ERPBOLD("[src] ") + SPAN_ERP(message))
		if(lust+50 <= resistenza)
			lust += 2
		else if(lust+100 >= resistenza)
			moan()
		sound = pick(flist("honk/sound/new/ACTIONS/MOUTH/SUCK/"))
		playsound(loc, ("honk/sound/new/ACTIONS/MOUTH/SUCK/[sound]"), 40, 1, -5)

/mob/living/carbon/human/proc/cum(mob/living/carbon/human/H as mob, mob/living/carbon/human/P as mob, var/hole = "floor")
	var/sound
	var/sound_path
	var/message = ""
	var/turf/T

	switch(H.gender)
		if(MALE)
			playsound(loc, "honk/sound/interactions/final_m[rand(1, 5)].ogg", 90, 0, -5)
		if(FEMALE)
			playsound(loc, "honk/sound/interactions/final_f[rand(1, 3)].ogg", 90, 0, -5)
	to_chat(H, SPAN_CUMZONE(pick("OH FUCK", "HOLY SHIT"))) //creativity
	if (has_penis())
		if (P)
			T = get_turf(P)
		else
			T = get_turf(H)
		if (H.multiorgasms < H.potenzia)
			var/obj/effect/decal/cleanable/cum/C = new(T)
			C.add_fingerprint(H)

		if (H.species.genitals)
			if (hole == "mouth" || H?.zone_sel?.selecting == "mouth")
				message = pick("cums right in [P]'s mouth.")
				P.add_examine_descriptor(SPAN_ERP("[P.pronouns.His] face [P.pronouns.is] covered in a white liquid..."), DESCRIPTOR_DIRTINESS)
				sound_path = "honk/sound/new/ACTIONS/MOUTH/SWALLOW/"
				sound = pick(flist("[sound_path]"))
			else if (hole == "vagina")
				message = pick("cums in [P]'s pussy")

			else if (hole == "anus")
				message = pick("cums in [P]'s asshole.")
			else if (hole == "floor")
				message = "cums on the floor!"

			sound_path = "honk/sound/new/ACTIONS/PENIS/CUM/"
			sound = pick(flist("[sound_path]"))
		else
			message = pick("cums!", "orgasms!")

		H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_CUMZONE(message))
		if (istype(P.loc, /obj/structure/closet))
			P.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_CUMZONE(message))
		H.lust = 5
		H.resistenza += 50
		H.hydration -= 5
		H.nutrition -= 5
	else
		message = pick("cums!")
		H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_CUMZONE(message))
		if (istype(P.loc, /obj/structure/closet))
			P.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_CUMZONE(message))
		var/delta = rand(20, 100)
		switch(lust)
			if(0 to 150)
				sound_path = "honk/sound/new/ACTIONS/VAGINA/SQUIRT/SHORT/"
			if(150 to INFINITY)
				sound_path = "honk/sound/new/ACTIONS/VAGINA/SQUIRT/LONG/"
				if(prob(25))
					T = get_turf(H)
					var/obj/effect/decal/cleanable/cum/fem/f = new(T)
					var/obj/item/organ/external/groin/dam_groin = GET_EXTERNAL_ORGAN(H, BP_GROIN)
					if(dam_groin.damage > 10)
						H.blood_squirt(15, T)
					H.hydration -= 15
					f.add_fingerprint(H)
				else if(!is_nude())
					visible_message(SPAN_ERPBOLD("[H] ") + SPAN_CUMZONE("cums in her pants..."))
		sound = pick(flist("[sound_path]"))
		src.lust -= delta

	H.multiorgasms += 1
	if(sound && sound_path)
		playsound(loc, "[sound_path][sound]", 100, 1, -5)

	ADJ_STATUS(H, STAT_DRUGGY, 30)
	bloodstr.add_reagent(/decl/material/liquid/dopamine, rand(1, 10))
	H.multiorgasms += 1
	H.erpcooldown += 3


/mob/living/carbon/human/proc/fuck(mob/living/carbon/human/H as mob, mob/living/carbon/human/P as mob, var/hole)
	if(fuckcooldown > world.time)
		return
	fuckcooldown = world.time + FUCK_COOLDOWN_DEFAULT - round(resistenza/150)
	P.fuckcooldown = world.time + FUCK_COOLDOWN_DEFAULT + 3
	var/sound
	var/sound_path
	var/message = ""
	SSmoods.mass_mood_give("fuck", list(H, P))
	bloodstr.add_reagent(/decl/material/liquid/adrenaline, rand(0.01, 0.1))
	switch(hole)
		if("vaglick")
			message = pick("licks [P].", "sucks [P]'s pussy.")

			if (H.lastfucked != P || H.lfhole != hole)
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && P.stat != DEAD)
				P.lust += 10
			H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP(message))
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP(message))
			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += 10
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan()
			if(prob(75))
				sound = pick(flist("honk/sound/new/ACTIONS/VAGINA/TOUCH/"))
				playsound(loc, ("honk/sound/new/ACTIONS/VAGINA/TOUCH/[sound]"), 90, 1, -5)
			else
				sound = pick(flist("honk/sound/new/ACTIONS/MOUTH/SALIVA/"))
				playsound(loc, ("honk/sound/new/ACTIONS/MOUTH/SALIVA/[sound]"), 90, 1, -5)

			H.do_fucking_animation(P)

		if("fingering")
			message = pick("fingers [P].", "fingers [P]'s pussy.")
			if (prob(35))
				message = pick("fingers [P] hard.")
			if (H.lastfucked != P || H.lfhole != hole)
				message = (" shoves their fingers into [P]'s pussy.")
				sound = ("honk/sound/new/ACTIONS/VAGINA/INSERTION/")
				playsound(loc, "honk/sound/new/ACTIONS/VAGINA/INSERTION/[sound]", 90, 1, -5)
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && P.stat != DEAD)
				P.lust += 8
			H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP(message))
			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += 8
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan()

			sound = pick(flist("honk/sound/new/ACTIONS/VAGINA/TOUCH/"))
			playsound(loc, ("honk/sound/new/ACTIONS/VAGINA/TOUCH/[sound]"), 90, 1, -5)
			H.do_fucking_animation(P)

		if("ballsuck")
			message = pick("sucks [P]'s balls.", "licks [P]'s nuts.")
			sound_path = ("honk/sound/new/ACTIONS/BLOWJOB/")
			if (prob(25))
				message = pick("twirls their tongue around [P]'s sack.")
				sound_path = "honk/sound/new/ACTIONS/MOUTH/SUCK/"
			sound = pick(flist("[sound_path]"))

			if (H.lust < 6)
				H.lust += 6

			if(prob(5) && P.stat != DEAD)
				P.lust += 10
			H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP(message))

			if(P.stat != DEAD)
				P.lust += 10
				if (P.lust >= P.resistenza)
					P.cum(P, H, "floor")
				else
					P.moan()

			H.do_fucking_animation(P)
			playsound(loc, ("[sound_path][sound]"), 90, 1, -5)
			if(prob(35))
				sound = pick(flist("honk/sound/new/ACTIONS/MOUTH/SALIVA/"))
				playsound(loc, ("honk/sound/new/ACTIONS/MOUTH/SALIVA/[sound]"), 90, 1, -5)

		if("blowjob")
			message = pick("sucks [P]'s dick.", "gives [P] head.")
			sound_path = ("honk/sound/new/ACTIONS/BLOWJOB/")
			if (prob(35))
				message = pick("sucks [P] off.")
				sound_path = "honk/sound/new/ACTIONS/MOUTH/SUCK/"
			sound = pick(flist("[sound_path]"))

			if (H.lust < 6)
				H.lust += 6

			if(prob(5) && P.stat != DEAD)
				P.lust += 10
			H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP(message))

			if(P.stat != DEAD)
				P.lust += 10
				if (P.lust >= P.resistenza)
					P.cum(P, H, "mouth")
				else
					P.moan()

			H.do_fucking_animation(P)
			playsound(loc, ("[sound_path][sound]"), 90, 1, -5)
			if(prob(35))
				sound = pick(flist("honk/sound/new/ACTIONS/MOUTH/SALIVA/"))
				playsound(loc, ("honk/sound/new/ACTIONS/MOUTH/SALIVA/[sound]"), 90, 1, -5)
			if (prob(P.potenzia))
				H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP("goes in deep on ") + SPAN_ERPBOLD("[P]"))

		if("handjob")
			message = pick("strokes [P]'s dick.", "masturbate [P]'s penis.")
			if (H.lust < 6)
				H.lust += 6

			if(prob(5))
				if(P.stat != DEAD)
					P.lust += 10

			H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP(message))

			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += 8
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan()
			if(prob(50))
				sound = pick(flist("honk/sound/new/ACTIONS/PENIS/HANDJOB/"))
				playsound(loc, "honk/sound/new/ACTIONS/PENIS/HANDJOB/[sound]", 90, 1, -5)
			H.do_fucking_animation(P)
			if (prob(P.potenzia))
				fuckcooldown -= 2
				H.visible_message(SPAN_ERPBOLD("[H] " + SPAN_ERP("strokes <B>[P]'s</B> [pick("cock","dick","penis")] faster")))

		if("vaginal")
			message = pick("fucks [P].", "pounds [P]'s pussy.")

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick(" shoves their dick into [P]'s pussy.")
				sound = pick(flist("honk/sound/new/ACTIONS/VAGINA/INSERTION/"))
				playsound(loc, "honk/sound/new/ACTIONS/VAGINA/INSERTION/[sound]", 90, 1, -5)
				H.lastfucked = P
				H.lfhole = hole

			if(P.virgin)
				P.virgin = FALSE
				H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP("pop's ") + SPAN_ERPBOLD("[P]'s " + SPAN_ERP("cherry")))
			if (prob(5) && P.stat != DEAD)
				P.lust += H.get_pleasure_amt("vaginal-2")
			H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP(message))
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP(message))
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 10
			if (H.lust >= H.resistenza)
				H.cum(H, P, "vagina")

			if (P.stat != DEAD)
				P.lust += H.get_pleasure_amt("vaginal")
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan(H.potenzia)
			H.do_fucking_animation(P)
			if(prob(75))
				sound = pick(flist("honk/sound/new/ACTIONS/PENETRATION/"))
				playsound(loc, "honk/sound/new/ACTIONS/PENETRATION/[sound]", 90, 1, -5)
			else
				fuckcooldown -= 2
				sound = pick(flist("honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/"))
				playsound(loc, "honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/[sound]", 90, 1, -5)

		if("mount")
			message = pick("fucks [P]'s dick", "rides [P]'s dick", "rides [P]")
			if (H.lastfucked != P || H.lfhole != hole)
				message = pick("begins to hop on [P]'s dick")
				H.lastfucked = P
				H.lfhole = hole

			if(H.virgin)
				H.virgin = FALSE
				H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP("pop's ") + SPAN_ERPBOLD("[P]'s " + SPAN_ERP("cherry")))

			if (prob(5) && P.stat != DEAD)
				P.lust += H.potenzia * 2

			H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP(message))

			H.lust += P.potenzia
			if (H.lust >= H.resistenza)
				H.cum(H, P, "vagina")
			else
				H.moan(P.potenzia)
			if (P.stat != DEAD)
				P.lust += H.get_pleasure_amt("vaginal")
				if (P.lust >= P.resistenza)
					P.cum(P, H, "vagina")
				else
					P.moan(P.potenzia)
			H.do_fucking_animation(P)
			if(prob(75))
				sound = pick(flist("honk/sound/new/ACTIONS/PENETRATION/"))
				playsound(loc, "honk/sound/new/ACTIONS/PENETRATION/[sound]", 90, 1, -5)
			else
				fuckcooldown -= 2
				sound = pick(flist("honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/"))
				playsound(loc, "honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/[sound]", 90, 1, -5)
		if("anal")
			message = pick("fucks [P]'s ass.")

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick(" shoves their dick into [P]'s asshole.")
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && P.stat != DEAD)
				P.lust += H.get_pleasure_amt("anal-2")
			H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP(message))

			if (istype(P.loc, /obj/structure/closet))
				P.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP(message))
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 12
			if (H.lust >= H.resistenza)
				H.cum(H, P, "anus")
			else
				P.moan(H.potenzia)

			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += H.get_pleasure_amt("anal")
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan(H.potenzia)
			H.do_fucking_animation(P)
			sound = pick(flist("honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/"))
			playsound(loc, "honk/sound/new/ACTIONS/BODY/COLLIDE/NAKED/[sound]", 90, 1, -5)
			fuckcooldown += 1

		if("oral")
			message = pick(" fucks [P]'s mouth.")
			if (prob(35))
				message = pick(" sucks [P]'s [P.has_penis() ? "dick" : "vag"]..", " licks [P]'s [P.has_penis() ? "dick" : "vag"]..")
			if (H.lastfucked != P || H.lfhole != hole)
				message = pick(" shoves their dick down [P]'s throat.")
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && H.stat != DEAD)
				H.lust += 15
			H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP(message))

			if (istype(P.loc, /obj/structure/closet))
				P.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP(message))
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 15
			if (H.lust >= H.resistenza)
				H.cum(H, P, "mouth")

			if (prob(H.potenzia))
				sound_path = "honk/sound/new/ACTIONS/MOUTH/SWALLOW/"
				H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP("fucks ") + SPAN_ERPBOLD("[P]'s" + SPAN_ERP("throat")))
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP("fucks ") + SPAN_ERPBOLD("[P]'s") + SPAN_ERP("throat"))
			else
				sound_path = "honk/sound/new/ACTIONS/BLOWJOB/"
			sound = pick(flist("[sound_path]"))
			playsound(loc, "[sound_path][sound]", 90, 1, -5)
			H.do_fucking_animation(P)

/mob/living/carbon/human/proc/moan(var/size = 0)
	var/mob/living/carbon/human/H = src
	if (species.name == "Human")
		if (prob(H.lust / H.resistenza * 65))
			var/message = pick("moans", "moans in pleasure")
			H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP(message))
			var/g = H.gender == FEMALE ? "f" : "m"
			var/moan = rand(1, 7)
			if (moan == lastmoan)
				moan--
			if(g == "m")
				playsound(loc, "honk/sound/interactions/moan_[g][moan].ogg", 90, 0, -5)
			else if (g == "f")
				var/sound_path
				var/sound
				switch(size)
					if(-INFINITY to 11)
						sound_path = "honk/sound/new/Moans/mild/"
					if(12 to 20)
						sound_path = "honk/sound/new/Moans/medium/"
					if(21 to INFINITY)
						sound_path = "honk/sound/new/Moans/hot/"
				sound = pick(flist("[sound_path]"))
				playsound(loc, "[sound_path][sound]", 90, 0, -5)
			lastmoan = moan

/mob/living/carbon/human/proc/handle_lust()
	lust -= 4
	if (lust <= 0)
		lust = 0
		lastfucked = null
		lfhole = ""
		multiorgasms = 0
	if (lust == 0)
		erpcooldown -= 1
	if (erpcooldown < 0)
		erpcooldown = 0

/mob/living/carbon/human/proc/do_fucking_animation(mob/living/carbon/human/P)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/final_pixel_y = initial(pixel_y)

	var/direction = P ? get_dir(src, P) : src.dir
	if(direction & NORTH)
		pixel_y_diff = 8
	else if(direction & SOUTH)
		pixel_y_diff = -8

	if(direction & EAST)
		pixel_x_diff = 8
	else if(direction & WEST)
		pixel_x_diff = -8

	if(pixel_x_diff == 0 && pixel_y_diff == 0)
		pixel_x_diff = rand(-3,3)
		pixel_y_diff = rand(-3,3)
		animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
		animate(pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)
		return

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
	animate(pixel_x = initial(pixel_x), pixel_y = final_pixel_y, time = 2)

/obj/item/weapon/dildo
	name = "dildo"
	desc = "Hmmm, deal throw."
	icon = 'honk/icons/obj/items/dildo.dmi'
	icon_state = "dildo"
	item_state = "c_tube"
	throwforce = 0
	force = 10
	w_class = 1
	throw_speed = 3
	throw_range = 15
	attack_verb = list("slammed", "bashed", "whipped")
	var/hole = "vagina"
	var/pleasure = 10

/obj/item/weapon/dildo/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	var/hasvagina = (M.gender == FEMALE && M.species.genitals)
	var/hasanus = M.species.anus
	var/message = ""

	if(istype(M, /mob/living/carbon/human) && user.zone_sel.selecting == "groin" && M.is_nude())
		if (hole == "vagina" && hasvagina)
			if (user == M)
				message = pick("fucks their own pussy")
			else
				message = pick("fucks [M] right in the pussy with the dildo", "jams it right into [M]")

			if (prob(5) && M.stat != DEAD && M.stat != UNCONSCIOUS)
				M.lust += pleasure * 2

			else if (M.stat != DEAD && M.stat != UNCONSCIOUS)
				M.lust += pleasure

			user.visible_message(SPAN_ERPBOLD("[user] ") + SPAN_ERP(message))
			if (M.lust >= M.resistenza)
				M.cum(M, user, "floor")
			else
				M.moan(pleasure)

			user.do_fucking_animation(M)
			playsound(loc, "honk/sound/interactions/bang[rand(4, 6)].ogg", 70, 1, -1)

		else if (hole == "anus" && hasanus)
			if (user == M)
				message = pick("fucks their ass")
			else
				message = pick("fucks [M]'s asshole")

			if (prob(5) && M.stat != DEAD && M.stat != UNCONSCIOUS)
				M.lust += pleasure * 2
			else if (M.stat != DEAD && M.stat != UNCONSCIOUS)
				M.lust += pleasure

			user.visible_message(SPAN_ERPBOLD("[user] ") + SPAN_ERP(message))

			if (M.lust >= M.resistenza)
				M.cum(M, user, "floor")
			else
				M.moan(pleasure*2)

			user.do_fucking_animation(M)
			playsound(loc, "honk/sound/interactions/bang[rand(4, 6)].ogg", 70, 1, -1)

		else
			..()
	else
		..()

/obj/item/weapon/dildo/attack_self(mob/user as mob)
	if(hole == "vagina")
		hole = "anus"
	else
		hole = "vagina"
	to_chat(user, "<span class='warning'>Hmmm. Maybe we should put it in \the [hole]?!</span>")

/datum/stack_recipe/dildo
	title = "Horse"
	result_type = /obj/item/weapon/dildo
	difficulty = 4

/mob/living/carbon/human/Topic(href, href_list)
	if(href_list["interaction"])

		if (usr.stat == DEAD || usr.stat == UNCONSCIOUS || usr.restrained())
			return

		//CONDITIONS
		var/mob/living/carbon/human/H = usr
		var/mob/living/carbon/human/P = H.partner
		if (!(P in view(H.loc)))
			return
		var/obj/item/organ/external/temp =  GET_EXTERNAL_ORGAN(H, BP_R_HAND)
		var/hashands = (temp && temp.is_usable())
		if (!hashands)
			temp = GET_EXTERNAL_ORGAN(H, BP_L_HAND)
			hashands = (temp && temp.is_usable())
		temp = GET_EXTERNAL_ORGAN(P, BP_R_HAND)
		var/hashands_p = (temp && temp.is_usable())
		if (!hashands_p)
			temp = GET_EXTERNAL_ORGAN(P, BP_L_HAND)
			hashands = (temp && temp.is_usable())
		var/mouthfree = !(H._wear_mask)
		var/mouthfree_p = !(P._wear_mask)
		var/haspenis = H.has_penis()
		var/haspenis_p = P.has_penis()
		var/hasvagina = (H.gender == FEMALE && H.species.genitals)
		var/hasvagina_p = (P.gender == FEMALE && P.species.genitals)
		var/hasanus_p = P.species.anus
		var/isnude = H.is_nude()
		var/isnude_p = P.is_nude()
		var/noboots = !P._shoes

		if (href_list["interaction"] == "bow")
			H.visible_message("<span class='name'>[H]</span> <span class='emote'>bows before</span> <span class='name'>[P].</span>")
			if (istype(P.loc, /obj/structure/closet) && P.loc == H.loc)
				P.visible_message("<span class='name'>[H]</span> <span class='emote'>bows before</span> <span class='name'>[P].</span>")

		else if (href_list["interaction"] == "kiss")
			if( ((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && mouthfree && mouthfree_p)
				if (H.lust == 0)
					if (H.lust < 5)
						H.lust = 5

				H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP("kisses ") + SPAN_ERPBOLD("[P]"))
				P.retrieve_from_limb()
				var/sound_path
				switch(H.lust)
					if(0 to 20)
						sound_path = "honk/sound/new/ACTIONS/MOUTH/KISS/"
					if(20 to INFINITY)
						sound_path = "honk/sound/new/ACTIONS/MOUTH/FRENCH_KISS/"
				var/sound = pick(flist("[sound_path]"))
				playsound(loc, "[sound_path][sound]", 50, 1, -1)
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP("kisses ") + SPAN_ERPBOLD("[P]"))
			else if (mouthfree)
				H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP("blows ") + SPAN_ERPBOLD("[P]") + SPAN_ERP("a kiss"))

		else if (href_list["interaction"] == "footlick")
			if( ((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && mouthfree && noboots)
				if (H.lust == 0)
					if (H.lust < 5)
						H.lust = 5
				H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP("licks ") + SPAN_ERPBOLD("[P] ") + SPAN_ERP("feet..."))
				var/sound = pick(flist("honk/sound/new/ACTIONS/MOUTH/SUCK/"))
				playsound(loc, ("honk/sound/new/ACTIONS/MOUTH/SUCK/[sound]"), 40, 1, -1)

				if (istype(P.loc, /obj/structure/closet))
					P.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP("licks ") + SPAN_ERPBOLD("[P] ") + SPAN_ERP("feet..."))

		else if (href_list["interaction"] == "hug")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<span class='passivebold'>[H]</span> <span class='passive'>hugs</span> <span class='passivebold'>[P]</span><span class='passive'>.</span>")
				P.retrieve_from_limb()
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='passivebold'>[H]</span> <span class='passive'>hugs</span> <span class='passivebold'>[P]</span><span class='passive'>.</span>")
				playsound(loc, 'honk/sound/interactions/hug.ogg', 50, 1, -1)

		else if (href_list["interaction"] == "cheer")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<B>[H]</B> cheers <B>[P]</B> on.")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> cheers <B>[P]</B> on.")

		else if (href_list["interaction"] == "five")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<B>[H]</B> high fives <B>[P]</B>.")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> high fives <B>[P]</B>.")
				playsound(loc, 'honk/sound/interactions/slap.ogg', 50, 1, -1)

		else if (href_list["interaction"] == "handshake")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands && hashands_p)
				H.visible_message("<B>[H]</B> shakes <B>[P]</B>'s hand.")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> shakes <B>[P]</B>'s hand.")
			else
				H.visible_message("<B>[H]</B> extends [H.gender == MALE ? "his" : "her"] hand to <B>[P]</B>.")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> extends [H.gender == MALE ? "his" : "her"] hand to <B>[P]</B>.")

		else if (href_list["interaction"] == "slap")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>slaps</span> <span class='combatbold'>[P]</span> <span class='combat'>across the face!</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>slaps</span> <span class='combatbold'>[P]</span> <span class='combat'>across the face!</span>")
				playsound(loc, 'honk/sound/interactions/slap.ogg', 50, 1, -1)

		else if (href_list["interaction"] == "fuckyou")
			if(hashands)
				H.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>gives</span> <span class='combatbold'>[P]</span> <span class='combat'>the finger!</span>")
				if (istype(P.loc, /obj/structure/closet) && P.loc == H.loc)
					P.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>gives</span> <span class='combatbold'>[P]</span> <span class='combat'>the finger!</span>")

		else if (href_list["interaction"] == "knock")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>knocks</span> <span class='combatbold'>[P]</span> <span class='combat'>upside the head!</span>")//Knocks?("<span class='danger'>[H] äàåò [P] ïîäçàòûëüíèê!</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>knocks</span> <span class='combatbold'>[P]</span> <span class='combat'>upside the head!</span>")
				playsound(loc, 'sound/weapons/throwtap.ogg', 50, 1, -1)

		else if (href_list["interaction"] == "spit")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && mouthfree)
				H.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>spits at</span> <span class='combatbold'>[P]!</span>")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>spits at</span> <span class='combatbold'>[P]!</span>")

		else if (href_list["interaction"] == "threaten")
			if(hashands)
				H.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>threatens</span> <span class='combatbold'>[P]</span> <span class='combat'>with a fist!</span>")
				if (istype(P.loc, /obj/structure/closet) && H.loc == P.loc)
					P.visible_message("<span class='combatbold'>[H]</span> <span class='combat'>threatens</span> <span class='combatbold'>[P]</span> <span class='combat'>with a fist!</span>")

		else if (href_list["interaction"] == "tongue")
			if(mouthfree)
				H.visible_message("<span class='danger'>[H] sticks their tongue out at [P]!</span>")
				if (istype(P.loc, /obj/structure/closet) && H.loc == P.loc)
					P.visible_message("<span class='danger'>[H] sticks their tongue out at [P]</span>")

		else if (href_list["interaction"] == "assslap")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hasanus_p && hashands)
				H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP("slaps ") + SPAN_ERPBOLD("[P] ") + SPAN_ERP("right on the ass!"))
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP("slaps ") + SPAN_ERPBOLD("[P] ") + SPAN_ERP("right on the ass!"))
				playsound(loc, 'honk/sound/interactions/slap.ogg', 50, 1, -1)
				H.lust += rand(0.1,0.5)
				P.lust += rand(0.1,0.5)

		else if (href_list["interaction"] == "squeezebreast")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && hashands)
				H.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP("squeezes ") + SPAN_ERPBOLD("[P] ") + SPAN_ERP("breasts!"))
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message(SPAN_ERPBOLD("[H] ") + SPAN_ERP("squeezes ") + SPAN_ERPBOLD("[P] ") + SPAN_ERP("breasts!"))
				H.lust += rand(0.1,0.5)
				P.lust += rand(0.1,0.5)

		else if (href_list["interaction"] == "vaglick")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && isnude_p && mouthfree && hasvagina_p)
				H.fuck(H, P, "vaglick")

		else if (href_list["interaction"] == "ballsuck")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && isnude_p && mouthfree && haspenis_p)
				H.fuck(H, P, "ballsuck")

		else if (href_list["interaction"] == "fingering")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && isnude_p && hashands && hasvagina_p)
				H.fuck(H, P, "fingering")

		else if (href_list["interaction"] == "blowjob")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && isnude_p && mouthfree && haspenis_p)
				H.fuck(H, P, "blowjob")

		else if (href_list["interaction"] == "handjob")
			if(((Adjacent(P) && !istype(P.loc, /obj/structure/closet)) || (H.loc == P.loc)) && isnude_p && haspenis_p)
				H.fuck(H, P, "handjob")

		else if (href_list["interaction"] == "anal")
			if(get_dist(H,P) <= 0 && isnude_p && isnude && haspenis && hasanus_p)
				if (H.erpcooldown == 0)
					if (H.potenzia > 0)
						H.fuck(H, P, "anal")
				else
					var/message = pick("it's not erect...")
					to_chat(H, message)
		else if (href_list["interaction"] == "vaginal")
			if (get_dist(H,P) <= 0 && isnude_p && isnude && haspenis && hasanus_p)
				if (H.erpcooldown == 0)
					if (H.potenzia > 0)
						H.fuck(H, P, "vaginal")
				else
					var/message = pick("It's not erect...")
					to_chat(H, message)

		else if (href_list["interaction"] == "oral")
			if (get_dist(H,P) <= 1 && isnude && mouthfree_p && haspenis)
				if (H.erpcooldown == 0)
					if (H.potenzia > 0)
						H.fuck(H, P, "oral")
				else
					var/message = pick("It's not erect...")
					to_chat(H, message)

		else if (href_list["interaction"] == "mount")
			if (get_dist(H,P) <= 0 && isnude && isnude_p && haspenis_p && hasvagina)
				if(P.erpcooldown == 0)
					H.fuck(H, P, "mount")
				else
					var/message = pick("You have no lust now.")
					to_chat(H, SPAN_ERP(message))

	..()
	return
