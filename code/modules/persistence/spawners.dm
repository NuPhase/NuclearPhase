//These are persistent item spawners. They should be used when placing objects on the main shelter map.
//They take their [spawn_paths] variable and check whether an item is available in the item pool. If so, they spawn the item.
//spawn_paths variable can either be a single path or a list. If its a list it will randomly spawn one type from the list and remove it from the pool.
//priority variable explains itself.
//Create as many subtypes as you want.

/obj/effect/item_spawner
	var/sup_name // crate name, if there is one
	var/crate_type // If defined, spawns the items in a crate

	var/spawn_paths
	var/priority = 50
	var/max_items = 1
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	alpha = 30

/obj/effect/item_spawner/Initialize()
	. = ..()
	SSpersistence.item_pool_spawners[spawn_paths] += 1
	return INITIALIZE_HINT_LATELOAD

/obj/effect/item_spawner/LateInitialize()
	spawn(100 - priority)
		var/list_to_spawn = list()
		if(islist(spawn_paths))
			if(max_items == 1)
				list_to_spawn[pick(spawn_paths)] = 1
			else
				for(var/spawn_path in spawn_paths)
					list_to_spawn[spawn_path] = round(max_items / length(spawn_paths))
		else
			list_to_spawn[spawn_paths] = max_items

		create_objects_in_loc_pooled(loc, list_to_spawn)
		if(crate_type)
			var/obj/spawned_crate = new crate_type(loc)
			spawned_crate.name = "[spawned_crate.name] - [sup_name]"

/obj/effect/item_spawner/everything //For all the garbage that we can't spawn in specific places
	priority = 0
	max_items = 50

/obj/effect/item_spawner/everything/LateInitialize()
	if(!SSpersistence.loaded_item_pool)
		return
	spawn(100)
		var/spawn_type = pick(SSpersistence.loaded_item_pool)
		var/list_to_spawn = list()
		list_to_spawn[spawn_type] = SSpersistence.loaded_item_pool[spawn_type]

		create_objects_in_loc_pooled(loc, list_to_spawn)
		if(crate_type)
			var/obj/spawned_crate = new crate_type(loc)
			spawned_crate.name = "[spawned_crate.name] - [sup_name]"

/obj/effect/item_spawner/trash
	max_items = 1

/obj/effect/item_spawner/trash/Initialize()
	spawn_paths = subtypesof(/obj/item/trash)
	. = ..()

/obj/effect/item_spawner/drinks
	max_items = 1

/obj/effect/item_spawner/drinks/Initialize()
	spawn_paths = subtypesof(/obj/item/chems/drinks/)
	. = ..()



/obj/effect/item_spawner/big_crate
	max_items = 100
	crate_type = /obj/structure/largecrate

/obj/effect/item_spawner/big_crate/radsuits
	sup_name = "Radiation Protection Suits"
	spawn_paths = list(/obj/item/clothing/suit/radiation, /obj/item/clothing/head/radiation)

/obj/effect/item_spawner/big_crate/wound_treatment
	sup_name = "Wound Treatment Supplies"
	spawn_paths = list(/obj/item/stack/medical/bruise_pack,
						/obj/item/stack/medical/wound_filler,
						/obj/item/stack/medical/wound_filler/hydrogel,
						/obj/item/stack/medical/wound_filler/hydrofiber,
						/obj/item/stack/medical/ointment)