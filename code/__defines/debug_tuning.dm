//#define DEBUG_TUNING

var/global/debug_tuning/debug_tuner = new

/debug_tuning
	var/med_normal_mcv = 4200 // Baseline blood circulation volume
	var/med_hemo_interp = 0.3 // Interpolation factor for hemodynamics

	var/eng_reactivity_multiplier = 0.001




#ifdef DEBUG_TUNING

#define NORMAL_MCV debug_tuner.med_normal_mcv
#define HEMODYNAMICS_INTERPOLATE_FACTOR debug_tuner.med_hemo_interp

#define REACTOR_REACTIVITY_MULT debug_tuner.eng_reactivity_multiplier

#else

#define NORMAL_MCV 4200
#define HEMODYNAMICS_INTERPOLATE_FACTOR 0.3
#define REACTOR_REACTIVITY_MULT 0.001

#endif