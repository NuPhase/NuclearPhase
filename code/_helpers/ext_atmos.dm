#ifndef WINDOWS_EXTATM_LOCATION
#define WINDOWS_EXTATM_LOCATION "lib/extatmos.dll"
#endif

#ifndef UNIX_EXTATM_LOCATION
#define UNIX_EXTATM_LOCATION "lib/libextatmos.so"
#endif

#ifndef EXTATM_LOCATION
#define EXTATM_LOCATION (world.system_type == MS_WINDOWS ? WINDOWS_EXTATM_LOCATION : UNIX_EXTATM_LOCATION)
#endif

/hook/startup/proc/extatmos_init()
	call(EXTATM_LOCATION, "auxtools_init")()
	world.log << "ExtAtmos attached!!!"

/hook/shutdown/proc/extatmos_shutdown()
	call(EXTATM_LOCATION, "auxtools_shutdown")()
