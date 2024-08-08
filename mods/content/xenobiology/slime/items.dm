/obj/item/slime_extract
	name = "slime core extract"
	desc = "Goo extracted from a slime. Legends claim these to have \"magical powers\"."
	icon = 'mods/content/xenobiology/icons/slimes/slime_extract.dmi'
	icon_state = ICON_STATE_WORLD
	force = 1.0
	w_class = ITEM_SIZE_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 6
	origin_tech = @'{"biotech":4}'
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	var/slime_type = /decl/slime_colour/grey
	var/Uses = 1 // uses before it goes inert
	var/enhanced = 0 //has it been enhanced before?

/obj/item/slime_extract/get_base_value()
	. = ..() * Uses

/obj/item/slime_extract/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/slime_extract_enhancer))
		if(enhanced == 1)
			to_chat(user, "<span class='warning'> This extract has already been enhanced!</span>")
			return ..()
		if(Uses == 0)
			to_chat(user, "<span class='warning'> You can't enhance a used extract!</span>")
			return ..()
		to_chat(user, "You apply the enhancer. It now has triple the amount of uses.")
		Uses = 3
		enhanced = 1
		qdel(O)
		return TRUE
	. = ..()

/obj/item/slime_extract/Initialize(var/ml, var/material, var/_stype = /decl/slime_colour/grey)
	. = ..(ml, material)
	slime_type = _stype
	if(!ispath(slime_type, /decl/slime_colour))
		PRINT_STACK_TRACE("Slime extract initialized with non-decl slime colour: [slime_type || "NULL"].")
	SSstatistics.extracted_slime_cores_amount++
	create_reagents(100)
	reagents.add_reagent(/decl/material/liquid/slimejelly, 30)
	update_icon()

/obj/item/slime_extract/on_reagent_change()
	. = ..()
	if(reagents?.total_volume)
		var/decl/slime_colour/slime_data = GET_DECL(slime_type)
		slime_data.handle_reaction(reagents)

/obj/item/slime_extract/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	icon = slime_data.extract_icon


