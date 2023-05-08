var/global/list/tents = list()

/datum/map_template/tent
	name = "Tent interior"
	width = 4
	height = 5
	mappaths = list("maps/_interiors/tent_interior.dmm")
	template_categories = list(MAP_TEMPLATE_CATEGORY_INTERIORS)

/obj/item/tent
	name = "Tent"
	icon = 'icons/obj/items/tool/shovels/shovel.dmi'
	icon_state = ICON_STATE_WORLD
	var/uid = "TENT"
	var/interior_template = "Tent interior"
	var/obj/effect/interior_entrypoint/tent/entrypoint
	var/obj/structure/tent/structure_object
	var/turf/interior_place

/obj/item/tent/Initialize()
	. = ..()
	spawn(0)
		var/datum/map_template/templ = SSmapping.get_template(interior_template)
		interior_place = templ.load_interior_level()
		global.tents += src
		entrypoint = interior_entrypoints[uid][global.tents.Find(src)]

/obj/item/tent/attack_self(mob/user)
	if(structure_object)
		return

	user.visible_message(SPAN_INFO("[user] starts to place a tent..."))
	if(do_after(user, 10 SECONDS))
		structure_object = new(get_turf(loc), src)
		structure_object.itemobj = src
		entrypoint.origin = src
		user.drop_from_inventory(src, null)
		src.forceMove(null)
		user.visible_message(SPAN_INFO("[user] placed a tent!"))

/obj/item/tent/proc/check_interior_is_empty()
	var/datum/map_template/templ = SSmapping.get_template(interior_template)
	var/list/turfs = block(locate(interior_place.x-templ.width, interior_place.y-templ.height, interior_place.z), locate(interior_place.x, interior_place.y, interior_place.z))
	for(var/turf/T as anything in turfs)
		for(var/atom/A in T.contents)
			if(ismob(A))
				return FALSE

			if(isobj(A) && !istype(A, /obj/effect))
				return FALSE

	return TRUE

/obj/structure/tent
	name = "Placed tent"
	var/obj/item/tent/itemobj
	icon = 'icons/obj/structures/pit.dmi'
	icon_state = "open_"

/obj/structure/tent/attack_hand(mob/user)
	. = ..()
	if(itemobj)
		user.forceMove(itemobj.entrypoint.loc)

/obj/structure/tent/grab_attack(var/obj/item/grab/G)
	var/mob/user = G.assailant
	user.visible_message(SPAN_WARNING("[user] is trying to put [G.affecting] into [src]"))
	if(!do_after(user, 5 SECONDS))
		return
	G.affecting.forceMove(itemobj.entrypoint.loc)
	G.current_grab.let_go(G)

/obj/structure/tent/verb/deflate()
	set name = "Deflate Tent"
	set category = "Object"
	set src in oview(1)

	if(itemobj)
		if(!itemobj.check_interior_is_empty())
			to_chat(usr, SPAN_WARNING("Tent is not empty!"))
			return

		if(!do_after(usr, 20 SECONDS))
			return

		itemobj.forceMove(get_turf(loc))
		itemobj.entrypoint.origin = null
		itemobj.structure_object = null

	qdel(src)


/obj/effect/interior_entrypoint/tent
	uid = "TENT"
	icon = 'icons/obj/structures/pit.dmi'
	icon_state = "open_"
	var/obj/item/tent/origin

/obj/effect/interior_entrypoint/tent/attack_hand(mob/user)
	. = ..()
	if(origin?.structure_object)
		user.forceMove(origin.structure_object.loc)

/obj/effect/interior_entrypoint/tent/grab_attack(var/obj/item/grab/G)
	if(!origin?.structure_object)
		return

	var/mob/user = G.assailant
	user.visible_message(SPAN_WARNING("[user] is trying to eject [G.affecting] from [src]"))
	if(!do_after(user, 5 SECONDS))
		return
	G.affecting.forceMove(origin.structure_object.loc)
	G.current_grab.let_go(G)