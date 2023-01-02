// Used for creating the exchange areas.
/area/turbolift
	name = "Turbolift"
	base_turf = /turf/simulated/open
	requires_power = 0
	sound_env = SMALL_ENCLOSED

	var/lift_floor_label = null
	var/lift_floor_name = null
	var/lift_announce_str = "Ding!"
	var/arrival_sound = 'sound/machines/ding.ogg'

/area/turbolift/avalon/main
	name = "Main Shelter Elevator"
	lift_floor_label = "Maintenance"
	lift_floor_name = "Maintenance"

/area/turbolift/avalon/main/a1
/area/turbolift/avalon/main/a2
/area/turbolift/avalon/main/a3
	lift_floor_label = "Sector E"
/area/turbolift/avalon/main/a4
/area/turbolift/avalon/main/a5
/area/turbolift/avalon/main/a6
/area/turbolift/avalon/main/a7
/area/turbolift/avalon/main/a8
	lift_floor_label = "Sector D"
/area/turbolift/avalon/main/a9
/area/turbolift/avalon/main/a10
	lift_floor_label = "Sector C"
/area/turbolift/avalon/main/a11
/area/turbolift/avalon/main/a12
	lift_floor_label = "Sector B"
/area/turbolift/avalon/main/a13
/area/turbolift/avalon/main/a14
	lift_floor_label = "Sector A"