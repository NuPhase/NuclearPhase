/obj/modular_map_anchor
	invisibility = INVISIBILITY_ABSTRACT
	icon = 'icons/effects/landmarks_utility.dmi'
	icon_state = "modular_map_anchor"
	layer = LANDMARK_LAYER
	anchored = TRUE

	var/config_file = null
	var/key = null

/obj/modular_map_anchor/Initialize(mapload)
	. = ..()
	if(mapload)
		return INITIALIZE_HINT_LATELOAD

/obj/modular_map_anchor/LateInitialize()
	. = ..()
	INVOKE_ASYNC(src, .proc/load_map)

/obj/modular_map_anchor/proc/load_map()
	var/turf/spawn_turf = get_turf(src)

	var/datum/map_template/map_module/map = new(SSmapping.type, key)
	SSmapping.register_map_template(map)

	if(!config_file)
		return

	if(!key)
		return

	var/raw_config = file2text(config_file)
	var/config = json_decode(raw_config)

	var/map_file = config["directory"] + pick(config["modules"][key]["templates"])

	map.load(spawn_turf, FALSE, map_file = map_file)

	qdel(src, force = TRUE)

/datum/map_template/map_module
	name = "Map Module Template"

	var/x_offset = 0
	var/y_offset = 0

/datum/map_template/map_module/New(created_ad_hoc, new_name)
	. = ..()
	name = new_name

/datum/map_template/map_module/load(turf/T, centered = FALSE, clear_contents = TRUE, map_file)

	if(!map_file)
		return

	LAZYADD(mappaths, map_file)

	preload_size();

	T = locate(T.x - x_offset, T.y - y_offset, T.z)
	. = ..()

/datum/map_template/map_module/preload_size()
	. = ..()

	var/list/offset = discover_offset(/obj/modular_map_connector)

	x_offset = offset[1] - 1
	y_offset = offset[2] - 1

/obj/modular_map_connector
	invisibility = INVISIBILITY_ABSTRACT
	icon = 'icons/effects/landmarks_utility.dmi'
	icon_state = "modular_map_connector"
	layer = LANDMARK_LAYER

	anchored = TRUE