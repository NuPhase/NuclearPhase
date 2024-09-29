/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: human_adjacent_state
 *
 * In addition to default checks, only allows interaction for a
 * human adjacent user.
 */

GLOBAL_DATUM_INIT(tgui_human_adjacent_state, /datum/ui_state/human_adjacent_state, new)

/datum/ui_state/human_adjacent_state/can_use_topic(src_object, mob/user)
	. = user.Adjacent(src_object) + (get_dist(src_object, user) < 4)