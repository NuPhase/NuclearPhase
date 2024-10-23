// Volume is not constant, and pressure actually decreases with temperature since we vent gas into space.
/datum/gas_mixture/surface/cache_pressure()
	pressure = total_moles * R_IDEAL_GAS_EQUATION / (temperature / T0C)