//Here we handle weather, time, events, heat exchanging, etc.

SUBSYSTEM_DEF(planet)
	name = "Planet"
	wait = 10 SECONDS
	priority = SS_PRIORITY_PLANET
	init_order = SS_INIT_MISC_LATE

	var/list/zone/interpolating_zones = list()
	var/surface_time = 0

	var/weather_volatility = 0
	var/weather_volatility_mod = 1

#define TEMPERATURE_INTERPOLATION_MOD 0.1
/datum/controller/subsystem/planet/fire(resumed)
	//first of all, handle the heating of zones
	var/exterior_temperature = global.using_map.exterior_atmosphere.temperature
	for(var/zone/zone in SSair.zones)
		if(!zone.planet_heating_coefficient)
			continue
		var/zone_coefficient = zone.planet_heating_coefficient / length(zone.contents)
		var/datum/gas_mixture/environment = zone.air
		environment.temperature += (exterior_temperature - environment.temperature) * zone_coefficient * TEMPERATURE_INTERPOLATION_MOD
		environment.update_values()

	//weather next
	weather_volatility += weather_volatility_mod
	if(weather_volatility > 3)
		if(prob(weather_volatility * 5))
			using_map.weather_system.lightning_strike()
			weather_volatility -= 3
	using_map.weather_system.favorable_wind_speed = clamp(27 * weather_volatility, 0, 370)


#undef TEMPERATURE_INTERPOLATION_MOD