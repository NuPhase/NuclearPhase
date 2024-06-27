//These are persistent item spawners. They should be used when placing objects on the main shelter map.
//They take their [spawn_paths] variable and check whether an item is available in the item pool. If so, they spawn the item.
//spawn_paths variable can either be a single path or a list. If its a list it will randomly spawn one type from the list and remove it from the pool.
//priority variable explains itself.
//Create as many subtypes as you want.

/obj/effect/item_spawner
	var/spawn_paths
	var/priority = 50
	var/max_items = 1
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE

/obj/effect/item_spawner/Initialize()
	. = ..()
	SSpersistence.item_pool_spawners[spawn_paths] += 1
	return INITIALIZE_HINT_LATELOAD

/obj/effect/item_spawner/LateInitialize()
	. = ..()
	spawn(100 - priority)
		var/list_to_spawn = list()
		if(islist(spawn_paths))
			list_to_spawn[pick(spawn_paths)] = max_items
		else
			list_to_spawn[spawn_paths] = max_items

		create_objects_in_loc_pooled(loc, list_to_spawn)

/obj/effect/item_spawner/everything //For all the garbage that we can't spawn in specific places
	priority = 0

/obj/effect/item_spawner

/obj/effect/item_spawner/trash
	max_items = 2

/obj/effect/item_spawner/trash/Initialize()
	spawn_paths = subtypesof(/obj/item/trash)
	. = ..()

/obj/effect/item_spawner/drinks
	max_items = 1

/obj/effect/item_spawner/drinks/Initialize()
	spawn_paths = subtypesof(/obj/item/chems/drinks/)
	. = ..()