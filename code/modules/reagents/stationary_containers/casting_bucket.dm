/obj/structure/reagent_dispensers/casting_bucket
	name = "casting vessel"
	desc = "A vessel made specifically for holding molten metals."
	icon = 'icons/obj/mining.dmi'
	icon_state = "casting_bucket"

/obj/structure/reagent_dispensers/casting_bucket/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, /obj/item/casting_shape))
		var/obj/item/casting_shape/cur_shape = W
		var/liquid_type_count = 0
		var/result = cur_shape.output_item
		var/list/liquids = list()
		for(var/reg in reagents.reagent_volumes)
			var/decl/material/mat = GET_DECL(reg)
			if(temperature > mat.melting_point && temperature < mat.boiling_point)
				liquid_type_count++
				liquids += mat
		if(!liquid_type_count)
			to_chat(user, SPAN_NOTICE("The [src] is empty!"))
			return
		if(liquid_type_count > 1)
			result = /obj/item/ore/slag
		var/decl/material/nmat = pick(liquids)
		var/mat_weight = reagents.reagent_volumes[nmat.type] / nmat.molar_volume * nmat.molar_mass
		if(mat_weight < cur_shape.weight_cost)
			to_chat(user, SPAN_NOTICE("There isn't enough material in \the [src] to cast something!"))
			return
		reagents.remove_reagent(nmat.type, cur_shape.weight_cost / nmat.molar_mass * nmat.molar_volume)
		new result(get_turf(src))