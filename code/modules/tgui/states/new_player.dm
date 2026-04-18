/**
 * tgui state: new_player_state
 *
 * Checks that the user is a new_player, or if user is an admin
 */

var/global/datum/ui_state/new_player_state/tgui_new_player_state = new

/datum/ui_state/new_player_state/can_use_topic(src_object, mob/user)
	if(isnewplayer(user) || check_rights(R_ADMIN, FALSE, user.client))
		return UI_INTERACTIVE
	return UI_CLOSE

