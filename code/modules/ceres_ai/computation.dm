#define COMPUTATION_SCORE_MIN 1

#define COMPUTATION_DIVISOR_MIN 0.001
#define COMPUTATION_DIVISOR_MEDIUM 0.01
#define COMPUTATION_DIVISOR_HARD 1

/decl/computation_type
	var/name
	var/description
	var/setting = 0 // amount of computational power demanded
	var/computation_score = COMPUTATION_SCORE_MIN
	var/computation_score_divisor = 1 // Higher = harder

/decl/computation_type/proc/handle_compute(power)
	if(!power)
		return
	var/decl/computation_type/optimization_decl = GET_DECL(/decl/computation_type/simulation)
	var/optimization_modifier = 1 + (optimization_decl.computation_score / 10000)
	computation_score += (power * optimization_modifier) / (computation_score * computation_score_divisor)

/decl/computation_type/simulation
	name = "Matrix Cluster Optimization"
	description = "Calibrating our servers will allow them to run more efficiently, and thus provide more data."
	computation_score_divisor = COMPUTATION_DIVISOR_MIN

/decl/computation_type/mining
	name = "Geological Data Analysis"
	description = "New ore veins can be discovered by analyzing existing earthquake data."
	computation_score_divisor = COMPUTATION_DIVISOR_MEDIUM

/decl/computation_type/reactor
	name = "Reactor Stability"
	description = "Complex CFD simulations can improve the plasma stability of the reactor. Computationally expensive."
	computation_score_divisor = COMPUTATION_DIVISOR_HARD

/decl/computation_type/surface
	name = "Surface Climate Prediction"
	description = "The incredibly unstable weather on the surface can be better understood using neural learning algorithms."
	computation_score_divisor = COMPUTATION_DIVISOR_MEDIUM

/decl/computation_type/radio_encryption
	name = "Radio Signals Decryption"
	description = "There are strange, encrypted radio signals coming from orbit. They can be decrypted with enough brute force. Will take around 8 TFLOPs of compute."
	computation_score_divisor = COMPUTATION_DIVISOR_HARD