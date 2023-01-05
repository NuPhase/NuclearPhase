/area/example/first
	name = "\improper Testing Site First Floor"
	icon_state = "fsmaint"

/area/example/second
	name = "\improper Testing Site Second Floor"
	icon_state = "surgery"

/area/example/third
	name = "\improper Testing Site Third Floor"
	icon_state = "storage"

/area/turbolift/example
	name = "\improper Testing Site Elevator"
	icon_state = "shuttle"
	requires_power = FALSE
	dynamic_lighting = TRUE
	sound_env = STANDARD_STATION
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	ambience = list(
		'sound/ambience/ambigen3.ogg',
		'sound/ambience/ambigen4.ogg',
		'sound/ambience/ambigen5.ogg',
		'sound/ambience/ambigen6.ogg',
		'sound/ambience/ambigen7.ogg',
		'sound/ambience/ambigen8.ogg',
		'sound/ambience/ambigen9.ogg',
		'sound/ambience/ambigen10.ogg',
		'sound/ambience/ambigen11.ogg',
		'sound/ambience/ambigen12.ogg'
	)
	arrival_sound = null
	lift_announce_str = null

	base_turf = /turf/simulated/open

/area/turbolift/example/first
	name = "Testing Site First Floor Lift"
	base_turf = /turf/simulated/floor

/area/turbolift/example/second
	name = "Testing Site Second Floor Lift"

/area/turbolift/example/third
	name = "Testing Site Third Floor Lift"

/area/shuttle/ferry
	name = "\improper Testing Site Ferry"
	icon_state = "shuttle"

/area/avalon/has_gravity()
	return TRUE

/area/avalon/shelter/expeditionpreparation
/area/avalon/shelter/garage
/area/avalon/shelter/upperhall
/area/avalon/shelter/comms
/area/avalon/shelter/habitationdeck
/area/avalon/shelter/freezer
/area/avalon/shelter/messhall

/area/avalon/shelter/reactor
/area/avalon/shelter/reactormonitoring
/area/avalon/shelter/engineering
/area/avalon/shelter/atmos
/area/avalon/shelter/climatecontrol
/area/avalon/shelter/turbinehall
/area/avalon/shelter/machinehall
/area/avalon/shelter/breakerroom

/area/avalon/shelter/brig
/area/avalon/shelter/brig/interrogation
/area/avalon/shelter/brig/medbay
/area/avalon/shelter/brig/office
/area/avalon/shelter/brig/reception
/area/avalon/shelter/brig/breakroom
/area/avalon/shelter/brig/armory
/area/avalon/shelter/brig/preparation
/area/avalon/shelter/brig/prison
/area/avalon/shelter/brig/sergeantroom
/area/avalon/shelter/brig/barracks

/area/avalon/shelter/science

/area/surface
	name = "Surface"

/*	var/hot_blurb = ""
	var/cold_blurb = ""
*/
/area/surface/has_gravity()
	return TRUE

/*/area/surface/do_area_blurb(mob/living/L)
	var/blurb = ""
	if(air.temperature > 400)
		blurb = "<span class='boldannounce'>[hot_blurb]</span>"
	else
		blurb = "<span class='boldannounce'>[cold_blurb]</span>"
	to_chat(L, blurb)*/