/client/verb/overmap_move()
	set name = "Overmap Step"
	set category = "IC"

	var/mob/living/carbon/human/H = mob
	if(!H)
		return
	if(!H.assigned_overmap_object)
		return

/obj/effect/overmap/human
	name = "single human-sized heat signature"
	icon_state = "singlehuman"
	//requires_contact = TRUE
	vessel_mass = 0.22

/mob/living/carbon/human/proc/enter_overmap()
	if(assigned_overmap_object)
		return
	var/obj/effect/overmap/visitable/ov_object = overmaps_by_z[z]
	assigned_overmap_object = new(ov_object.loc)
	forceMove(null)
	reset_view(assigned_overmap_object)

/mob/living/carbon/human/proc/exit_overmap()
	var/obj/effect/overmap/visitable/ov_object = locate(assigned_overmap_object.loc)
	forceMove(pick(ov_object.entry_points))
	qdel(assigned_overmap_object)
	assigned_overmap_object = null
	reset_view(loc)