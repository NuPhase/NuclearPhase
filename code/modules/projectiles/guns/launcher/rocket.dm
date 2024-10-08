/obj/item/gun/launcher/rocket
	name = "rocket launcher"
	desc = "MAGGOT."
	icon = 'icons/obj/guns/launcher/rocket.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_HUGE
	throw_speed = 2
	throw_range = 10
	force = 5.0
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = 0
	origin_tech = @'{"combat":8,"materials":5}'
	fire_sound = 'sound/weapons/gunshot/rocket.ogg'
	combustion = 1

	release_force = 15
	throw_distance = 30
	var/max_rockets = 1
	var/reloadable = TRUE
	var/list/rockets = new/list()
	weight = 22.4

/obj/item/gun/launcher/rocket/examine(mob/user, distance)
	. = ..()
	if(distance <= 2)
		to_chat(user, "<span class='notice'>[rockets.len] / [max_rockets] rockets.</span>")

/obj/item/gun/launcher/rocket/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/ammo_casing/rocket) && reloadable)
		if(rockets.len < max_rockets)
			if(!user.unEquip(I, src))
				return
			rockets += I
			to_chat(user, "<span class='notice'>You put the rocket in [src].</span>")
			to_chat(user, "<span class='notice'>[rockets.len] / [max_rockets] rockets.</span>")
		else
			to_chat(usr, "<span class='warning'>\The [src] cannot hold more rockets.</span>")

/obj/item/gun/launcher/rocket/consume_next_projectile()
	if(rockets.len)
		var/obj/item/ammo_casing/rocket/I = rockets[1]
		var/obj/item/missile/M = new (src)
		M.primed = 1
		rockets -= I
		return M
	return null

/obj/item/gun/launcher/rocket/handle_post_fire(mob/user, atom/target)
	log_and_message_admins("fired a rocket from a rocket launcher ([src.name]) at [target].")
	..()

/obj/item/gun/launcher/rocket/armor_piercing
	name = "MPAT launcher"
	desc = "A single-use man-portable anti-tank rocket launcher."
	reloadable = FALSE
	w_class = ITEM_SIZE_LARGE

/obj/item/gun/launcher/rocket/armor_piercing/Initialize()
	. = ..()
	rockets += new /obj/item/missile/armor_piercing