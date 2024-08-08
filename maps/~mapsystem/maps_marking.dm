// An associative list.
// "id" = z
var/global/list/zlevel_marks = list()

/proc/get_zlevel_by_id(id)
	return zlevel_marks[id]

/obj/abstract/landmark/ztag
	var/z_id = "CHANGE THIS"

/obj/abstract/landmark/ztag/New()
	. = ..()
	zlevel_marks[z_id] = z
	qdel(src)

/obj/abstract/landmark/ztag/icarus_body
	z_id = "icarus_body"

/obj/abstract/landmark/ztag/icarus_ring
	z_id = "icarus_ring"