/*
	MERCENARY ROUNDTYPE
*/

var/global/list/nuke_disks = list()

/decl/game_mode/nuclear
	name = "Mercenary"
	round_description = "A mercenary strike force is approaching!"
	extended_round_description = "A heavily armed merc team is approaching in their warship; whatever their goal is, it can't be good for the crew."
	uid = "mercenary"
	required_players = 15
	required_enemies = 1
	end_on_antag_death = FALSE
	probability = 1
	associated_antags = list(/decl/special_role/mercenary)
	cinematic_icon_states = list(
		"intro_nuke" = 35,
		"summary_nukewin",
		"summary_nukefail"
	)
	var/nuke_off_station = 0 //Used for tracking if the syndies actually haul the nuke to the station
	var/syndies_didnt_escape = 0 //Used for tracking if the syndies got the shuttle off of the z-level
