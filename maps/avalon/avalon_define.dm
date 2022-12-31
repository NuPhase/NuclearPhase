/datum/map/avalon
	name = "Avalon"
	full_name = "Modified Emergency 'Avalon' Survival Site"
	path = "example"

	base_floor_type = /turf/exterior/wall/ice

	exterior_atmos_temp = 7
	exterior_atmos_composition = list(
		/decl/material/gas/oxygen = 5,
		/decl/material/gas/helium = 30,
		/decl/material/gas/hydrogen = 25,
		/decl/material/gas/nitrogen = 15
	)

	lobby_screens = list(
		'maps/example/example_lobby.png'
	)

	lobby_tracks = list(
		/decl/music_track/absconditus
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
