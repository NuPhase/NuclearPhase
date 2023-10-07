/obj/item/sex_toy
	name = "placeholder toy"
	icon = 'icons/obj/items/sex_toys.dmi'

/obj/item/sex_toy/proc/get_pleasure()
	return 0

/obj/item/sex_toy/proc/get_pain()
	return 0

/obj/item/sex_toy/dildo
	name = "dildo"
	desc = "Hmmm, deal throw."
	icon_state = "dildo1"
	item_state = "c_tube"
	throwforce = 0
	force = 5
	w_class = 1
	throw_speed = 3
	throw_range = 15
	attack_verb = list("slammed", "bashed", "whipped")
	var/hole = "vagina"
	var/size = 1
	var/possible_colors = list(COLOR_RED, COLOR_YELLOW, COLOR_PINK, COLOR_VIOLET, COLOR_GREEN)

/obj/item/sex_toy/dildo/Initialize(ml, material_key)
	. = ..()
	color = pick(possible_colors)

/obj/item/sex_toy/dildo/bigger
	size = 1.5
	icon_state = "dildo2"

/obj/item/sex_toy/dildo/biggest
	size = 2
	icon_state = "dildo3"

/obj/item/sex_toy/dildo/get_pleasure()
	return 27 * size

/obj/item/sex_toy/dildo/get_pain()
	return 1.5 * size

/obj/item/sex_toy/dildo/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
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
				M.adjust_pleasure(get_pleasure() * 2)

			else if (M.stat != DEAD && M.stat != UNCONSCIOUS)
				M.adjust_pleasure(get_pleasure())

			user.visible_message(SPAN_ERPBOLD("[user] ") + SPAN_ERP(message))
			if (M.pleasure >= 1000)
				M.climax(get_turf(src), "surface")
			else
				M.moan(get_pleasure())

			user.do_fucking_animation(M)
			playsound(loc, "honk/sound/interactions/bang[rand(4, 6)].ogg", 70, 1, -1)

		else if (hole == "anus" && hasanus)
			if (user == M)
				message = pick("fucks their ass")
			else
				message = pick("fucks [M]'s asshole")

			if (prob(5) && M.stat != DEAD && M.stat != UNCONSCIOUS)
				M.adjust_pleasure(get_pleasure() * 2)
			else if (M.stat != DEAD && M.stat != UNCONSCIOUS)
				M.adjust_pleasure(get_pleasure())

			user.visible_message(SPAN_ERPBOLD("[user] ") + SPAN_ERP(message))

			if (M.pleasure >= 1000)
				M.climax(get_turf(src), "surface")
			else
				M.moan(get_pleasure()*2)

			user.do_fucking_animation(M)
			playsound(loc, "honk/sound/interactions/bang[rand(4, 6)].ogg", 70, 1, -1)
		user.setClickCooldown(rand(3, 7))
	else
		..()

/obj/item/sex_toy/dildo/attack_self(mob/user as mob)
	if(hole == "vagina")
		hole = "anus"
	else
		hole = "vagina"
	to_chat(user, "<span class='warning'>You will now put [src] in \the [hole].</span>")

/datum/stack_recipe/dildo
	title = "Horse"
	result_type = /obj/item/sex_toy/dildo
	difficulty = 4