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

#define TURF_HEATING_POWER 43 //watts per turf
/area/avalon
	name = "'Serenity' survival shelter"
	base_turf = /turf/simulated/floor/plating
	ambience = list('sound/ambience/ominous1.ogg', 'sound/ambience/ominous2.ogg', 'sound/ambience/ominous3.ogg', 'sound/ambience/rumble1.ogg', 'sound/ambience/rumble2.ogg', 'sound/ambience/rumble3.ogg', 'sound/ambience/rumble4.ogg')
	area_flags = AREA_FLAG_RAD_SHIELDED
	var/heating_consumption = 0
	is_outside = OUTSIDE_NO

/area/avalon/Initialize()
	. = ..()
	for(var/turf/T in contents)
		if(isturf(T))
			heating_consumption += TURF_HEATING_POWER

/area/avalon/usage(chan)
	switch(chan)
		if(LIGHT)
			return used_light + oneoff_light
		if(EQUIP)
			return used_equip + oneoff_equip
		if(ENVIRON)
			return used_environ + oneoff_environ + heating_consumption
		if(TOTAL)
			return .(LIGHT) + .(EQUIP) + .(ENVIRON)

/area/avalon/has_gravity()
	return TRUE

/area/avalon/shelter/expeditionpreparation
	name = "Expedition Preparation"
	icon_state = "research_dock"
/area/avalon/shelter/garage
	name = "Vehicle Garage"
	icon_state = "mechbay"
/area/avalon/shelter/upperhall
	name = "Upper Hall"
/area/avalon/shelter/staircase
	name = "Staircase"
	icon_state = "shuttle"
/area/avalon/shelter/comms
	name = "Communications"

/area/avalon/shelter/habitationdeck
	name = "Habitation Deck"
	icon_state = "dk_yellow"
/area/avalon/shelter/habitationdeck/crew
	name = "Crew Quarters"
	icon_state = "crew_quarters"
/area/avalon/shelter/habitationdeck/kitchen
	name = "Kitchen"
	icon_state = "kitchen"
/area/avalon/shelter/habitationdeck/freezer
	name = "Food Freezer"
	icon_state = "LP"
/area/avalon/shelter/habitationdeck/messhall
	name = "Mess Hall"
	icon_state = "bar"

/area/avalon/shelter/reactor
	sound_env = LARGE_ENCLOSED
	name = "Reactor Chamber"
	lightswitch = FALSE
	icon_state = "engine"
	background_radiation = 1.13

/area/avalon/shelter/reactor/power_change()
	. = ..()
	if(power_equip)
		forced_ambience = list('sound/ambience/reactorchamberfans.ogg')
		description = "You feel a heavy wind current flowing directly underneath you from several huge fans ventilating the vast space that you've entered. The entire chamber perimeter is dimly lit by small red lights, as if they were placed there specifically to be a little more sane in such an inconceivable environment. Everything below is barely visible, looks like it goes really deep..."
	else
		forced_ambience = null
		description = "You feel a strong metal smell in the still air of the vast space that you've entered. The entire chamber perimeter is dimly lit by small red lights, as if they were placed there specifically to be a little more sane in such an inconceivable environment. Everything below is completely dark, looks like it goes really deep..."

/area/avalon/shelter/reactormonitoring
	name = "Reactor Control Room"
	area_flags = AREA_FLAG_RAD_SHIELDED
	background_radiation = 0.07
/area/avalon/shelter/engineering
	name = "Engineering 2nd Floor"
	icon_state = "engineering"
/area/avalon/shelter/engineering_first
	name = "Engineering 1st Floor"
	icon_state = "engineering_foyer"
/area/avalon/shelter/atmos
	name = "Fluid Management"
	icon_state = "atmos"
/area/avalon/shelter/climatecontrol
	name = "Climate Control"
/area/avalon/shelter/turbinehall
	name = "Turbine Hall"
	sound_env = LARGE_ENCLOSED
/area/avalon/shelter/machinehall
	name = "Machine Hall"
	sound_env = LARGE_ENCLOSED
/area/avalon/shelter/breakerroom
	name = "Breaker Room"
	var/powered_ambience = list('sound/ambience/breaker_room.wav')
	forced_ambience = list('sound/ambience/breaker_room.wav')
/area/avalon/shelter/breakerroom/power_change()
	. = ..()
	if(power_equip)
		forced_ambience = powered_ambience
	else
		forced_ambience = null

/area/avalon/shelter/service_tunnels
	name = "Reactor Service Tunnels"
	ambience = list('sound/ambience/maint1.ogg', 'sound/ambience/maint2.ogg')

/area/avalon/shelter/maintenance
	name = "Maintenance"
	ambience = list()
	var/powered_ambience

/area/avalon/shelter/maintenance/power_change()
	. = ..()
	if(power_equip)
		forced_ambience = powered_ambience
	else
		forced_ambience = null

/area/avalon/shelter/maintenance/Initialize()
	. = ..()
	powered_ambience = list(pick('sound/machines/vent/running1.wav', 'sound/machines/vent/running2.wav', 'sound/machines/vent/running3.wav')) //has to be a list, sorry
	forced_ambience = powered_ambience

/area/avalon/shelter/brig
	name = "Security"
	area_flags = AREA_FLAG_SECURITY
/area/avalon/shelter/brig/interrogation
	name = "Security Interrogation"
/area/avalon/shelter/brig/medbay
	name = "Security Medbay"
/area/avalon/shelter/brig/office
	name = "Security Office"
/area/avalon/shelter/brig/reception
	name = "Security Reception"
/area/avalon/shelter/brig/breakroom
	name = "Security Break Room"
