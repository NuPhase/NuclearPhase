/datum/map/avalon
	name = "Serenity"
	full_name = "'Serenity' Emergency Shelter"
	path = "avalon"

	system_name = "Sirius"
	station_name = "Serenity"
	station_short = "Serenity"
	game_year = 185

	base_floor_type = /turf/exterior/wall/ice

	exterior_atmos_temp = 7
	exterior_atmos_composition = list(
		/decl/material/gas/oxygen = 20,
		/decl/material/gas/helium = 700,
		/decl/material/gas/carbon_dioxide = 400,
		/decl/material/gas/carbon_monoxide = 100,
		/decl/material/gas/nitrogen = 150
	)
	lightlevel = 1
	weather_system = /decl/state/weather/snow/heavy
	water_material = /decl/material/gas/helium
	ice_material = /decl/material/solid/ice/hydrogen
	planetary_area = /area/surface

	lobby_screens = list(
		'maps/avalon/cdllobby.jpg',
		'maps/avalon/atom.jpg'
	)

	lobby_tracks = list(
		/decl/music_track/onewaytolife,
		/decl/music_track/runningaftermyfate,
		/decl/music_track/inthedark
	)

	allowed_spawns = list(
		/decl/spawnpoint/arrivals
	)

	shuttle_docked_message = "The shuttle has docked."
	shuttle_leaving_dock = "The shuttle has departed from home dock."
	shuttle_called_message = "A scheduled transfer shuttle has been sent."
	shuttle_recall_message = "The shuttle has been recalled"
	emergency_shuttle_docked_message = "The emergency escape shuttle has docked."
	emergency_shuttle_leaving_dock = "The emergency escape shuttle has departed from %dock_name%."
	emergency_shuttle_called_message = "An emergency escape shuttle has been sent."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled"
