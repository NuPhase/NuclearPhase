/obj/machinery/material_processing/flotation
	name = "small flotation tank"
	desc = "A cheap and easy way to better separate ores. It's quite slow, though."
	icon_state = "flotation_tank-off"
	active_state = "flotation_tank"
	required_flag = ORE_FLAG_SEPARATED_CRUDE
	produced_flag = ORE_FLAG_SEPARATED_GOOD
	amount_processed = 0.33
	finish_message = "stops humming."

/obj/machinery/material_processing/flotation/large
	name = "large flotation tank"
	amount_processed = 4