/area/avalon/shelter/brig/armory
	name = "Armory"
/area/avalon/shelter/brig/preparation
	name = "Security Preparations"
/area/avalon/shelter/brig/prison
	name = "Security Prison"
	area_flags = AREA_FLAG_PRISON
/area/avalon/shelter/brig/sergeantroom
	name = "Security Sergeant Room"
/area/avalon/shelter/brig/barracks
	name = "Security Barracks"

/area/avalon/shelter/command
	name = "Command"
/area/avalon/shelter/command/commcenter
	name = "Comm Center"


/area/avalon/shelter/cargo/warehouse
	name = "Main Warehouse"
	name = "storage"

/area/avalon/shelter/cargo/rest_area
	name = "Supply Operations Break Room"
	icon_state = "auxstorage"

/area/avalon/shelter/medbay
	name = "Medbay"
	icon_state = "medbay3"

/area/avalon/shelter/medbay/surgery
	name = "Surgery"
	icon_state = "surgery"

/area/avalon/shelter/medbay/break_room
	name = "Medbay Break Room"
	icon_state = "medbay4"

/area/avalon/shelter/medbay/storage
	name = "Medbay Storage"
	icon_state = "medbay"

/area/avalon/shelter/medbay/morgue
	name = "Morgue"
	icon_state = "medbay4"

/area/avalon/shelter/medbay/intensive_care
	name = "Intensive Care"
	icon_state = "medbay2"

/area/avalon/shelter/medbay/chemistry
	name = "Chemistry"
	icon_state = "medbay"

/area/avalon/shelter/factory
	name = "Factory"

/area/avalon/shelter/science
	name = "Research Labs"
	icon_state = "research"


/area/turbolift/e1
	lift_floor_label = "Tech Operations Lobby"
/area/turbolift/e2
	lift_floor_label = "Machine Hall"
/area/turbolift/e3
	lift_floor_label = "Reactor Operations"

/area/surface
	name = "Surface"
	var/list/hot_ambience = list('sound/ambience/magma.ogg')
	var/list/cold_ambience = list('sound/music/calmnight.ogg', 'sound/music/facilityoutside.ogg', 'sound/music/outside1.ogg', 'sound/music/outside2.ogg', 'sound/music/outside3.ogg')
	forced_ambience = list('sound/music/calmnight.ogg', 'sound/music/facilityoutside.ogg', 'sound/music/outside1.ogg', 'sound/music/outside2.ogg', 'sound/music/outside3.ogg')
	ambience_volume = 75
	has_gravity = TRUE
	is_outside = OUTSIDE_YES
	var/phase = 0
	base_turf = /turf/exterior/surface
	should_condense = FALSE
	area_flags = AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_BACKGROUND
	var/list/cold_descriptions = list(
		"The most beautiful hellscape you've ever seen, something that only someone truly worthy deserves to witness. There are a ton of slow-moving cloud-like formations, are they made of liquid?",
		"You step out to the vast and barren wasteland that the world turned into. You can't help but feel sad and amazed at the same time. There is something special and romantic about these undescribable views.",
		"You witness something from your dreams, back from when you imagined how the surface looked like. It looks surprisingly beautiful and lively, is it really that bad around here?"
	)
	var/list/hot_descriptions = list()
	background_radiation = 1490

/area/surface/location //more intense
	cold_ambience = list('sound/music/lurk.ogg')

/area/surface/location/skyscraper

/area/surface/location/space_center

/area/surface/Initialize()
	. = ..()
	surface_areas += src

/area/surface/do_area_blurb(mob/living/L)
	if(L?.get_preference_value(/datum/client_preference/area_info_blurb) != PREF_YES)
		return

	if(!(L.ckey in blurbed_stated_to))
		blurbed_stated_to += L.ckey
		if(phase == 1) //hot
			to_chat(L, SPAN_SUBTLE("[pick(hot_descriptions)]"))
		else
			to_chat(L, SPAN_SUBTLE("[pick(cold_descriptions)]"))

/area/surface/proc/switch_phases(var/newphase)
	if(newphase == 1) //hot
		forced_ambience = hot_ambience
	else
		forced_ambience = cold_ambience
	phase = newphase

/area/surface/has_gravity()
	return TRUE

/area/surface/Entered(mob/A)
	. = ..()
	if(ishuman(A))
		var/obj/abstract/weather_system/weather = using_map.weather_system
		weather.windloop_play_atoms += A
		surface_mobs += A
		for(var/obj/item/gun/W in A.contents)
			if(W.hot_color && phase)
				W.color = W.hot_color

/area/surface/Exited(mob/A)
	. = ..()
	if(ishuman(A))
		var/obj/abstract/weather_system/weather = using_map.weather_system
		weather.windloop_play_atoms -= A
		surface_mobs -= A
		for(var/obj/item/gun/W in A.contents)
			if(W.hot_color)
				W.color = null

/*/area/surface/do_area_blurb(mob/living/L)
	var/blurb = ""'sound/ambience/ambigen1.ogg'
	if(air.temperature > 400)
		blurb = "<span class='boldannounce'>[hot_blurb]</span>"
	else
		blurb = "<span class='boldannounce'>[cold_blurb]</span>"
	to_chat(L, blurb)*/

/area/surface/tent

/area/skyscraper
	name = "Skyscraper"
	requires_power = FALSE
	forced_ambience = list('sound/music/skyscraper_theme_1.ogg')
	should_condense = FALSE

/area/limb
	name = "Limb"
	requires_power = FALSE
	should_condense = FALSE
	area_flags = AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_BACKGROUND
	has_gravity = TRUE
	forced_ambience = list('sound/music/sunset.ogg')