//These are persistent item spawners. They should be used when placing objects on the main shelter map.
//They take their [spawn_paths] variable and check whether an item is available in the item pool. If so, they spawn the item.
//spawn_paths variable can either be a single path or a list. If its a list it will randomly spawn one type from the list and remove it from the pool.
//priority variable explains itself.
//Create as many subtypes as you want.

/obj/effect/item_spawner
	var/spawn_paths
	var/priority = 50

/obj/effect/item_spawner/everything //For all the garbage that we can't spawn in specific places
	priority = 0

/obj/effect/item_spawner