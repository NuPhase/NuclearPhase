/datum/composite_sound/overheat_overpressure_alarm
	mid_sounds = list('sound/effects/alarms/overpressure_overheat.ogg'=1)
	mid_length = 5
	volume = 10

/datum/composite_sound/arm_alarm
	mid_sounds = list('sound/effects/alarms/laser_arm.ogg'=1)
	mid_length = 30
	volume = 10

/datum/composite_sound/purge_alarm
	mid_sounds = list('sound/effects/alarms/prepurgealarm.ogg'=1)
	mid_length = 500
	volume = 10
	sfalloff = 3

/datum/composite_sound/evac_alarm
	mid_sounds = list('sound/effects/alarms/evac.ogg'=1)
	mid_length = 35
	volume = 10



/datum/reactor_control_system
	var/list/alarm_list = list()
	var/list/trip_list = list()

/datum/reactor_control_system/proc/has_alarm(alarm_type)
	return (alarm_type in alarm_list)

/datum/reactor_control_system/proc/register_alarm(alarm_message, alarm_type, severity)
	if((alarm_type in alarm_list))
		return // already have one
	make_log(alarm_message, severity)
	alarm_list[alarm_type] = severity

/datum/reactor_control_system/proc/clear_alarm(alarm_type)
	alarm_list -= alarm_type


/datum/reactor_control_system/proc/has_trip(trip_type)
	return (trip_type in trip_list)

/datum/reactor_control_system/proc/register_trip(trip_message, trip_type)
	if((trip_type in trip_list))
		return // already have one
	do_message(trip_message, 3)
	make_log(trip_message, 3)
	trip_list += trip_type

/datum/reactor_control_system/proc/clear_trip(trip_type)
	trip_list -= trip_type