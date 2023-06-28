/obj/item/casting_shape
	name = "blank casting mold"
	desc = "A polymer casting mold. This one is blank."
	icon = 'icons/obj/mining.dmi'
	icon_state = "casting_form"
	var/accepted_materials = list()
	var/output_item = null
	var/is_material = FALSE
	var/weight_cost = 1 //kg
	var/hot = FALSE
	var/filled = null //material type
	var/filled_icon_state = ""
	needs_closet_processing = TRUE

/obj/item/casting_shape/Initialize(ml, material_key)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/casting_shape/Process()
	if(istype(loc, /obj/structure/closet))
		var/obj/structure/closet/cur_closet = loc
		temperature = Interpolate(temperature, cur_closet.temperature, 0.02)
		if(temperature < T100C)
			hot = FALSE
			STOP_PROCESSING(SSobj, src)
			update_icon()

/obj/item/casting_shape/attack_self(mob/user)
	. = ..()
	if(filled)
		if(hot)
			to_chat(user, SPAN_NOTICE("\The [src] is still hot, you have to cool it down."))
			return
		if(!do_after(user, 10, src))
			return
		visible_message("[user] empties \the [src].")
		if(is_material)
			new output_item(get_turf(src), amount = 1, _material = filled)
		else
			new output_item(get_turf(src))
		filled = null
		update_icon()
	else
		to_chat(user, SPAN_NOTICE("\The [src] is empty."))

/obj/item/casting_shape/on_update_icon()
	cut_overlays()
	if(filled)
		var/image/I = image(icon, filled_icon_state)
		if(hot)
			I.color = MOLTEN_METAL_COLOR
		else
			var/decl/material/mat = GET_DECL(filled)
			I.color = mat.color
		add_overlay(I)

/obj/item/casting_shape/ingot
	name = "ingot casting mold"
	desc = "A polymer casting mold. This one is made for ingots."
	icon_state = "casting_form_ingot"
	filled_icon_state = "casting_form_ingot_filled"
	accepted_materials = list(
	/decl/material/solid/metal/iron,
	/decl/material/solid/metal/copper)
	output_item = /obj/item/stack/material/ingot
	is_material = TRUE
	weight_cost = 2

/obj/item/casting_shape/honeycomb
	name = "honeycomb casting mold"
	desc = "A polymer casting mold. This one is made for special honeycomb structures that can be cut. Heat shielding applications."
	accepted_materials = list(/decl/material/solid/carbon, /decl/material/solid/boron)
	output_item = /obj/item/stack/material/ingot
	is_material = FALSE
	weight_cost = 10