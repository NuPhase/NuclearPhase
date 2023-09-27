/obj/item/weapon/dildo
	name = "dildo"
	desc = "Hmmm, deal throw."
	icon = 'honk/icons/obj/items/dildo.dmi'
	icon_state = "dildo"
	item_state = "c_tube"
	throwforce = 0
	force = 5
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