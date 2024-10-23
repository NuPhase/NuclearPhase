/datum/map
	var/datum/gas_mixture/surface/exterior_atmosphere
	var/exterior_atmos_temp = T20C
	var/list/exterior_atmos_composition = list(
		/decl/material/gas/oxygen = O2STANDARD,
		/decl/material/gas/nitrogen = N2STANDARD
	)
	var/lightlevel = 0
	var/obj/abstract/weather_system/weather_system = null
	var/water_material = /decl/material/liquid/water     // Material to use for the properties of rain.
	var/ice_material =   /decl/material/solid/ice        // Material to use for the properties of snow and hail.
	var/area/planetary_area = /area

/datum/map/proc/build_exterior_atmosphere()
	exterior_atmosphere = new
	for(var/gas in exterior_atmos_composition)
		exterior_atmosphere.adjust_gas(gas, exterior_atmos_composition[gas], FALSE)
	exterior_atmosphere.temperature = exterior_atmos_temp
	exterior_atmosphere.update_values()
	exterior_atmosphere.check_tile_graphic()
	if(ispath(weather_system, /decl/state/weather))
		weather_system = new /obj/abstract/weather_system(null, 31, weather_system)
		weather_system.water_material = water_material
		weather_system.ice_material = ice_material

/datum/map/proc/get_exterior_atmosphere()
	if(exterior_atmosphere)
		var/datum/gas_mixture/gas = new
		gas.copy_from(exterior_atmosphere)
		return gas
