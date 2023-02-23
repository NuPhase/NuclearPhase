SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = SS_INIT_MAPPING
	flags = SS_NO_FIRE

	var/list/map_templates =             list()
	var/list/submaps =                   list()
	var/list/map_templates_by_category = list()
	var/list/map_templates_by_type =     list()
	var/list/banned_maps =               list()

	var/turf/interior_zlevel = null

	// Listing .dmm filenames in the file at this location will blacklist any templates that include them from being used.
	// Maps must be the full file path to be properly included. ex. "maps/random_ruins/away_sites/example.dmm"
	var/banned_dmm_location = "config/banned_map_paths.json"

	var/decl/overmap_event_handler/overmap_event_handler

/datum/controller/subsystem/mapping/Initialize(timeofday)

	// Load our banned map list, if we have one.
	if(banned_dmm_location && fexists(banned_dmm_location))
		banned_maps = cached_json_decode(safe_file2text(banned_dmm_location))

	// Fetch and track all templates before doing anything that might need one.
	for(var/datum/map_template/MT as anything in get_all_template_instances())
		register_map_template(MT)

	// Populate overmap.
	if(length(global.using_map.overmap_ids))
		for(var/overmap_id in global.using_map.overmap_ids)
			var/overmap_type = global.using_map.overmap_ids[overmap_id] || /datum/overmap
			new overmap_type(overmap_id)
	// This needs to be non-null even if the overmap isn't created for this map.
	overmap_event_handler = GET_DECL(/decl/overmap_event_handler)

	// Build away sites.
	global.using_map.build_away_sites()

	// Initialize z-level objects.
#ifdef UNIT_TEST
	config.generate_map = TRUE
#endif
	for(var/z = 1 to world.maxz)
		var/datum/level_data/level = levels_by_z[z]
		if(!istype(level))
			level = new /datum/level_data/space(z)
			PRINT_STACK_TRACE("Missing z-level data object for z[num2text(z)]!")
		level.setup_level_data()

	. = ..()

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	map_templates =             SSmapping.map_templates
	map_templates_by_category = SSmapping.map_templates_by_category
	map_templates_by_type =     SSmapping.map_templates_by_type

/datum/controller/subsystem/mapping/proc/register_map_template(var/datum/map_template/map_template)
	if(!validate_map_template(map_template) || !map_template.preload())
		return FALSE
	map_templates[map_template.name] = map_template
	for(var/temple_cat in map_template.template_categories) // :3
		LAZYINITLIST(map_templates_by_category[temple_cat])
		LAZYSET(map_templates_by_category[temple_cat], map_template.name, map_template)
	return TRUE

/datum/controller/subsystem/mapping/proc/validate_map_template(var/datum/map_template/map_template)
	if(!istype(map_template))
		PRINT_STACK_TRACE("Null or incorrectly typed map template attempted validation.")
		return FALSE
	if(length(banned_maps) && length(map_template.mappaths))
		for(var/mappath in map_template.mappaths)
			if(mappath in banned_maps)
				return FALSE
	if(!isnull(map_templates[map_template.name]))
		PRINT_STACK_TRACE("Duplicate map name '[map_template.name]' on type [map_template.type]!")
		return FALSE
	return TRUE

/datum/controller/subsystem/mapping/proc/get_all_template_instances()
	. = list()
	for(var/template_type in subtypesof(/datum/map_template))
		var/datum/map_template/template = template_type
		if(initial(template.template_parent_type) != template_type && initial(template.name))
			. += new template_type(type) // send name as a param to catch people doing illegal ad hoc creation

/datum/controller/subsystem/mapping/proc/get_template(var/template_name)
	return map_templates[template_name]

/datum/controller/subsystem/mapping/proc/get_templates_by_category(var/temple_cat) // :33
	return map_templates_by_category[temple_cat]

// Z-Level procs after this point.
/datum/controller/subsystem/mapping/proc/get_gps_level_name(var/z)
	if(z)
		var/datum/level_data/level = levels_by_z[z]
		. = level.get_display_name()
		if(length(.))
			return .
	return "Unknown Sector"

/datum/controller/subsystem/mapping/proc/reindex_lists()
	levels_by_z.len = world.maxz // Populate with nulls so we don't get index errors later.
	base_turf_by_z.len = world.maxz
	connected_z_cache.Cut()

/datum/controller/subsystem/mapping/proc/increment_world_z_size(var/new_level_type, var/defer_setup = FALSE)

	world.maxz++
	reindex_lists()

	if(SSzcopy.zlev_maximums.len)
		SSzcopy.calculate_zstack_limits()
	if(!new_level_type)
		PRINT_STACK_TRACE("Missing z-level data type for z["[world.maxz]"]!")
		return

	var/datum/level_data/level = new new_level_type(world.maxz, defer_setup)
	level.initialize_new_level()
	return level

/datum/controller/subsystem/mapping/proc/get_connected_levels(z)
	if(z <= 0  || z > length(levels_by_z))
		CRASH("Invalid z-level supplied to get_connected_levels: [isnull(z) ? "NULL" : z]")
	. = list(z)
	// Traverse up and down to get the multiz stack.
	for(var/level = z, HasBelow(level), level--)
		. |= level-1
	for(var/level = z, HasAbove(level), level++)
		. |= level+1
	// Check stack for any laterally connected neighbors.
	for(var/tz in .)
		var/datum/level_data/level = levels_by_z[tz]
		if(level)
			level.find_connected_levels(.)

/datum/controller/subsystem/mapping/proc/are_connected_levels(var/zA, var/zB)
	if (zA <= 0 || zB <= 0 || zA > world.maxz || zB > world.maxz)
		return FALSE
	if (zA == zB)
		return TRUE
	if (length(connected_z_cache) >= zA && length(connected_z_cache[zA]) >= zB)
		return connected_z_cache[zA][zB]
	var/list/levels = get_connected_levels(zA)
	var/list/new_entry = new(world.maxz)
	for (var/entry in levels)
		new_entry[entry] = TRUE
	if (connected_z_cache.len < zA)
		connected_z_cache.len = zA
	connected_z_cache[zA] = new_entry
	return new_entry[zB]

/// Registers all the needed infos from a level_data into the mapping subsystem
/datum/controller/subsystem/mapping/proc/register_level_data(var/datum/level_data/LD)
	if(LD.base_turf)
		SSmapping.base_turf_by_z[LD.level_z] = LD.base_turf
	if(LD.level_flags & ZLEVEL_STATION)
		SSmapping.station_levels |= LD.level_z
	if(LD.level_flags & ZLEVEL_ADMIN)
		SSmapping.admin_levels   |= LD.level_z
	if(LD.level_flags & ZLEVEL_CONTACT)
		SSmapping.contact_levels |= LD.level_z
	if(LD.level_flags & ZLEVEL_PLAYER)
		SSmapping.player_levels  |= LD.level_z
	if(LD.level_flags & ZLEVEL_SEALED)
		SSmapping.sealed_levels  |= LD.level_z
	return TRUE

/datum/controller/subsystem/mapping/proc/unregister_level_data(var/datum/level_data/LD)
	SSmapping.base_turf_by_z[LD.level_z] = world.turf
	SSmapping.station_levels -= LD.level_z
	SSmapping.admin_levels   -= LD.level_z
	SSmapping.contact_levels -= LD.level_z
	SSmapping.player_levels  -= LD.level_z
	SSmapping.sealed_levels  -= LD.level_z
	return TRUE
