//Colored pipes, use these for mapping

#define HELPER_PARTIAL(Fulltype, Iconbase, Color, Level) \
	##Fulltype {								\
		level = Level;							\
		color = Color;							\
		layer = EXPOSED_PIPE_LAYER;	   		    \
	}											\
	##Fulltype/layer1 {					\
		connect_types = CONNECT_TYPE_SUPPLY;	\
		icon_state = Iconbase + "-supply";		\
	}											\
	##Fulltype/layer3 {					\
		connect_types = CONNECT_TYPE_SCRUBBER;	\
		icon_state = Iconbase + "-scrubbers";	\
	}

#define HELPER_PARTIAL_NAMED(Fulltype, Iconbase, Name, Color, Level) \
	HELPER_PARTIAL(Fulltype, Iconbase, Color, Level)	\
	##Fulltype {								\
		name = Name;							\
	}

#define HELPER(Type, Color) \
	HELPER_PARTIAL(/obj/machinery/atmospherics/pipe/simple/hidden/##Type, "11", Color, 1) 		\
	HELPER_PARTIAL(/obj/machinery/atmospherics/pipe/simple/visible/##Type, "11", Color, 2) 		\
	HELPER_PARTIAL(/obj/machinery/atmospherics/pipe/manifold/hidden/##Type, "map", Color, 1)		\
	HELPER_PARTIAL(/obj/machinery/atmospherics/pipe/manifold/visible/##Type, "map", Color, 2)		\
	HELPER_PARTIAL(/obj/machinery/atmospherics/pipe/manifold4w/hidden/##Type, "map", Color, 1)		\
	HELPER_PARTIAL(/obj/machinery/atmospherics/pipe/manifold4w/visible/##Type, "map", Color, 2)

#define HELPER_NAMED(Type, Name, Color) \
	HELPER_PARTIAL_NAMED(/obj/machinery/atmospherics/pipe/simple/hidden/##Type, "11", Name, Color, 1) 		\
	HELPER_PARTIAL_NAMED(/obj/machinery/atmospherics/pipe/simple/visible/##Type, "11", Name, Color, 2) 		\
	HELPER_PARTIAL_NAMED(/obj/machinery/atmospherics/pipe/manifold/hidden/##Type, "map", Name, Color, 1)		\
	HELPER_PARTIAL_NAMED(/obj/machinery/atmospherics/pipe/manifold/visible/##Type, "map", Name, Color, 2)		\
	HELPER_PARTIAL_NAMED(/obj/machinery/atmospherics/pipe/manifold4w/hidden/##Type, "map", Name, Color, 1)		\
	HELPER_PARTIAL_NAMED(/obj/machinery/atmospherics/pipe/manifold4w/visible/##Type, "map", Name, Color, 2)

HELPER(general, null)
HELPER(black, PIPE_COLOR_BLACK)
HELPER(violet, PIPE_COLOR_VIOLET)
HELPER(blue, PIPE_COLOR_BLUE)
HELPER(cyan, PIPE_COLOR_CYAN)
HELPER(fuel, PIPE_COLOR_ORANGE)
HELPER(green, PIPE_COLOR_GREEN)
HELPER(red, PIPE_COLOR_RED)
HELPER(yellow, PIPE_COLOR_YELLOW)

HELPER_NAMED(scrubbers, "scrubbers pipe", rgb(255, 0, 0))
HELPER_NAMED(supply, "air supply pipe", rgb(0, 0, 255))
HELPER_NAMED(ch4_in, "coolant supply pipe", PIPE_COLOR_COOLANT_IN)
HELPER_NAMED(ch4_out, "coolant return pipe", PIPE_COLOR_COOLANT_OUT)

#undef HELPER_NAMED
#undef HELPER
#undef HELPER_PARTIAL_NAMED
#undef HELPER_PARTIAL
