#define POWERCHAN_OFF		0	// Power channel is off
#define POWERCHAN_OFF_TEMP	1	// Power channel is off until there is power
#define POWERCHAN_OFF_AUTO	2	// Power channel is off until power passes a threshold
#define POWERCHAN_ON		3	// Power channel is on until there is no power
#define POWERCHAN_ON_AUTO	4	// Power channel is on until power drops below a threshold

#define APC_POWERCHAN_EQUIPMENT 1
#define APC_POWERCHAN_LIGHTING 2
#define APC_POWERCHAN_ENVIRONMENT 3

#define POWERNET_WATTAGE(powernet) (powernet.voltage ? min(powernet.lavailable, powernet.ldemand) : 0)
#define POWERNET_AMPERAGE(powernet) (powernet.voltage ? (min(powernet.max_power, powernet.ldemand) / powernet.voltage) : 0)
#define POWERNET_HEAT(powernet, resistance) ((POWERNET_AMPERAGE(powernet)**2) * (resistance))

// {J} -> {delta K}
#define POWER2HEAT(j) (0.30462405 * (j))