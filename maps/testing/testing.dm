#if !defined(USING_MAP_DATUM)

	#include "testing_unit_testing.dm"

	#include "testing-1.dmm"

	#define USING_MAP_DATUM /datum/map/testing

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Testing Site

#endif
