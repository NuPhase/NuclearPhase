var/global/image/assigned = image('icons/area/zones_test.dmi', icon_state = "assigned")
var/global/image/created = image('icons/area/zones_test.dmi', icon_state = "created")
var/global/image/merged = image('icons/area/zones_test.dmi', icon_state = "merged")
var/global/image/invalid_zone = image('icons/area/zones_test.dmi', icon_state = "invalid")
var/global/image/air_blocked = image('icons/area/zones_test.dmi', icon_state = "block")
var/global/image/zone_blocked = image('icons/area/zones_test.dmi', icon_state = "zoneblock")
var/global/image/blocked = image('icons/area/zones_test.dmi', icon_state = "fullblock")
var/global/image/mark = image('icons/area/zones_test.dmi', icon_state = "mark")

/connection_edge/var/dbg_out = 0

/turf/var/tmp/dbg_img
/turf/proc/dbg(image/img, d = 0)
	if(d > 0) img.dir = d
	overlays -= dbg_img
	overlays += img
	dbg_img = img

/proc/soft_assert(thing,fail)
	if(!thing) message_admins(fail)