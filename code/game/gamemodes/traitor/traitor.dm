/datum/game_mode/traitor
	name = "traitor"
	round_description = "There are people wanting to betray you."
	config_tag = "traitor"
	required_players = 0
	required_enemies = 1
	associated_antags = list(/decl/special_role/traitor)
	antag_scaling_coeff = 5
	end_on_antag_death = FALSE
	latejoin_antags = list(/decl/special_role/traitor)
