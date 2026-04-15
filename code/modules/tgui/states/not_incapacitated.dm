/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: not_incapacitated_state
 *
 * Checks that the user isn't incapacitated
 */

var/global/datum/ui_state/not_incapacitated_state/tgui_not_incapacitated_state = new

/datum/ui_state/not_incapacitated_state/can_use_topic(src_object, mob/user)
	if(user.stat != CONSCIOUS)
		return UI_CLOSE
	if(user.incapacitated())
		return UI_DISABLED
	return UI_INTERACTIVE

/**
 * tgui state: not_incapacitated_turf_state
 *
 * Checks that the user isn't incapacitated and that their loc is a turf
 */

var/global/datum/ui_state/not_incapacitated_state/check_turfs/tgui_not_incapacitated_turf_state = new

/datum/ui_state/not_incapacitated_state/check_turfs/can_use_topic(src_object, mob/user)
	if(user.stat != CONSCIOUS)
		return UI_CLOSE
	if(user.incapacitated() || (!isturf(user.loc)))
		return UI_DISABLED
	return UI_INTERACTIVE
