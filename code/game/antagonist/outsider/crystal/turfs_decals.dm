/obj/effect/crystal_growth //stepping barefoot will be PUNISHED
	name = "crystal covered floor"
	desc = "These crystals are terrifying in their perfect placement patterns."
	layer = DECAL_LAYER

/obj/effect/crystal_growth/meat
	desc = "These crystals are terrifying in their perfect placement patterns. There are pieces of flesh lodged inbetween individual shards..."

/obj/effect/crystal_growth/Crossed(atom/movable/AM)
	..()
	if(isliving(AM))
		var/mob/M = AM

		if(M.buckled) //wheelchairs, office chairs, rollerbeds
			return

		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.siemens_coefficient<0.5 || (H.species.species_flags & (SPECIES_FLAG_NO_EMBED|SPECIES_FLAG_NO_MINOR_CUT))) //Thick skin.
				return

			var/obj/item/shoes = H.get_equipped_item(slot_shoes_str)
			var/obj/item/suit = H.get_equipped_item(slot_wear_suit_str)
			if(shoes || (suit && (suit.body_parts_covered & SLOT_FEET)))
				return

			to_chat(M, SPAN_DANGER("You step on \the [src]! There is some strange tingling in your feet..."))

			var/list/check = list(BP_L_FOOT, BP_R_FOOT)
			while(check.len)
				var/picked = pick(check)
				var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, picked)
				var/obj/item/organ/external/chest/infecting = GET_EXTERNAL_ORGAN(H, BP_CHEST)
				if(affecting)
					if(BP_IS_PROSTHETIC(affecting))
						return
					affecting.take_external_damage(7, 0)
					infecting.add_ailment(/datum/ailment/crystal/phase_one)
					H.updatehealth()
					if(affecting.can_feel_pain())
						SET_STATUS_MAX(H, STAT_WEAK, 3)
					return
				check -= picked
			return

/obj/item/projectile/bullet/pellet/fragment/crystal
	damage = 6
	irradiate = 5
	eyeblur = 1

/obj/item/projectile/bullet/pellet/fragment/crystal/on_hit(atom/target, blocked)
	if(!blocked)
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = target
			var/obj/item/organ/external/chest/affecting = GET_EXTERNAL_ORGAN(H, BP_CHEST)
			affecting.add_ailment(/datum/ailment/crystal/phase_one)
	. = ..()

/obj/effect/crystal_wall
	name = "crystal wall"
	desc = "A seemingly indestructive obstacle of crystalline origin."
	density = 1
	opacity = 1
	anchored = 1
	mouse_opacity = 2
	layer = ABOVE_HUMAN_LAYER
	var/shatter_prob = 15

/obj/effect/crystal_wall/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	if(istype(P, /obj/item/projectile/bullet/pellet/fragment/crystal))
		return

	playsound(src, "glasscrack", 50, 1)
	fragmentate(get_turf(src), fragtypes = list(/obj/item/projectile/bullet/pellet/fragment/crystal))
	if(prob(shatter_prob))
		visible_message(SPAN_DANGER("[src] gets shredded to pieces!"))
		qdel(src)