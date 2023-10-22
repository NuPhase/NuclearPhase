// Used for creating the exchange areas.
/area/turbolift
	name = "Turbolift"
	base_turf = /turf/simulated/open
	requires_power = 0
	sound_env = SMALL_ENCLOSED
	is_outside = OUTSIDE_NO

	var/lift_floor_label = null
	var/lift_floor_name = null
	var/lift_announce_str = "Ding!"
	var/arrival_sound = 'sound/machines/ding.ogg'

/area/turbolift/avalon/main
	name = "Main Shelter Elevator"

/area/turbolift/avalon/main/a1
/area/turbolift/avalon/main/a2
	lift_floor_label = "Sector F"
	lift_floor_name = "Factory, Mining"
/area/turbolift/avalon/main/a3
/area/turbolift/avalon/main/a4
/area/turbolift/avalon/main/a5
/area/turbolift/avalon/main/a6
	lift_floor_label = "Sector E"
	lift_floor_name = "Medbay, Laboratories, Hydroponics"
/area/turbolift/avalon/main/a7
/area/turbolift/avalon/main/a8
	lift_floor_label = "Sector D"
	lift_floor_name = "Security, Administration"
/area/turbolift/avalon/main/a9
/area/turbolift/avalon/main/a10
	lift_floor_label = "Sector C"
	lift_floor_name = "Life Support, Reactor Unit, Engineering"
/area/turbolift/avalon/main/a11
/area/turbolift/avalon/main/a12
	lift_floor_label = "Sector B"
	lift_floor_name = "Habitation, Mess Hall"
/area/turbolift/avalon/main/a13
/area/turbolift/avalon/main/a14
	lift_floor_label = "Sector A"
	lift_floor_name = "Surface, Communications"

/area/turbolift/avalon/medbay
	name = "Medbay Elevator"

/area/turbolift/avalon/medbay/a1
	lift_floor_label = "1"
	lift_floor_name = "Surgery, Morgue, Patient Ward"
/area/turbolift/avalon/medbay/a2
	lift_floor_label = "2"
	lift_floor_name = "Intensive Care, Storage, Break Room"

/area/turbolift/avalon/factory
	name = "Manufacturing Elevator"
/area/turbolift/avalon/factory/a1
	lift_floor_label = "1"
	lift_floor_name = "Production Halls"
/area/turbolift/avalon/factory/a2
	lift_floor_label = "2"
	lift_floor_name = "Break Room, Changing Room"