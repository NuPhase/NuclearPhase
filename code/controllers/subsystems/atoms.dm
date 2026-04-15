#define BAD_INIT_QDEL_BEFORE 1
#define BAD_INIT_DIDNT_INIT 2
#define BAD_INIT_SLEPT 4
#define BAD_INIT_NO_HINT 8

SUBSYSTEM_DEF(atoms)
	name = "Atoms"
	init_order = SS_INIT_ATOMS
	flags = SS_NO_FIRE | SS_NEEDS_SHUTDOWN

	// override and GetArguments() exists for mod-override/downstream hook functionality.
	// Useful for total-overhaul type modifications.
	var/adjust_init_arguments = FALSE

	var/atom_init_stage = INITIALIZATION_INSSATOMS
	var/old_init_stage

	/// A non-associative list of lists, with the format list(list(atom, list(Initialize arguments))).
	var/list/created_atoms = list()
	/// A non-associative list of lists, with the format list(list(atom, list(LateInitialize arguments))).
	var/list/late_loaders = list()

	var/list/BadInitializeCalls = list()

/datum/controller/subsystem/atoms/Initialize(timeofday)
	atom_init_stage = INITIALIZATION_INNEW_MAPLOAD
	InitializeAtoms()
	return ..()

/datum/controller/subsystem/atoms/proc/InitializeAtoms(list/atoms_to_create)
	if(atom_init_stage <= INITIALIZATION_INSSATOMS)
		return

	atom_init_stage = INITIALIZATION_INNEW_MAPLOAD

	var/static/list/mapload_arg = list(TRUE)

	if(atoms_to_create)
		// This list will not change while we loop over it.
		for(var/atom/atom_to_create as anything in atoms_to_create)
			// I sure hope nothing in this list is ever hard-deleted, or else QDELING will runtime.
			// If you get a null reference runtime error, just change it back to QDELETED.
			// The ATOM_FLAG_INITIALIZED check is because of INITIALIZE_IMMEDIATE().
			if(!QDELING(atom_to_create) && !(atom_to_create.atom_flags & ATOM_FLAG_INITIALIZED))
				InitAtom(atom_to_create, mapload_arg)
				CHECK_TICK
		report_progress("Initialized [length(atoms_to_create)] atom\s")
	else // just loop over everything in world
		var/count = 1
		for(var/atom/A as anything in world)
			if(!(A.atom_flags & ATOM_FLAG_INITIALIZED)) // don't double-init anything using INITIALIZE_IMMEDIATE
				InitAtom(A, mapload_arg)
				count++
				CHECK_TICK
			continue
		report_progress("Initialized [count] atom\s in world")

	created_atoms.Cut()

	atom_init_stage = INITIALIZATION_INNEW_REGULAR

	if(length(late_loaders))
		var/count = 1
		// This list may expand while we loop over it.
		while(count <= length(late_loaders))
			var/list/creation_packet = late_loaders[count++]
			var/atom/A = creation_packet[1]
			A.LateInitialize(arglist(creation_packet[2]))
			CHECK_TICK
		report_progress("Late initialized [count] atom\s")
		late_loaders.Cut()

/datum/controller/subsystem/atoms/proc/InitAtom(atom/A, list/arguments)
	var/the_type = A.type
	if(QDELING(A))
		BadInitializeCalls[the_type] |= BAD_INIT_QDEL_BEFORE
		return TRUE

	// This is handled and battle tested by dreamchecker. Limit to UNIT_TEST just in case that ever fails.
	#ifdef UNIT_TEST
	var/start_tick = world.time
	#endif

	var/result = A.Initialize(arglist(arguments))

	#ifdef UNIT_TEST
	if(start_tick != world.time)
		BadInitializeCalls[the_type] |= BAD_INIT_SLEPT
	#endif

	var/qdeleted = FALSE

	switch(result)
		if(INITIALIZE_HINT_NORMAL)
			EMPTY_BLOCK_GUARD
		if(INITIALIZE_HINT_LATELOAD)
			if(arguments[1])	//mapload
				late_loaders[++late_loaders.len] = list(A, arguments)
			else
				A.LateInitialize(arglist(arguments))
		if(INITIALIZE_HINT_QDEL)
			A.atom_flags |= ATOM_FLAG_INITIALIZED // never call EarlyDestroy if we return this hint
			qdel(A)
			qdeleted = TRUE
		else
			BadInitializeCalls[the_type] |= BAD_INIT_NO_HINT

	if(!A)	//possible harddel
		qdeleted = TRUE
	else if(!(A.atom_flags & ATOM_FLAG_INITIALIZED))
		BadInitializeCalls[the_type] |= BAD_INIT_DIDNT_INIT

	return qdeleted || QDELING(A)

/datum/controller/subsystem/atoms/stat_entry(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Bad Initialize Calls:[BadInitializeCalls.len]")

/datum/controller/subsystem/atoms/proc/map_loader_begin()
	old_init_stage = atom_init_stage
	atom_init_stage = INITIALIZATION_INSSATOMS

/datum/controller/subsystem/atoms/proc/map_loader_stop()
	atom_init_stage = old_init_stage

/datum/controller/subsystem/atoms/Recover()
	atom_init_stage = SSatoms.atom_init_stage
	if(atom_init_stage == INITIALIZATION_INNEW_MAPLOAD)
		InitializeAtoms()
	old_init_stage = SSatoms.old_init_stage
	BadInitializeCalls = SSatoms.BadInitializeCalls

/datum/controller/subsystem/atoms/proc/InitLog()
	. = ""
	for(var/path in BadInitializeCalls)
		. += "Path : [path] \n"
		var/fails = BadInitializeCalls[path]
		if(fails & BAD_INIT_DIDNT_INIT)
			. += "- Didn't call atom/Initialize()\n"
		if(fails & BAD_INIT_NO_HINT)
			. += "- Didn't return an Initialize hint\n"
		if(fails & BAD_INIT_QDEL_BEFORE)
			. += "- Qdel'd in New()\n"
		if(fails & BAD_INIT_SLEPT)
			. += "- Slept during Initialize()\n"

/datum/controller/subsystem/atoms/Shutdown()
	var/initlog = InitLog()
	if(initlog)
		text2file(initlog, "[global.log_directory]/initialize.log")

#undef BAD_INIT_QDEL_BEFORE
#undef BAD_INIT_DIDNT_INIT
#undef BAD_INIT_SLEPT
#undef BAD_INIT_NO_HINT
